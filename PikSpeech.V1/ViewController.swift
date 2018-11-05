//
//  ViewController.swift
//  PikSpeech.V1
//
//  Created by Lance Zhang on 2018-11-01.
//  Copyright © 2018 cmpt275group11. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    var speechBarTileData = [TileData]()//mutable
    var selectionBarTileData = Initializer.getDefaultSelectionBarData()//mutable
    var categoryBarTileData = Initializer.getCategoryData()//immutable.. only carries CATEGORYDATA data
    var appDataTileData = Initializer.getAppDataTileData()//immutable.. carries all the info of all the pictures
    
    //all the outlets of the elements
    @IBOutlet weak var selectionCollection: UICollectionView!
    
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    @IBAction func speakButton(_ sender: Any) {
        
        
        for TileData in speechBarTileData{
            myUtterance = AVSpeechUtterance(string: TileData.getImageTitle())
            myUtterance.rate = 0.3
            synth.speak(myUtterance)
        }
    }
    @IBAction func deletionButton(_ sender: Any) {
        if speechBarTileData.count>0{
        speechBarTileData.removeLast()
            sentenceCollection.reloadData()
            sentenceCollection.layoutIfNeeded()
        }
    }
    
    @IBOutlet weak var categoryCollection: UICollectionView!
    @IBOutlet weak var sentenceCollection: UICollectionView!
    
    
    /*
     There are three collection views:
     selectionCollection - Thats what was supposed to be for the category window, but for now itll just be a holder for our selection pane
     categoryCollection - Thats supposedly the bar for the categories
     sentenceCollection - Thats the speech bar
     */
    
    @IBAction func settingsButton(_sender: UIButton) {
        performSegue(withIdentifier: "SettingsSegue", sender: self)
    }
    
    
    //function viewdidload
    override func viewDidLoad() {
        super.viewDidLoad()
        //        selectionCollection.register(Tile.self, forCellWithReuseIdentifier: "cellId")
        let width = view.frame.size.width / 6.0
        let layout = selectionCollection.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        selectionCollection.delegate = self
        selectionCollection.dataSource = self
        
        //        categoryCollection.register(Tile.self, forCellWithReuseIdentifier: "cellId")
        categoryCollection.delegate = self
        categoryCollection.dataSource = self
        
        //        sentenceCollection.register(Tile.self, forCellWithReuseIdentifier: "cellId")
        sentenceCollection.delegate = self
        sentenceCollection.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //hide Nav Bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    
    /*
     There are three collection views:
     selectionCollection - Thats what was supposed to be for the category window, but for now itll just be a holder for our selection pane
     categoryCollection - Thats supposedly the bar for the categories
     sentenceCollection - Thats the speech bar
     */
    
    
    //method numberOfItemsInSection for collectionview
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.selectionCollection{
            //you should return the amount of what is inside your specific collection in the category
            //this means that this number will differ from time to time
            return selectionBarTileData.count
        }
        else if collectionView == self.categoryCollection{
            //you should return the amount of categories there are
            //this should stay still
            return categoryBarTileData.count
        }
        else{
            //this one changes depending on whats inside the array
            return speechBarTileData.count
        }
    }
    
    
    //method cellForItemAt for collectionview
    //this is what you show in your given collection, basically, you need to make a dummy tile then update it to your liking
    
    //dequeue stuff, then return a cell with the specific attributes which is defined by the thing
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.selectionCollection{
            //you should return the amount of what is inside your specific collection in the category
            //you need to return a tile with the specific thingy of the thingy
            
            //when a different category has been chosen, the array gets updated to the latest one
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! Tile
            cell.tileData = selectionBarTileData[indexPath.row]
//            cell.setLabel(selectionBarTileData[indexPath.row].getImageTitle())
//            var img = UIImage(named: selectionBarTileData[indexPath.row].getImageFileName())
//            cell.setImage(img!)
            //            cell.setLabel(String(numbers[indexPath.row]))
            //        cell.labelView.text = String(numbers[indexPath.row])
            //does this put a cell into the array or takes it away?
            return cell
        }
        else if collectionView == self.categoryCollection{
            //you should return the amount of categories there are
            //you should return a tile that contains category info
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! Tile
            cell.tileData = categoryBarTileData[indexPath.row]
//            cell.setLabel(categoryBarTileData[indexPath.row].getImageTitle())
//            cell.setImage(UIImage(named: categoryBarTileData[indexPath.row].getImageFileName())!)
            //            cell.setLabel(String(numbers[indexPath.row]))
            //        cell.labelView.text = String(numbers[indexPath.row])
            //does this put a cell into the array or takes it away?
            return cell
        }
        else{
            //you need to return a tile that is in the speech thing
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! Tile
            cell.tileData = speechBarTileData[indexPath.row]
//            cell.setLabel(speechBarTileData[indexPath.row].getImageTitle())
//            cell.setImage(UIImage(named: speechBarTileData[indexPath.row].getImageFileName())!)
            //            cell.setLabel(String(numbers[indexPath.row]))
            //        cell.labelView.text = String(numbers[indexPath.row])
            //does this put a cell into the array or takes it away?
            return cell
        }
    }
    
    
    
    //method did selectitem at for collectionview
    //THIS IS WHERE THE UI TALKS TO ITESELF AND ITS OBJECTS THIS IS IMPORTANT
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.selectionCollection{
            print("selectionCollection selected index \(indexPath.row)")
            //you should return the amount of what is inside your specific collection in the category
            //if the selection is pressed, you wanna hand the data over to the speech bar
            speechBarTileData.append(selectionBarTileData[indexPath.row])
            sentenceCollection.reloadData()
            sentenceCollection.layoutIfNeeded()
            //
            
            //TODO: do we need to update the speech bar?
        }
        else if collectionView == self.categoryCollection{
            //you should return the amount of categories there are
            //if the selection is pressed, you wanna hand data into the selection bar thing
            selectionBarTileData = replaceSelectionDataForCategory(indexPath.row)
            print("categoryCollection selected")
            selectionCollection.reloadData()
            selectionCollection.layoutIfNeeded()
        }
        else{
            //do nothing if youre the speech bar, maybe you can talk if anything
            print("sentenceCollection selected")
        }
    }
    
    func replaceSelectionDataForCategory(_ categoryIndex: Int) -> [TileData]{
        return appDataTileData[categoryIndex]
    }
    
    
    
    
    //    Locking to landscapeMode
    //    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    //    return .landscapeLeft
    //    }
    //    override var shouldAutorotate: Bool {
    //        return true
    //    }
}

