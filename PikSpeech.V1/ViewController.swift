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
import SQLite3





//  ViewController Class controls the views of the app and manages the flow of data within the main activity
class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    var db: OpaquePointer? = nil
    
    var speechBarTileData = [TileData]()
    var selectionBarTileData = Initializer.getDefaultSelectionBarData()
    var categoryBarTileData = Initializer.getCategoryData()
    var appDataTileData = Initializer.getAppDataTileData()
    var predictionTileData = [TileData]()
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    var prediction = ""
    var previousWord = "I"
    
    
    
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
            
            if(speechBarTileData.count > 1){
                let lastWord = speechBarTileData.last
                predictNextWords(inputText: (lastWord?.getImageTitle())!)
            }
            if(speechBarTileData.count == 0){
                predictNextWords(inputText: "I")
            }
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
    //  Permanently delete the pic from your personal library
    @IBAction func deleteFromLibrary(_ sender: Any) {
        for TileData in speechBarTileData{
            let titleForDelete = TileData.getImageTitle()
            let user = Auth.auth().currentUser
            guard let uid = user?.uid else
            {
                return
            }
            var ref: DatabaseReference!
            ref = Database.database().reference()
            let userRef = ref.child("user").child(uid)
            
            userRef.child("categoryData").observe(DataEventType.value, with:
                { (snapshot) in
                    let dict = snapshot.value as? NSDictionary
                    for currentCategory in dict!{
                        let postDict = currentCategory.value as? NSDictionary
                        let currentCategoryName = currentCategory.key
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
                                if let index = stringDataArrayForSection.index(of: titleForDelete) {
                                    print("found a string with the same data")
                                    stringDataArrayForSection.remove(at: index)
                                    let deleteRef = userRef.child("categoryData/\(currentCategoryName)/selectionData")
                                    deleteRef.setValue(stringDataArrayForSection)
                                    
                                }
                                else{
                                    print("did not find a string with the same data.. here is what we were trying to delete: " + titleForDelete)
                                }
                                print(stringDataArrayForSection)
                                
                            }
                            
                        }
                    }
            })
        }
        speechBarTileData.removeAll()
        self.sentenceCollection.reloadData()
        self.selectionCollection.reloadData()
    }
    //  Very similar to the deletion button, the user can
    @IBAction func favouriteButtonPressed(_ sender: Any) {
        let user = Auth.auth().currentUser
        guard let uid = user?.uid else
        {
            return
        }
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let userRef = ref.child("user").child(uid)
        
        let favRef = userRef.child("categoryData").child("Favourite").child("selectionData")
        favRef.observeSingleEvent(of: .value, with:
            { (snapshot) in
                //make the snapshot as a string array
                var value = snapshot.value as? [String] ?? []
                
                
                print (value)
                
                for tileData in self.speechBarTileData{
                    print("now inside each of the thing that we are about to favourite")
                    var isDuplicate = false;//here, assume that it is not a duplicate
                    for dataInArray in value{
                        if dataInArray == tileData.getImageTitle(){
                            isDuplicate = true;
                            break
                        }
                    }
                    if isDuplicate{
                        continue
                        
                    }
                    else{
                        //add the tile
                        value.append(tileData.getImageTitle())
                        print("append successfuly")
                        favRef.setValue(value)
                    }
                }
                self.speechBarTileData.removeAll()
                self.sentenceCollection.reloadData()
        }){
            (error) in
            print(error.localizedDescription)
        }
        
        
        //self.sentenceCollection.reloadData()
        self.selectionCollection.reloadData()
    }
    //  Deletes one Tile object from the SpeechBar array when DeleteButton is tapped
    @IBAction func deletionButton(_ sender: Any){
        if speechBarTileData.count > 0{
            speechBarTileData.removeLast()
            sentenceCollection.reloadData()
            sentenceCollection.layoutIfNeeded()
            
            //look for the last tile, predict with that
            
            if(speechBarTileData.count > 1){
                let lastWord = speechBarTileData.last
                predictNextWords(inputText: (lastWord?.getImageTitle())!)
            }
            if(speechBarTileData.count == 0){
                predictNextWords(inputText: "I")
            }
            
        }
    }
    
    @IBOutlet weak var predictionCollection: UICollectionView!
    @IBOutlet weak var categoryCollection: UICollectionView!
    @IBOutlet weak var sentenceCollection: UICollectionView!
    
    //  Segues into the SettingsSegue
    @IBAction func settingsButton(_sender: UIButton){
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        let alert = UIAlertController(title: "Parental Control",
                                      message: "Please Provide Your Pin to change settings",
                                      preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Confirm",
                                       style: .default) { action in
                                        let pinEntered = alert.textFields![0]
                                        let user = Auth.auth().currentUser
                                        guard let uid = user?.uid else
                                        {
                                            return
                                        }
                                        
                                        var ref: DatabaseReference!
                                        ref = Database.database().reference()
                                        let userRef = ref.child("user").child(uid)
                                        userRef.child("pin").observeSingleEvent(of: .value, with: { snapshot in
                                            let userPin = snapshot.value as? String
                                            if pinEntered.text == userPin {
                                                self.performSegue(withIdentifier: "SettingsSegue", sender: self)
                                            }
                                            else {
                                                print("pin wrong")
                                            }
                                            
                                        })
                                        
        }
        alert.addTextField { enteredPin in
            enteredPin.placeholder = "Pin here"
            
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //  Initializes properties of views
    override func viewDidLoad(){
        super.viewDidLoad()
        
        //All these are default things
        let actualWidth = view.frame.size.width
        let width = view.frame.size.width / 6.0
        let layout = selectionCollection.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.itemSize = CGSize(width: width, height: width)
        let layout2 = sentenceCollection.collectionViewLayout as! UICollectionViewFlowLayout
        layout2.itemSize = CGSize(width: 130,height: 130)
        selectionCollection.delegate = self
        selectionCollection.dataSource = self
        
        categoryCollection.delegate = self
        categoryCollection.dataSource = self
        
        sentenceCollection.delegate = self
        sentenceCollection.dataSource = self
        
        predictionCollection.delegate = self
        predictionCollection.dataSource = self
        predictionCollection.layer.borderColor = UIColor.black.cgColor
        predictionCollection.layer.borderWidth = 1.0
        //Download actual Data
        TileSizeManager.downloadTilesPerRow(viewWidth: actualWidth, collectionView: selectionCollection)
        ColorManager.downloadColorForCollectionView(collectionView: selectionCollection, collectionEnum: SpecificCollectionView.selectionCollectionView, appView: view)
        ColorManager.downloadColorForCollectionView(collectionView: categoryCollection, collectionEnum: SpecificCollectionView.categoryCollectionView, appView: view)
        ColorManager.downloadColorForCollectionView(collectionView: sentenceCollection, collectionEnum: SpecificCollectionView.speechCollectionView, appView: view)
        
        downloadAllSelectionDataAs2DArray()
        
        //SQLite stuff
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("wordPredictionDB.sqlite")
        
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(fileURL)")
        } else {
            print("Unable to open database. Verify that you created the directory described " +
                "in the Getting Started section.")
        }
        createTable()
        
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
        else if collectionView == self.predictionCollection{
            return predictionTileData.count
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
        else if collectionView == self.predictionCollection{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! Tile
            cell.tileData = predictionTileData[indexPath.row]
            
            return cell
        }
        else{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! Tile
            cell.tileData = speechBarTileData[indexPath.row]
            cell.imageView.layer.borderWidth = 2
            let color = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1.0)
            cell.imageView.layer.borderColor = color.cgColor
            return cell
        }
    }
    
    //  Assigns the appropriate behaviour based on the given UICollectionView and indexPath
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        if collectionView == self.selectionCollection{
            speechBarTileData.append(selectionBarTileData[indexPath.row])
            let user = Auth.auth().currentUser
            guard let uid = user?.uid else
            {
                return
            }
            var ref: DatabaseReference!
            ref = Database.database().reference()
            let userRef = ref.child("user").child(uid)
            
            let tileFreq = userRef.child("tileData").child("\(selectionBarTileData[indexPath.row].getImageTitle())").child("frequency")
            tileFreq.observeSingleEvent(of: .value, with: { snapshot in
                var currentFreq = snapshot.value as! Int
                currentFreq = currentFreq + 1
                print("frequencyy change today")
                tileFreq.setValue(currentFreq)
                
                
            })
            
            myUtterance = AVSpeechUtterance(string: selectionBarTileData[indexPath.row].getImageTitle())
            myUtterance.rate = 0.3
            synth.speak(myUtterance)
            //predition part after a tile is clicked
            let clickedImageTitle = selectionBarTileData[indexPath.row].getImageTitle()
            predictNextWords(inputText: clickedImageTitle)
            sentenceCollection.reloadData()
            sentenceCollection.layoutIfNeeded()
            
           
            
            
        }
        else if collectionView == self.categoryCollection{
            selectionBarTileData = replaceSelectionDataForCategory(indexPath.row)
            selectionCollection.reloadData()
            selectionCollection.layoutIfNeeded()
        }
        else if collectionView == self.predictionCollection{
            speechBarTileData.append(predictionTileData[indexPath.row])
            let user = Auth.auth().currentUser
            guard let uid = user?.uid else
            {
                return
            }
            var ref: DatabaseReference!
            ref = Database.database().reference()
            let userRef = ref.child("user").child(uid)
            
            let tileFreq = userRef.child("tileData").child("\(predictionTileData[indexPath.row].getImageTitle())").child("frequency")
            tileFreq.observeSingleEvent(of: .value, with: { snapshot in
                var currentFreq = snapshot.value as! Int
                currentFreq = currentFreq + 1
                print("frequencyy change today")
                tileFreq.setValue(currentFreq)
                
                
            })
            
            myUtterance = AVSpeechUtterance(string: predictionTileData[indexPath.row].getImageTitle())
            myUtterance.rate = 0.3
            synth.speak(myUtterance)
            
            sentenceCollection.reloadData()
            sentenceCollection.layoutIfNeeded()
            
            //predition part after a tile is clicked
            let clickedImageTitle = predictionTileData[indexPath.row].getImageTitle()
            predictNextWords(inputText: clickedImageTitle)
            
            
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
                
                userRef.child("tileData").observeSingleEvent(of: .value, with:
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
                        
                        
                        self.predictNextWords(inputText: self.previousWord)
                        
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
    
    //SQlite part//////
    //func openDatabase() -> OpaquePointer? {
    //    var db: OpaquePointer? = nil
    //    if sqlite3_open(part1DbPath, &db) == SQLITE_OK {
    //        print("Successfully opened connection to database at \(part1DbPath)")
    //        return db
    //    } else {
    //        print("Unable to open database. Verify that you created the directory described " +
    //            "in the Getting Started section.")
    //        PlaygroundPage.current.finishExecution()
    //    }
    //
    //}
    
    func createTable() {
        
        //creating table
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Prediction (word TEXT PRIMARY KEY NOT NULL UNIQUE, prediction1 TEXT, prediction2 TEXT,prediction3 TEXT, prediction4 TEXT, prediction5 TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
    }
    
    func predictNextWords(inputText: String) ->(){
        print("about to use createAndUpdatePreviousWord\n");
        createAndUpdatePreviousWord(inputText: inputText);
        
        //print out the prediction or make a new record for the inputText
        print("about to use createAndPrintPrediction");
        createAndPrintPrediction(inputText: inputText);
        
        print("the previous word is now the text you just placed");
        previousWord = inputText;
    }
    
    func createAndUpdatePreviousWord(inputText: String) ->(){
        var isPresent = false
        var stmt: OpaquePointer? = nil
        
        print("check if the inputText: " + previousWord + " exists in the db in the first place");
        let queryString = "SELECT * FROM Prediction WHERE word = '" + previousWord + "'"
        
        if sqlite3_prepare_v2(db, queryString, -1, &stmt, nil) == SQLITE_OK{
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                print("you have found the word in db, ispresent is true now")
                isPresent = true
            }

        }
        else{
            print("previous word was not present, gonna make a new one")
            let insertQueryString = "INSERT INTO Prediction (word) VALUES ('" + previousWord + "')"
            var insertStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, insertQueryString, -1, &insertStatement, nil) == SQLITE_OK {
                if sqlite3_step(insertStatement) == SQLITE_ROW {
                    print("Successfully insert row.",insertQueryString)
                } else {
                    print("Could not update row.")
                }
            }
            sqlite3_finalize(insertStatement)
        }
        sqlite3_finalize(stmt)
        print("query for the previous word now for real now that we know it will exist for sure")
        var realQueryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, queryString, -1, &realQueryStatement, nil)  == SQLITE_OK {
            var predictionList = [String]()
            if sqlite3_step(realQueryStatement) == SQLITE_ROW{    //??

                for  i in  1 ... 5{
                    
                    if sqlite3_column_text(realQueryStatement, Int32(i)) == nil {
                        print("empty prediction list")
                        break
                    }
                        predictionList.append(String(cString:sqlite3_column_text(realQueryStatement, Int32(i))))
                }
            }
            if(predictionList.contains(inputText)){
                //error check if this is so
                
                //delete the word and replace it to the top
                print("the predictionList contained the word: " + inputText + " will now delete and place in the beginning of the list");
                if let idx = predictionList.index(where: { $0 == inputText }) {
                    predictionList.remove(at: idx)
                }
                predictionList.insert(inputText,at: 0);
            }
            else{
                //put the word at the first element of the list
                print("the word did not exist in the first place, going to place in the beginning");
                predictionList.insert(inputText,at: 0);
            }
            //putting things into the database
            let prefix = "prediction"
            var currentPredictionNum = 1
            print("now putting the predictionList into the db")
            for currentWord in predictionList{
                if currentPredictionNum >= 6 {
                    break
                }
                var currentPrediction = prefix + String(currentPredictionNum)
                let currentQuery = "UPDATE Prediction SET " + currentPrediction + " = '" + currentWord + "' WHERE word = '" + previousWord + "'"
                var updateStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(db, currentQuery, -1, &updateStatement, nil) == SQLITE_OK{
                    if sqlite3_step(updateStatement) == SQLITE_DONE{
                        print("here is current query",currentQuery)
                    }
                    else {
                        print("cannot update")
                    }
                    currentPredictionNum = currentPredictionNum + 1
                }
                sqlite3_finalize(updateStatement)
            }
            
        }
        sqlite3_finalize(realQueryStatement)
        print("done doing the entire updating")
    }
    func createAndPrintPrediction(inputText: String) ->(){
        var isPresent = false
        var stmt: OpaquePointer? = nil
        
        print("check if the inputText: " + inputText + " exists in the db in the first place");
        let queryString = "SELECT * FROM Prediction WHERE word = '" + inputText + "'"
        
        if sqlite3_prepare_v2(db, queryString, -1, &stmt, nil) == SQLITE_OK{
            var predictionList = [String]()
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                print("the word exist")
                isPresent = true
                for  i in  1 ... 5{
                    
                    if sqlite3_column_text(stmt, Int32(i)) == nil {
                        print("empty prediction list")
                        break
                    }
                    predictionList.append(String(cString:sqlite3_column_text(stmt, Int32(i))))
                }
            }
//            var predictionList = [String]()
//            if isPresent == true{
//                for  i in  1 ... 5{
//
//                    if sqlite3_column_text(stmt, Int32(i)) == nil {
//                        print("empty prediction list")
//                        break
//                    }
//                    predictionList.append(String(cString:sqlite3_column_text(stmt, Int32(i))))
//                }
//
//            }
            if isPresent != true {
                print("previous word was not present, gonna make a new one")
                let insertQueryString = "INSERT INTO Prediction (word) VALUES ('" + inputText + "')"
                var insertStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(db, insertQueryString, -1, &insertStatement, nil) == SQLITE_OK {
                    if sqlite3_step(insertStatement) == SQLITE_DONE {
                        print("Successfully insert word.")
                    } else {
                        print("Could not update row.")
                    }
                }
                sqlite3_finalize(insertStatement)
            }
            
            //this is where we put the prediction into the prediction bar
            
            //for each word in the prediction
                //find that inside the 2d array
                    //if you find the word, get that tile data and append it to the prediction
                        //continue
            predictionTileData.removeAll()
            for word in predictionList{
                print(word)
                //might have to do case where nothing inside
                for category in appDataTileData{
                    var hasAppended = false
                    for currentTileData in category{
                        if currentTileData.getImageTitle() == word{
                            predictionTileData.append(currentTileData)
                            hasAppended = true
                            break
                        }
                    }
                    if hasAppended{
                        break
                    }
                }
            }
            print(predictionList)
            
            predictionCollection.reloadData()
        }
        else{
            print("inputText was not present, gonna make a new one")
            let insertQueryString = "INSERT INTO Prediction (word) VALUES ('" + inputText + "')"
            var insertStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, insertQueryString, -1, &insertStatement, nil) == SQLITE_OK {
                if sqlite3_step(insertStatement) == SQLITE_ROW {
                    print("Successfully insert row.",insertQueryString)
                    predictionTileData.removeAll()
                    predictionCollection.reloadData()
                } else {
                    print("Could not update row.")
                }
            }
            sqlite3_finalize(insertStatement)
        }
        sqlite3_finalize(stmt)
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
