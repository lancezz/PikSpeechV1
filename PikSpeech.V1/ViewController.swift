//
//  ViewController.swift
//  PikSpeech.V1
//
//  Created by Lance Zhang on 2018-11-01.
//  Copyright © 2018 cmpt275group11. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //all the outlets of the elements
    @IBOutlet weak var selectionCollection: UICollectionView!
    @IBAction func speakButton(_ sender: Any) {
    }
    @IBAction func deletionButton(_ sender: Any) {
    }

    @IBOutlet weak var categoryCollection: UICollectionView!
    @IBOutlet weak var sentenceCollection: UICollectionView!
    
    @IBAction func settingsButton(_sender: UIButton) {
        performSegue(withIdentifier: "SettingsSegue", sender: self)
    }
    
    
    //function viewdidload
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //hide Nav Bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
 
    
    //method numberOfItemsInSection for collectionview
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    
    //method cellForItemAt for collectionview
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    
    
    //method did selectitem at for collectionview
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        <#code#>
    }
    
    
    
    
    //    Locking to landscapeMode
    //    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    //    return .landscapeLeft
    //    }
    //    override var shouldAutorotate: Bool {
    //        return true
    //    }
}


//////////////////////////


