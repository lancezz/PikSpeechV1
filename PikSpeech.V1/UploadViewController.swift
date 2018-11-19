//
//  UploadViewController.swift
//  PikSpeech.V1
//
//  Created by Lance Zhang on 2018-11-18.
//  Copyright © 2018 cmpt275group11. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class UploadViewController: UIViewController {
    
    @IBOutlet weak var uploadImagePreview: UIImageView!
    
    @IBAction func picFromLibrary(_ sender: Any) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func uploadToFirebase(_ sender: Any) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let date = NSDate().timeIntervalSince1970
        print("Loading the timestamp as the Image name in storage",date)
        let newUploadRef = storageRef.child("\(date).jpg")
        //Update the storage on Firebase
       if let uploadData = uploadImagePreview.image?.jpegData(compressionQuality: 0.1){
        let uploadTask = newUploadRef.putData(uploadData, metadata: nil, completion: {
            metadata, error in
            if error != nil {
                return
            }
            //print(metadata)
            
        })
        }
        //Update the Firebase Database
        
        
    }
    var picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
      
        
    
    }
    
//    static func uploadImage(_ image: UIImage, at reference: StorageReference, completion: @escaping (?))
   
 

}

extension UploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            uploadImagePreview.contentMode = .scaleAspectFit
            self.uploadImagePreview.image=chosenImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
}
