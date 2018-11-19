
//  ColorTileSizeViewController.swift
//  PikSpeech.V1
//
//  Created by Lance Zhang on 2018-11-19.
//  Collaboration with Miguel Taningco
//  Copyright © 2018 cmpt275group11. All rights reserved.
//
//  Change Log:
//      11/18/2018: Able to Cache the loaded tiles  (Miguel Taningco and Lance Zhang)

import Foundation
import UIKit
import FirebaseStorage

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView{
    //  Loads Image Using Cache and Firebase
    func loadImageUsingCacheWithFileNameString(fileName: String){
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: fileName as AnyObject) as? UIImage{
            self.image = imageFromCache
            return
        }
        
        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child(fileName)
        imageRef.getData(maxSize: 1 * 1024 * 1024, completion: {
            data, error in
            if let error = error{
                print("an error occured while downloading a picture from storage! Here is the error:\n", error)
            }
            else{
                var imageToCache = UIImage(data : data!)
                imageCache.setObject(imageToCache!, forKey: fileName as AnyObject)
                self.image = imageToCache
            }
        })
    }
}
