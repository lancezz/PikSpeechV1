//
//  ColorManager.swift
//  PikSpeech.V1
//
//  Created by Lance Zhang on 2018-11-18.
//  Collaboration with Miguel Taningco and Lance Zhang
//  Copyright © 2018 CMPT 275 Group11: A-team. All rights reserved.
//
//  Change Log:
//      11/18/2018: Allows app to query for data regarding colors (Miguel Taningco and Lance Zhang)

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

enum SpecificCollectionView{
    case selectionCollectionView
    case categoryCollectionView
    case speechCollectionView
}

class ColorManager{
    static func downloadColorForCollectionView(collectionView: UICollectionView, collectionEnum: SpecificCollectionView, appView: UIView){
        let user = Auth.auth().currentUser
        guard let uid = user?.uid else
        {
            return
        }
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let userRef = ref.child("user").child(uid)
        
        var childString: String = ""
        
        switch collectionEnum {
        case SpecificCollectionView.selectionCollectionView:
            childString = "selectionColor"
        case SpecificCollectionView.categoryCollectionView:
            childString = "categoryColor"
//        case SpecificCollectionView.speechCollectionView:
//            childString = "speechColor"
        default:
            childString = "speechColor"
        }
        
        userRef.child(childString).observe(DataEventType.value, with:
            {
                (snapshot) in
//                print(snapshot)
                let postDict = snapshot.value as? [String: AnyObject] ?? [:]
                
                let r = postDict["R"] as? CGFloat ?? 1
                let g = postDict["G"] as? CGFloat ?? 0
                let b = postDict["B"] as? CGFloat ?? 0
                
                collectionView.backgroundColor = UIColor(displayP3Red: r, green: g, blue: b, alpha: 1)
                collectionView.reloadData()
                if(collectionEnum == SpecificCollectionView.speechCollectionView){
                    //we also want to update the app background
                    appView.backgroundColor = collectionView.backgroundColor
                }
        }
        ){
            (error) in
            print(error.localizedDescription)
        }
    }
}
