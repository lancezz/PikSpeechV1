//
//  ViewController.swift
//  PikSpeech.V1
//
//  Created by Lance Zhang on 2018-11-01.
//  Collaboration with Miguel Taningco and Sheel Soneji
//  Copyright © 2018 CMPT 275 Group11: A-team. All rights reserved.
//
//  Change Log:
//      11/02/2018: Created the three different collectionViews and basic UI        (Lance Zhang)
//      11/03/2018: Created Speech Button and Backspace Button                      (Lance Zhang)
//                  Made segue for the settings activity                            (Lance Zhang)
//      11/04/2018: Implemented behaviours of different collectionViews             (Miguel Taningco)
//                  Created TileData and Tile classes                               (Miguel Taningco)
//                  Data flow of tiles now correctly illustrated by collectionViews (Miguel Taningco)
//                  Implemented Text-to-Speech feature                              (Lance Zhang)
//      11/05/2018: Provided documentation                                          (Miguel Taningco)
//      11/18/2018: Allowed to authenticate users and query for data                (Miguel Taningco and Lance Zhang)


import UIKit
import AVFoundation
import FirebaseDatabase
import Firebase
import FirebaseStorage





//  ViewController Class controls the views of the app and manages the flow of data within the main activity
class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    var speechBarTileData = [TileData]()
    var selectionBarTileData = Initializer.getDefaultSelectionBarData()
    var categoryBarTileData = Initializer.getCategoryData()
    var appDataTileData = Initializer.getAppDataTileData()
    
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    
    
    @IBOutlet weak var selectionCollection: UICollectionView!
    
    //  Deletes 2 Tile objects from the SpeechBar array when DeleteButton is held
    @IBAction func holddeletion(_ sender: Any){
        if speechBarTileData.count > 0 {
            speechBarTileData.removeLast()
            
            if speechBarTileData.count > 0 {
               speechBarTileData.removeLast()
            }
            sentenceCollection.reloadData()
            sentenceCollection.layoutIfNeeded()
        }
    }
    
    //  Text-to-Speech activates on the SpeechBar array when SpeakButton is tapped
    @IBAction func speakButton(_ sender: Any){
        for TileData in speechBarTileData{
            myUtterance = AVSpeechUtterance(string: TileData.getImageTitle())
            myUtterance.rate = 0.3
            synth.speak(myUtterance)
        }
    }
    
    //  Deletes one Tile object from the SpeechBar array when DeleteButton is tapped
    @IBAction func deletionButton(_ sender: Any){
        if speechBarTileData.count > 0{
        speechBarTileData.removeLast()
            sentenceCollection.reloadData()
            sentenceCollection.layoutIfNeeded()
        }
    }
    
    @IBOutlet weak var categoryCollection: UICollectionView!
    @IBOutlet weak var sentenceCollection: UICollectionView!
    
    //  Segues into the SettingsSegue
    @IBAction func settingsButton(_sender: UIButton){
        performSegue(withIdentifier: "SettingsSegue", sender: self)
    }
    
    //  Initializes properties of views
    override func viewDidLoad(){
        super.viewDidLoad()
        //Firebase
        
        //Firebase
        //All these are default things
        let actualWidth = view.frame.size.width
        let width = view.frame.size.width / 6.0
        let layout = selectionCollection.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.itemSize = CGSize(width: width, height: width)
        
        selectionCollection.delegate = self
        selectionCollection.dataSource = self
        
        categoryCollection.delegate = self
        categoryCollection.dataSource = self
        
        sentenceCollection.delegate = self
        sentenceCollection.dataSource = self
        
        
        //Download actual Data
        TileSizeManager.downloadTilesPerRow(viewWidth: actualWidth, collectionView: selectionCollection)
        ColorManager.downloadColorForCollectionView(collectionView: selectionCollection, collectionEnum: SpecificCollectionView.selectionCollectionView, appView: view)
        ColorManager.downloadColorForCollectionView(collectionView: categoryCollection, collectionEnum: SpecificCollectionView.categoryCollectionView, appView: view)
        ColorManager.downloadColorForCollectionView(collectionView: sentenceCollection, collectionEnum: SpecificCollectionView.speechCollectionView, appView: view)
        
        downloadAllSelectionDataAs2DArray()
        
        
    }
    
    //  Provides the necessary behaviour when view appears
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    //  Returns an Int for the proper size of a given UICollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if collectionView == self.selectionCollection{
            return selectionBarTileData.count
        }
        else if collectionView == self.categoryCollection{
            return categoryBarTileData.count
        }
        else{
            return speechBarTileData.count
        }
    }
    
    //  Returns a UICollectionViewCell for the respective UICollectionView at the proper indexPath
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        if collectionView == self.selectionCollection{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! Tile
            cell.tileData = selectionBarTileData[indexPath.row]
            return cell
        }
        else if collectionView == self.categoryCollection{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! Tile
            cell.tileData = categoryBarTileData[indexPath.row]
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! Tile
            cell.tileData = speechBarTileData[indexPath.row]
            return cell
        }
    }
    
    //  Assigns the appropriate behaviour based on the given UICollectionView and indexPath
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        if collectionView == self.selectionCollection{
            speechBarTileData.append(selectionBarTileData[indexPath.row])
            sentenceCollection.reloadData()
            sentenceCollection.layoutIfNeeded()
        }
        else if collectionView == self.categoryCollection{
            selectionBarTileData = replaceSelectionDataForCategory(indexPath.row)
            selectionCollection.reloadData()
            selectionCollection.layoutIfNeeded()
        }
        else{
            //do nothing
        }
    }
    
    //  Returns an array of TileData to used for the overwriting of the list of the selectionBarTileData
    func replaceSelectionDataForCategory(_ categoryIndex: Int) -> [TileData]{
        return appDataTileData[categoryIndex]
    }
    
    func downloadAllSelectionDataAs2DArray(){
        let user = Auth.auth().currentUser
        guard let uid = user?.uid else
        {
            return
        }
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let userRef = ref.child("user").child(uid)
        
        //Listen to changes under categoryData JSON tree
        userRef.child("categoryData").observe(DataEventType.value, with:
            {
                (snapshot) in
                print("entered the observe function, the snapshot for this one is")
                print(snapshot)
                let dict = snapshot.value as? NSDictionary
                var downloadedCategoryData = [TileData]()
                var downloadedAppData2DString = [[String]]()
                
                
                //go through each category
                for currentCategory in dict!{
                    let postDict = currentCategory.value as? NSDictionary

                    var categoryImageFileName = ""
                    let categoryTitle = currentCategory.key as! String
                    
                    //go for each attribute in the category
                    for categoryChild in postDict!{
                        
                        if(categoryChild.key as? String == "selectionData"){
                            let selectionDataArray = categoryChild.value as? NSArray
                            var stringDataArrayForSection = [String]()
                            
                            //go for each word in the selectionDataArray
                            for currentSelectionData in selectionDataArray!{
                                //at this point, you have finally gone down to the lowest level in the selectionData of 1 category
                                stringDataArrayForSection.append(currentSelectionData as! String)
                            }
                            
                            downloadedAppData2DString.append(stringDataArrayForSection)
                        }
                        if(categoryChild.key as? String == "image"){
                            categoryImageFileName = (categoryChild.value as? String)!
                            downloadedCategoryData.append(TileData(categoryImageFileName, categoryTitle))
                        }
                    }
                }
                
                
                //at this point, the tileData for the categories (downloadedCategoryData) is set up, and the (downloadedAppData2DString)is also set up.
                //we now need to take the image file names of each of the pictures
                print("below is the downloadedCategoryData")
                for currentRow in downloadedCategoryData{
                    print("TileData:")
                    print("\t", currentRow.getImageTitle())
                    print("\t", currentRow.getImageFileName())
                }
                print("below is the downloadedAppData2DString")
                for currentRow in downloadedAppData2DString{
                    print(currentRow)
                }
                var downloadedAppData2DTileData = [[TileData]]()
                var downloadedSelectionBarTileData = [TileData]()
                
                userRef.child("tileData").observe(DataEventType.value, with:
                    {
                        (nestedSnapshot) in
                        print("now inside the nested observe, here is the snapshot")
                        print(nestedSnapshot)
                        let dictTileData = nestedSnapshot.value as? NSDictionary
                        
                        //go through each tileData in the tileData attribute
                        var tileDataArray = [TileData]()
                        for currentTileData in dictTileData!{
                            let tileDataDict = currentTileData.value as? NSDictionary
                            tileDataArray.append(TileData(tileDataDict!["Image"] as! String, tileDataDict!["title"] as! String))
                        }
                        
                        for currentRow in downloadedAppData2DString{
                            var currentCategoryTileData = [TileData]()
                            for currentString in currentRow{
                                for currentTileData in tileDataArray{
                                    if(currentTileData.getImageTitle() == currentString){
                                        currentCategoryTileData.append(currentTileData)
                                    }
                                }
                            }
                            downloadedAppData2DTileData.append(currentCategoryTileData)
                        }
                        
                        //at this point, your downloadedAppData2DTileData has been properly initialized
                        print("below is the downloadedAppData2DTileData")
                        for currentRow in downloadedAppData2DTileData{
                            print("printing one row of 2D Tile Data:")
                            for currentTile in currentRow{
                                print("\tTileData:")
                                print("\t\t", currentTile.getImageTitle())
                                print("\t\t", currentTile.getImageFileName())
                            }
                        }
                        downloadedSelectionBarTileData = downloadedAppData2DTileData[0]
                        
                        self.appDataTileData = downloadedAppData2DTileData
                        self.categoryBarTileData = downloadedCategoryData
                        self.selectionBarTileData = downloadedSelectionBarTileData
                        
                        self.selectionCollection.reloadData()
                        self.categoryCollection.reloadData()
                        self.sentenceCollection.reloadData()
                        
                        print("successfully did all the printing... we have updated the arrays and reloaded the collectionViews")
                        
                }
                ){
                    (error) in
                    print(error.localizedDescription)
                }
        }
        ){
            (error) in
            print(error.localizedDescription)
        }
    }
}
//class UIviewcontroller ends


//  TileData Class contains information needed to make a Tile UICollectionViewCell
class TileData{
    private let imageFileName: String
    private let imageTitle : String
    
    //  Constructor for the TileData
    init(_ imageFileName: String, _ imageTitle: String){
        self.imageFileName = imageFileName
        self.imageTitle = imageTitle
    }
    
    //  Getter for the imageFileName
    func getImageFileName() -> String{
        return imageFileName
    }
    
    //  Getter for the imageTitle
    func getImageTitle() -> String{
        return imageTitle
    }
}



//  Tile Class contains views necessary to display onto the screen
class Tile: UICollectionViewCell{
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelView: UILabel!
    
    var tileData: TileData!{
        didSet{
            labelView.text = tileData.getImageTitle()
            imageView.loadImageUsingCacheWithFileNameString(fileName: tileData.getImageFileName())
        }
    }
    
    //  Constructor for Tile using a labelName, imageName, and a rect
    init(_ labelName: String, _ imageName: String, _ rect: CGRect){
        super.init(frame: rect)
        labelView.text = labelName
        imageView.image = UIImage(named: imageName)
    }
    
    //  Required constructor for the Tile
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
