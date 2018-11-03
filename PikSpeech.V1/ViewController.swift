//
//  ViewController.swift
//  PikSpeech.V1
//
//  Created by Lance Zhang on 2018-11-01.
//  Copyright © 2018 cmpt275group11. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //all the outlets of the elements
    @IBAction func settingsButton(_sender: UIButton) {
        performSegue(withIdentifier: "SettingsSegue", sender: self)
    }
    
    
    //function viewdidload
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        let value = UIInterfaceOrientation.landscapeLeft.rawValue
//        UIDevice.current.setValue(value, forKey:"orientation")
      
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


