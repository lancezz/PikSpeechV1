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
    
    
    
    @IBOutlet weak var textFieldLoginEmail: UITextField!
    
    
    @IBOutlet weak var textFieldLoginPassword: UITextField!
    
    
    @IBAction func loginButton(_ sender: Any) {
        
        performSegue(withIdentifier: "logintoMain", sender: nil)
    }
    
    @IBAction func signupButoon(_ sender: Any) {
        
        let alert = UIAlertController(title: "Register",
                                      message: "Please Provide Your Information",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { action in
                                        let emailtext = alert.textFields![0]
                                        let passwordtext = alert.textFields![1]
                                        
                                        
                                        
                                        Auth.auth().createUser(withEmail: emailtext.text!, password: passwordtext.text!) {
                                            user, error in
                                            if error != nil {
                                                print(error?.localizedDescription)
                                            }
                                              //send verification link
//                                            if user != nil {
//                                                user?.user.sendEmailVerification() {
//                                                    error in
//                                                    print(error?.localizedDescription)
//
//                                                }
//                                            }
                                            
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
        
        // Do any additional setup after loading the view.
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
