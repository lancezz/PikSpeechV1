//
//  Extensions.swift
//  PikSpeech.V1
//
//  Created by Miguel Taningco on 2018-11-18.
//  Copyright © 2018 cmpt275group11. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView{
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
