//
//  ColorTileSizeViewController.swift
//  PikSpeech.V1
//
//  Created by Lance Zhang on 2018-11-19.
//  Collaboration with Miguel Taningco
//  Copyright © 2018 cmpt275group11. All rights reserved.
//
//  Change Log:
//      11/18/2018: Allowed users to change the color and tile size in the Main View    (Miguel Taningco and Lance Zhang)

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class ColorTileSizeViewController: UIViewController {
    
    //  Change the attribute of color in Firebase to a preset
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
    //  Change the attribute of color in Firebase to default pink
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
    //  Change the attribute of color in Firebase to a preset
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
    //  Change the tile size to 6 per row
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
    
    //  Change the tile size to 5 per row
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
    
    //  Change the tile size to 4 per row
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
        
    }
    
    
    
    
}