class TileData{
    private let imageFileName: String
    private let imageTitle : String
    
    init(_ imageFileName: String, _ imageTitle: String){
        self.imageFileName = imageFileName
        self.imageTitle = imageTitle
    }
    
    func getImageFileName() -> String{
        return imageFileName
    }
    
    func getImageTitle() -> String{
        return imageTitle
    }
}

class Tile: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelView: UILabel!
    //    let imageView : UIImageView = {
//        let imgView = UIImageView()
//        imgView.backgroundColor = .blue
//        imgView.image = UIImage(named: "TeamLogoIcon")
//        return imgView
//    }()
//
//    let labelView : UILabel = {
//        let labelView = UILabel()
//        labelView.textColor = .red
//        labelView.text = "uilabel"
//        return labelView
//    }()
    
    var tileData: TileData! {
        didSet {
            //if let tileData = tileData {
            var img = UIImage(named: tileData.getImageFileName())
                imageView.image = img
                labelView.text = tileData.getImageTitle()
           // }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    init(_ labelName: String, _ imageName: String, _ rect: CGRect){
        super.init(frame: rect)
        labelView.text = labelName
        imageView.image = UIImage(named: imageName)
    }
    
    func setLabel(_ text: String){
        print(text)
        print(labelView.text)
        labelView.text = text
        
    }
    
    func setImage(_ image: UIImage){
        imageView.image = image
    }
    
    
    func setupViews(){
        //make the picture and the title
        addSubview(imageView)
        addSubview(labelView)
        //TODO: you need to do the correct anchoring
        //        imageView.anchorInCorner(.topRight, xPad: self.width*0.01, yPad: self.height*0.01, width: self.width*0.98, height: self.height*0.75)
        //        labelView.alignAndFill(align: .underCentered, relativeTo: imageView, padding: self.height*0.01)
    }
    
    required init?(coder aDecoder: NSCoder) {
        //        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
}


//////////////////////////



