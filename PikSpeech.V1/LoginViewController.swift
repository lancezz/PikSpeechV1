//
//  LoginViewController.swift
//  PikSpeech.V1
//
//  Created by Lance Zhang on 2018-11-14.
//  Copyright © 2018 cmpt275group11. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    
    
  
    @IBOutlet weak var loginEmailField: UITextField!
    

    @IBOutlet weak var loginPasswordField: UITextField!
    
    @IBAction func loginButton(_ sender: Any) {
        Auth.auth().signIn(withEmail: loginEmailField.text!, password: loginPasswordField.text!){
            user, error in
            if error != nil {
                print("some log in error occurred")
            }
            //successsfuly logged in
                self.performSegue(withIdentifier: "logintoMain", sender: nil)
            
        }
        
    }
    
    @IBAction func signupButoon(_ sender: Any) {
        
        let alert = UIAlertController(title: "Register",
                                      message: "Please Provide Your Information",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { action in
                                        let emailtext = alert.textFields![0]
                                        let passwordtext = alert.textFields![1]
                                        
                                        
                                        //Create user with email and password on Firebase authentication
                                        //and initialize the user uid information in the real time database
                                        Auth.auth().createUser(withEmail: emailtext.text!, password: passwordtext.text!) {
                                            user, error in
                                            if error != nil {
                                                print("some registeration error occurred")
                                            }
                                              //send verification link
//                                            if user != nil {
//                                                user?.user.sendEmailVerification() {
//                                                    error in
//                                                    print(error?.localizedDescription)
//
//                                                }
//                                            }
                                            
                                            //initialize the user in the realtime database
                                            guard let uid = user?.user.uid else {
                                                return
                                            }
                                            var ref: DatabaseReference!
                                            ref = Database.database().reference()
                                            //Create a Child reference under the root based on the uid of that user
                                            let userRef = ref.child("user").child(uid)
                                            //load the default structure of a user including
                                            //name, email, categoryData/animal/image, title,selectionData/word1
//                                            let values: [String: Any] = ["email": emailtext.text!]
//                                            userRef.setValue(values)
//                                            userRef.observe(.value) { (snapshot) in
//                                                print(snapshot)
//                                            }
                                            ///////crate a reference to category Data under the uid
                                            let categoryDataRef = userRef.child("categoryData")
                                            let animalRef = categoryDataRef.child("Animals")
//                                            let animalElement = [
//                                               0 = {
//                                                "title" = "Animals";
//                                                "image" = "287392";
//                                                    "selectionData" = [
//                                                        "cow",
//                                                        "cat"
//                                                    ]
//                                                }
//                                            ]
//                                            let clothingRef = categoryDataRef.child("Clothing")
//                                            let drinksRef = categoryDataRef.child("Drinks")
//                                            let feelingsRef = categoryDataRef.child("Feelings")
//                                            let foodRef = categoryDataRef.child("food")
//                                            let commonRef = categoryDataRef.child("common")
//                                            let peopleRef = categoryDataRef.child("people")
                                            
                                            let animalsvalues: [String: Any] = ["title": "Animals","image": "cow.jpg"]
                                            animalRef.setValue(animalsvalues)
                                            let selectionDataRef = animalRef.child("selectionData")
                                            let selectionDataValues = ["cow","cat"]
                                            selectionDataRef.setValue(selectionDataValues)
                                        }
                                        
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField { textEmail in
            textEmail.placeholder = "Enter your email"
            
        }
        
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let listener = Auth.auth().addStateDidChangeListener{
//            auth, user in
//            if user != nil {
//                self.performSegue(withIdentifier: "logintoMain", sender: nil)
//            }
//        }
//        Auth.auth().removeStateDidChangeListener(listener)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
