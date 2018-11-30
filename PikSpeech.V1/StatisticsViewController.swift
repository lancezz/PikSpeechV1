//
//  StatisticsViewController.swift
//  PikSpeech.V1
//
//  Created by Lance Zhang on 2018-11-28.
//  Copyright © 2018 cmpt275group11. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class StatisticsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var topFiveTileData = [TileData]()
    var dailyInformationArray = [DailyInformation]()
    var dataPointArray = [DataPoint]()

    @IBAction func weekMonthSwitch(_ sender: Any) {
        //compile a different set of data, give it to the graph
    }
    
    @IBOutlet weak var topFiveCollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let width = view.frame.size.width / 6.0
        
        let layout = topFiveCollection.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.itemSize = CGSize(width: width, height: width)
        
        topFiveCollection.delegate = self
        topFiveCollection.dataSource = self
    
        //data setup
        let user = Auth.auth().currentUser
        guard let uid = user?.uid else
        {
            return
        }
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let userRef = ref.child("user").child(uid)
        
//        print("-------------------------------------------------\n")
//        print("looking into the dailyInformation")
        userRef.child("dailyInformation").observe(DataEventType.value, with:
            { (snapshot) in
//                print("shown is the snapshot:\n",snapshot)
                
                //set up the datapoints list
                let dailyInformationQueryArray = snapshot.value as? NSArray ?? []
//                print("here is the snapshot that was turned to a dictionary\n", dailyInformationQueryArray)
                for currentDailyInformation in dailyInformationQueryArray{
                    let postDict = currentDailyInformation as? NSDictionary
//                    print("looking into the specific dailyInformationElement:\n", postDict!)
                    
                    
                    var dailyInformationDate : NSDate? = nil
                    var currentTop5WordsArray = [WordCounter]()
                    //go for each attribute in the category
                    
                    //traverse through the DailyInformation query
                    for dailyInformationData in postDict!{
//                        print("now traversing through the data of the dailyInformationElement:\n")
                        if(dailyInformationData.key as? String == "timeStamp"){
                            //record the timestamp as an nsdate
//                            print("found a timestamp\n")
                            let dailySessionInformationTimeInterval = dailyInformationData.value as? TimeInterval
                            dailyInformationDate = NSDate(timeIntervalSince1970: dailySessionInformationTimeInterval ?? 0)
                            
                            //TODO: also have a check on what day it is so that you can log the top 5 words
                            //you will need to do an observe on tileData to get tileData
                        }
                        else{
                            //it must be the top 5 words
//                            print("found the top 5 words")
                            let top5Words = dailyInformationData.value as? Array ?? []
//                            print("created an array out of what we found, here it is:\n", top5Words)
                            for currentTopWord in top5Words{
                                let topWord = currentTopWord as? NSDictionary
//                                print("turned this data into a dictionary, here it is: \n", topWord)
                                var currentWord = "ERROR"
                                var currentCount = -1
                                for wordAttribute in topWord!{
                                    if(wordAttribute.key as? String == "word"){
//                                        print("the word was found to be: ", wordAttribute.value, "\n")
                                        currentWord = wordAttribute.value as? String ?? "ERROR"
                                    }
                                    else{
//                                        print("the frequency was found to be: ", wordAttribute.value, "\n")
                                        currentCount = wordAttribute.value as? Int ?? -1
                                    }
                                }
                                currentTop5WordsArray.append(WordCounter(word: currentWord, count: currentCount))
                            }
                        }
                    }
                    self.dailyInformationArray.append(DailyInformation(logDate: dailyInformationDate!, top5WordsArray: currentTop5WordsArray))
                }
                //at this point, you have created all of your daily information stuff
                
                //used for debugging rn
                var counter = 0
                for myDailyInfo in self.dailyInformationArray{
                    print("currentDailyInfo: ", counter)
                    print("\tlogDate: ", myDailyInfo.getLogDate())
                    print("\ttop5Words: \n")
                    for curTop5Word in myDailyInfo.getTop5WordsArray(){
                        print("\t\tword: ", curTop5Word.getWord())
                        print("\t\tfrequency: ", curTop5Word.getCount())
                    }
                    counter += 1
                }
                
                //here we want to get the most recent stuff
                
                //find the dailyInformation that is the most recent
                var indexToUse = 0
                var currentIndex = 0
                var mostCurrentDate = NSDate(timeIntervalSince1970: 0)
                for currentDailyInfo in self.dailyInformationArray{
                    if currentDailyInfo.getLogDate().compare(mostCurrentDate as Date) == ComparisonResult.orderedDescending{
                        mostCurrentDate = currentDailyInfo.getLogDate()
                        print("the most recent date is now ", mostCurrentDate)
                        indexToUse = currentIndex
                    }
                    currentIndex += 1
                }
                
                //put all the top 5 words in a string
                var top5WordsString = [String]()
                for currentTop5WordofCurrent in self.dailyInformationArray[indexToUse].getTop5WordsArray(){
                    top5WordsString.append(currentTop5WordofCurrent.getWord())
                }
                
                //set up the tile data now that we have the 5 words
                userRef.child("tileData").observe(DataEventType.value, with:
                    {
                        (snapshot) in
                        let dictTileData = snapshot.value as? NSDictionary
                        for currentTileData in dictTileData!{
                            print(currentTileData)
                            let currentTileDataKey = currentTileData.key as! String
                            for currentTop5Word in top5WordsString{
                                if currentTop5Word == currentTileDataKey{
                                    let currentTileDataInfo = currentTileData.value as? NSDictionary
                                    self.topFiveTileData.append(TileData(currentTileDataInfo!["Image"] as! String, currentTileDataInfo!["title"] as! String))
                                }
                            }
                        }
                        self.topFiveCollection.reloadData()
                        
                        //at this point, all tile data has been loaded
                        
                        //now load all the datapoints with default as your top one
                        //sort daily information based on
                        self.setDataPointsForWord(wordOfInterest: self.topFiveTileData[0].getImageTitle())
                })
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topFiveTileData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! Tile
        cell.tileData = topFiveTileData[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        //look for all daily info with the correct word
        //generate the new array from that
        setDataPointsForWord(wordOfInterest: topFiveTileData[indexPath.row].getImageTitle())
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func setDataPointsForWord(wordOfInterest: String){
        //sort your dailyInformation based on date???
        //we might need to care about this cuz it might already be good in firebase
        
        //make sure to reset the datapoint array
        dataPointArray.removeAll()
        for dailyInformation in dailyInformationArray{
            for wordCount in dailyInformation.getTop5WordsArray(){
                if wordCount.getWord() == wordOfInterest{
                    dataPointArray.append(DataPoint(date: dailyInformation.getLogDate(), frequency: wordCount.getCount()))
                }
            }
        }
    }
}
