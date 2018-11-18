//
//  TileSizeManager.swift
//  PikSpeech.V1
//
//  Created by Lance Zhang on 2018-11-17.
//  Copyright © 2018 cmpt275group11. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class TileSizeManager {
    static func getTilesPerRow () -> Int{

        let user = Auth.auth().currentUser
        guard let uid = user?.uid else {
            return -2
        }
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let userRef = ref.child("user").child(uid)

        var num = -1



//        let queue = DispatchQueue(label: "observer")
//        queue.sync {
        userRef.child("tilesPerRow").observe(DataEventType.value) {
            snapshot in
                // Get user value
//                print("now inside the observe thing------------------")
            let value = snapshot.value as! [String: Any]
                            num = value["tilesPerRow"] as! Int
//                print("just updated the number to ", num)
//                print("the snapshot is ", snapshot)
//                print("the value is ", value)
//                print("the real value is", snapshot.value)
//                print("just making sure, the number that was set is ", num)
//                numArray.append(num)
//
//                // ...
//            }) { (error) in
//                print("there was an error!!!!!!!!!!!!!!!!!")
//                print(error.localizedDescription)
//
//            }
        }


        print("about to return from the function ", num)
        return num
    }
    
    static func getTilesPerRow(valueToUpdate: IntHolder, callback: @escaping ((_ data: Int) -> Int))
    {
        let user = Auth.auth().currentUser
        guard let uid = user?.uid else
        {
            return
        }
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let userRef = ref.child("user").child(uid)
        
        
        userRef.child("tilesPerRow").observe(DataEventType.value, with:
            {
                (snapshot) in
                print("now inside the observe thing——————")
                let retrieved = snapshot.value as? Int ?? 0
                print("just updated the number to ", retrieved)
                print("the snapshot is ", snapshot)
                print("the real value is ", snapshot.value)
                
//                valueToUpdate = callback(retrieved)
                valueToUpdate.setInt(data: callback(retrieved))
        }
        ){
            (error) in
            print("there was an error!!!!!!!!!!!!")
            print(error.localizedDescription)
        }
    }
}


class IntHolder{
    var intValue: Int
    
    init(){
        intValue = -50
    }
    
    func getInt() -> Int{
        return intValue
    }
    
    func setInt(data: Int){
        intValue = data
    }
}
