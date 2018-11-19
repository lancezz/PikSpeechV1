//
//  ColorTileSizeViewController.swift
//  PikSpeech.V1
//
//  Created by Lance Zhang on 2018-11-19.
//  Copyright © 2018 cmpt275group11. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class ColorTileSizeViewController: UIViewController {
    
    
    @IBAction func themeOneButton(_ sender: Any) {
        let user = Auth.auth().currentUser
        guard let uid = user?.uid else
        {
            return
        }
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let userRef = ref.child("user").child(uid)
        let selectioncolorRef = userRef.child("selectionColor")
        let speechcolorRef = userRef.child("speechColor")
        let selectionColorValue = ["R": 0.87,"G": 0.82,"B": 0.925]
        let speechColorValue = ["R": 0.87,"G": 0.82,"B": 0.925]
        selectioncolorRef.setValue(selectionColorValue)
        speechcolorRef.setValue(speechColorValue)
        
        
    }
    @IBAction func pinkColorButton(_ sender: Any) {
        let user = Auth.auth().currentUser
        guard let uid = user?.uid else
        {
            return
        }
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let userRef = ref.child("user").child(uid)
        let selectioncolorRef = userRef.child("selectionColor")
        let speechcolorRef = userRef.child("speechColor")
        let selectionColorValue = ["B": 0.87,"G": 0.82,"R": 0.925]
        let speechColorValue = ["B": 0.87,"G": 0.82,"R": 0.925]
        selectioncolorRef.setValue(selectionColorValue)
        speechcolorRef.setValue(speechColorValue)
        
    }
    @IBAction func themeTwoButton(_ sender: Any) {
        let user = Auth.auth().currentUser
        guard let uid = user?.uid else
        {
            return
        }
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let userRef = ref.child("user").child(uid)
        let selectioncolorRef = userRef.child("selectionColor")
        let speechcolorRef = userRef.child("speechColor")
        let selectionColorValue = ["G": 0.87,"B": 0.82,"R": 0.925]
        let speechColorValue = ["G": 0.87,"B": 0.82,"R": 0.925]
        selectioncolorRef.setValue(selectionColorValue)
        speechcolorRef.setValue(speechColorValue)
    }
    
    @IBAction func smallSizeButton(_ sender: Any) {
        let user = Auth.auth().currentUser
        guard let uid = user?.uid else
        {
            return
        }
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let userRef = ref.child("user").child(uid)
        userRef.updateChildValues(["tilesPerRow":6])
        
    }
    
 
    @IBAction func mediumSizeButton(_ sender: Any) {
        let user = Auth.auth().currentUser
        guard let uid = user?.uid else
        {
            return
        }
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let userRef = ref.child("user").child(uid)
        userRef.updateChildValues(["tilesPerRow":5])
    }
    
    @IBAction func largeSizeButton(_ sender: Any) {
        let user = Auth.auth().currentUser
        guard let uid = user?.uid else
        {
            return
        }
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let userRef = ref.child("user").child(uid)
        userRef.updateChildValues(["tilesPerRow":4])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
}
