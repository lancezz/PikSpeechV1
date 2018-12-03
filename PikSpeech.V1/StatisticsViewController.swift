//
//  StatisticsViewController.swift
//  PikSpeech.V1
//
//  Created by Lance Zhang on 2018-11-28.
//  Copyright © 2018 cmpt275group11. All rights reserved.
//
//  Change Log:
//      2018-11-28: Created initializeChart() function                    (Miguel Taningco & Sheel Soneji)
//      2018-11-29: Created setDataPointsForWord() function               (Miguel Taningco & Sheel Soneji)
//      2018-11-30: Provided documentation & tied it together with quering                           (Miguel Taningco & Sheel Soneji)

import UIKit
import SwiftChart
import FirebaseDatabase
import Firebase

enum GraphResulotion{
    case WEEK, MONTH
}

class StatisticsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, ChartDelegate {

    var topFiveTileData = [TileData]()
    var dailyInformationArray = [DailyInformation]()
    var dataPointArray = [DataPoint]()
    var graphResolution = GraphResulotion.WEEK
    var currentWord = ""

    @IBOutlet weak var LabelLeadingMarginConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var chart: Chart!
    fileprivate var labelLeadingMarginInitialConstant: CGFloat!
    @IBAction func weekMonthSwitch(_ sender: UISegmentedControl) {
        //compile a different set of data, give it to the graph
        var state = sender.titleForSegment(at: sender.selectedSegmentIndex) ?? "Week"
        graphResolution = state == "Week" ? GraphResulotion.WEEK : GraphResulotion.MONTH
        setWeekDataPointsForWord(wordOfInterest: currentWord, graphRes: graphResolution)
        print("here")
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
        
        
        self.label.text = "You have not used the app enough for any data to be compiled"
    
        //data setup
        let user = Auth.auth().currentUser
        guard let uid = user?.uid else
        {
            return
        }
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let userRef = ref.child("user").child(uid)
        
        userRef.child("dailyInformation").observe(DataEventType.value, with:
            { (snapshot) in
//                print("shown is the snapshot:\n",snapshot)
                
                //set up the datapoints list
                let dailyInformationQueryArray = snapshot.value as? [String: AnyObject] ?? [:]
//                print("here is the snapshot that was turned to a dictionary\n", dailyInformationQueryArray)
                for currentDailyInformation in dailyInformationQueryArray{
                    let postDict = currentDailyInformation.value as? NSDictionary
//                    print("looking into the specific dailyInformationElement:\n", postDict!)
                    
                    
                    var dailyInformationDate : NSDate? = nil
                    var currentTop5WordsArray = [WordCounter]()
                    var hasTop5Words = false
                    //go for each attribute in the category
                    
                    //traverse through the DailyInformation query
                    for dailyInformationData in postDict!{
//                        print("now traversing through the data of the dailyInformationElement:\n")
                        if(dailyInformationData.key as? String == "timeStamp"){
                            //record the timestamp as an nsdate
//                            print("found a timestamp\n")
                            let dailySessionInformationTimeInterval = dailyInformationData.value as? TimeInterval
                            dailyInformationDate = NSDate(timeIntervalSince1970: dailySessionInformationTimeInterval ?? 0)
                            
                        }
                        else if(dailyInformationData.key as? String == "top5Words"){
                            hasTop5Words = true
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
                    if hasTop5Words{
                        self.dailyInformationArray.append(DailyInformation(logDate: dailyInformationDate!, top5WordsArray: currentTop5WordsArray))
                    }
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
                var indexToUse = -1
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
                
                if indexToUse == -1{
                    //there are no dailyInformation data, you need to press at least once on 2 separate days for it to work
                    return;
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
                        self.topFiveTileData = self.topFiveTileData.sorted(by: {$0.getImageTitle() > $1.getImageTitle()})
                        
                        self.topFiveCollection.reloadData()
                        
                        //at this point, all tile data has been loaded
                        
                        //now load all the datapoints with default as your top one
                        //sort daily information based on
                        self.currentWord = self.topFiveTileData[0].getImageTitle()
                        self.setWeekDataPointsForWord(wordOfInterest: self.topFiveTileData[0].getImageTitle(), graphRes: self.graphResolution)
                        self.initializeChart()
                        
                })
        })
        
    }//view did load
    
    func initializeChart() {
        chart.delegate = self
        setUpDataWithChart(dataArray: dataPointArray)
        
        chart.areaAlphaComponent = 0.5
        chart.backgroundColor = .white
          // ECD1DF
        chart.axesColor = .black
        chart.lineWidth = 1
        chart.labelFont = UIFont.systemFont(ofSize: 7)
        chart.labelColor = .black
        chart.xLabelsTextAlignment = .center
        chart.yLabelsOnRightSide = true
        
        
    }
    // Chart delegate
    
    func setUpDataWithChart(dataArray: [DataPoint]){
        label.text = ""
        chart.removeAllSeries()
        var seriesData: [Double] = []
        var labels: [Double] = []
        var labelsAsString: Array<String> = []
        var xLabels = [Double]()
        
        var data = [(x: Double, y: Double)]()
        var counter = 0.0
        var minX = Double.greatestFiniteMagnitude
        var maxX = 0.0
        for datapoint in dataArray {
            
            seriesData.append(Double(datapoint.getFrequency()))

            let compdate = datapoint.getLogDateAsString()
           
            minX = minX > datapoint.getDate().timeIntervalSince1970 ? datapoint.getDate().timeIntervalSince1970 : minX
            maxX = maxX < datapoint.getDate().timeIntervalSince1970 ? datapoint.getDate().timeIntervalSince1970 : maxX
            data.append((x: datapoint.getDate().timeIntervalSince1970, y: Double(datapoint.getFrequency())))
            print (compdate)
            labels.append(counter)
            labelsAsString.append(compdate)
            counter += 1
           
        }
        
        if graphResolution == GraphResulotion.WEEK{
            for i in -1 ... 6{
                xLabels.append(maxX - Double(i*3600*24))
            }
        }
        else{
            for i in -1 ... 4{
                xLabels.append(maxX - Double(i*3600*24*7))
            }
        }
        
        chart.xLabels = xLabels
        
        let series = ChartSeries(data: data)
        //        let series = ChartSeries(seriesData)
        series.area = true
        series.color = ChartColors.colorFromHex(0x454545)
        
        // Configure chart layout
        
        
        
        //        chart.xLabels = labels
        chart.xLabelsFormatter = { (labelIndex: Int, labelValue: Double) -> String in
            
            
            if labelsAsString.count != 0{
                //                return labelsAsString[labelIndex]
                return DataPoint(date: NSDate(timeIntervalSince1970: labelValue), frequency: 0).getLogDateAsString()
                
            }
            return "AKJSHDFKJHASDFJK"
        }
        //        // Add some padding above the x-axis
        chart.minY = 0
        
        chart.add(series)
    }
    
    func didTouchChart(_ chart: Chart, indexes: Array<Int?>, x: Double, left: CGFloat) {
     
        
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
        label.text = ""
        //LabelLeadingMarginConstraint.constant = labelLeadingMarginInitialConstant
    }
    
    func didEndTouchingChart(_ chart: Chart) {
        
    }
    
    
    func getStockValues() -> Array<Dictionary<String, Any>> {
        
        // Read the JSON file
        let filePath = Bundle.main.path(forResource: "AAPL", ofType: "json")!
        let jsonData = try? Data(contentsOf: URL(fileURLWithPath: filePath))
        let json: NSDictionary = (try! JSONSerialization.jsonObject(with: jsonData!, options: [])) as! NSDictionary
        let jsonValues = json["quotes"] as! Array<NSDictionary>
        
        // Parse data
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let values = jsonValues.map { (value: NSDictionary) -> Dictionary<String, Any> in
            let date = dateFormatter.date(from: value["date"]! as! String)
            let close = (value["close"]! as! NSNumber).doubleValue
            return ["date": date!, "close": close]
        }
        
        return values
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        
        // Redraw chart on rotation
        chart.setNeedsDisplay()
        
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
        currentWord = topFiveTileData[indexPath.row].getImageTitle()
        setWeekDataPointsForWord(wordOfInterest: topFiveTileData[indexPath.row].getImageTitle(), graphRes: graphResolution)
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
        
        //used for debugging
        print("switching to word: ", wordOfInterest)
        for dataPoint in dataPointArray{
            print("date: ", dataPoint.getDate(), ", frequency: ", dataPoint.getFrequency())
        }
        
        
        dataPointArray = dataPointArray.sorted(by: {$0.getDate().timeIntervalSince1970 < $1.getDate().timeIntervalSince1970})
        
        print("switching to word: ", wordOfInterest)
        for dataPoint in dataPointArray{
            print("date: ", dataPoint.getDate(), ", frequency: ", dataPoint.getFrequency())
        }
        
        setUpDataWithChart(dataArray: dataPointArray)
    }
    
    func setWeekDataPointsForWord(wordOfInterest: String, graphRes : GraphResulotion){
        //here we only output the word of interest for 1 week
        
        dataPointArray.removeAll()
        var mostRecentTimeInterval = NSDate(timeIntervalSince1970: 0).timeIntervalSince1970
        for dailyInformation in dailyInformationArray{
            for wordCount in dailyInformation.getTop5WordsArray(){
                if wordCount.getWord() == wordOfInterest{
                    mostRecentTimeInterval = mostRecentTimeInterval < dailyInformation.getLogDate().timeIntervalSince1970 ? dailyInformation.getLogDate().timeIntervalSince1970 : mostRecentTimeInterval;
                    dataPointArray.append(DataPoint(date: dailyInformation.getLogDate(), frequency: wordCount.getCount()))
                }
            }
        }
        //at this point, dataPointArray contains all info of the word
        let resolution = graphRes == GraphResulotion.WEEK ? 7.0 : 30.0
        
        let interval7WeeksBefore = mostRecentTimeInterval - 3600*24*resolution
        
        //now we want to only get it within the past week
        var tempDataPointArray = [DataPoint]()
        for dataPoint in dataPointArray{
            //if it lies within the bounds, put that into the temp array
            if dataPoint.getDate().timeIntervalSince1970 >= interval7WeeksBefore && dataPoint.getDate().timeIntervalSince1970 <= mostRecentTimeInterval{
                tempDataPointArray.append(dataPoint)
            }
        }
        
        dataPointArray = tempDataPointArray
        
        //used for debugging
        print("switching to word: ", wordOfInterest)
        for dataPoint in dataPointArray{
            print("date: ", dataPoint.getDate(), ", frequency: ", dataPoint.getFrequency())
        }
        
        
        dataPointArray = dataPointArray.sorted(by: {$0.getDate().timeIntervalSince1970 < $1.getDate().timeIntervalSince1970})
        
        print("switching to word: ", wordOfInterest)
        for dataPoint in dataPointArray{
            print("date: ", dataPoint.getDate(), ", frequency: ", dataPoint.getFrequency())
        }
        
        setUpDataWithChart(dataArray: dataPointArray)
    }
    
    func setMonthDataPointsForWord(wordOfInterest: String){
        //here we only output the word of interst for 1 month
    }
}
