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

import UIKit
import AVFoundation
import FirebaseDatabase





//  ViewController Class controls the views of the app and manages the flow of data within the main activity
class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    var speechBarTileData = [TileData]()
    var selectionBarTileData = Initializer.getDefaultSelectionBarData()
    var categoryBarTileData = Initializer.getCategoryData()//TODO: i think this should be a let
    var appDataTileData = Initializer.getAppDataTileData()//TODO: i think this should be a let
    
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
        let width = view.frame.size.width / 6.0
        let layout = selectionCollection.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.itemSize = CGSize(width: width, height: width)
        
        selectionCollection.delegate = self
        selectionCollection.dataSource = self
        
        categoryCollection.delegate = self
        categoryCollection.dataSource = self
        
        sentenceCollection.delegate = self
        sentenceCollection.dataSource = self
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let rootRef = ref.child("user3")
        let values: [String: Any] = ["name": "reading3"]
        rootRef.setValue(values)
        ref.observe(.value) { (snapshot) in
            print(snapshot)
        }
        
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
}



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
            var img = UIImage(named: tileData.getImageFileName())
            imageView.image = img
            labelView.text = tileData.getImageTitle()
        }
    }
    
    //  Constructor for Tile using a frame
//    override init(frame: CGRect){
//        super.init(frame: frame)
////        setupViews()
//    }
    
    //  Constructor for Tile using a labelName, imageName, and a rect
    init(_ labelName: String, _ imageName: String, _ rect: CGRect){
        super.init(frame: rect)
        labelView.text = labelName
        imageView.image = UIImage(named: imageName)
    }
    
    //  Sets the label of the Tile
//    func setLabel(_ text: String){
//        labelView.text = text
//    }
//
//    //  Sets the image of the Tile
//    func setImage(_ image: UIImage){
//        imageView.image = image
//    }
//
//    //  Sets up the views of the tile
//    func setupViews(){
//        addSubview(imageView)
//        addSubview(labelView)
//    }
    
    //  Required constructor for the Tile
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
