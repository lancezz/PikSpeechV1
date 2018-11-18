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
    static func downloadTilesPerRow(viewWidth: CGFloat, collectionView: UICollectionView){
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
                let retrieved = snapshot.value as? Int ?? 0
                
                //                valueToUpdate = callback(retrieved)
                let width = viewWidth / (CGFloat(retrieved) + 1.0)
                let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
                
                layout.itemSize = CGSize(width: width, height: width)
                collectionView.reloadData()
        }
        ){
            (error) in
            print(error.localizedDescription)
        }
    }
}
