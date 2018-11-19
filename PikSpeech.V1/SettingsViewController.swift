//
//  SettingsViewController.swift
//  PikSpeech.V1
//
//  Created by Lance Zhang on 2018-11-02.
//  Collaboration with Miguel Taningco & Sheel Soneji
//  Copyright © 2018 CMPT 275 Group11: A-team. All rights reserved.
//
//  Changed Log:
//      11/14/2018: Allow the user to log out to the sign up page   (Lance Zhang)


import UIKit
import Firebase
import FirebaseDatabase

//  Controls the behaviour of the settings page
class SettingsViewController: UIViewController {
    //  Log out the user
    @IBAction func logoutButton(_ sender: Any) {
        handlelogout()
    }
    
    // Task to do when the settings View gets loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser?.uid == nil {
            
            handlelogout()
            print("current user has been signed out, no user is currently logged in")
        }

    }
    

    //  Logout handler
    func handlelogout() {
        do {
        try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        performSegue(withIdentifier: "logoutSegue", sender: self)
    
    }

}
