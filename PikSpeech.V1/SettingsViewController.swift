//
//  SettingsViewController.swift
//  PikSpeech.V1
//
//  Created by Lance Zhang on 2018-11-02.
//  Copyright © 2018 cmpt275group11. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SettingsViewController: UIViewController {
    
    @IBAction func logoutButton(_ sender: Any) {
        handlelogout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser?.uid == nil {
            
            handlelogout()
            print("current user has been signed out, no user is currently logged in")
        }

    }
    

    //logout handler
    func handlelogout() {
        do {
        try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        performSegue(withIdentifier: "logoutSegue", sender: self)
    
    }

}
