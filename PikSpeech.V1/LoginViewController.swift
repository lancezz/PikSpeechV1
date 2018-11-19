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
            else{
                self.performSegue(withIdentifier: "logintoMain", sender: nil)}
            
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
                                
                                            //Initlize tilesPerRow
                                            
                                
                                            let numberOfTiles = ["tilesPerRow": 5]
                                            userRef.setValue(numberOfTiles)
                                            //load the default structure of a user including
                                            //name, email, categoryData/animal/image, title,selectionData/word1
                                            //                                            let values: [String: Any] = ["email": emailtext.text!]
                                            //                                            userRef.setValue(values)
                                            //                                            userRef.observe(.value) { (snapshot) in
                                            //                                                print(snapshot)
                                            //                                            }
                                            //initialize selectioncolor
                                            let selectioncolorRef = userRef.child("selectionColor")
                                            var colorValues: [String: Any] = ["R": 0.925, "G": 0.82, "B": 0.87]
                                            selectioncolorRef.setValue(colorValues)
                                            
                                            let speechColorRef = userRef.child("speechColor")
                                            speechColorRef.setValue(colorValues)
                                            
                                            colorValues["R"] = 0.5
                                            colorValues["G"] = 0.5
                                            colorValues["B"] = 0.5
                                            let categoryColorRef = userRef.child("categoryColor")
                                            categoryColorRef.setValue(colorValues)
                                            
                                            ///////crate a reference to category Data under the uid
                                            let categoryDataRef = userRef.child("categoryData")
                                            let animalRef = categoryDataRef.child("Animals")
                                            let clothingRef = categoryDataRef.child("Clothing")
                                            let drinksRef = categoryDataRef.child("Drinks")
                                            let feelingsRef = categoryDataRef.child("Feelings")
                                            let foodRef = categoryDataRef.child("food")
                                            let commonRef = categoryDataRef.child("common")
                                            let peopleRef = categoryDataRef.child("people")
                                            
                                            //animal default reference/image set creation
                                            let animalsvalues: [String: Any] = ["title": "Animals","image": "cow.jpg"]
                                            animalRef.setValue(animalsvalues)
                                            let selectionAnimalsRef = animalRef.child("selectionData")
                                            let selectionAnimalsValues = ["bear","cat","chicken","cow","dog","fish","pig","rabbit","squirrel","turtle"]
                                            selectionAnimalsRef.setValue(selectionAnimalsValues)
                                            
                                            //clothing default reference
                                            let clothingvalues: [String: Any] = ["title": "Clothing","image": "glasses.jpg"]
                                            clothingRef.setValue(clothingvalues)
                                            let selectionClothingRef = clothingRef.child("selectionData")
                                            let selectionClothingValues = ["glasses","gloves","hat","jacket","shirt","shoes","shorts","socks"]
                                            
                                            selectionClothingRef.setValue(selectionClothingValues)
                                            
                                            //drinks default reference
                                            let drinksvalues: [String: Any] = ["title": "Drinks","image": "Milk.jpg"]
                                            drinksRef.setValue(drinksvalues)
                                            let selectionDrinksRef = drinksRef.child("selectionData")
                                            let selectionDrinksValues = ["Juice","Milk","Soda","Tea"]
                                            selectionDrinksRef.setValue(selectionDrinksValues)
                                            
                                            //feeling default reference
                                            let feelingsvalues: [String: Any] = ["title": "Feelings","image": "Love.jpg"]
                                            feelingsRef.setValue(feelingsvalues)
                                            let selectionFeelingsRef = feelingsRef.child("selectionData")
                                            let selectionFeelingsValues = ["Angry","Cold","confused","disgust","Happy","Hot","hungry","Love","Sad","shocked","Sick","Sleepy"]
                                            selectionFeelingsRef.setValue(selectionFeelingsValues)
                                            //foodref default reference
                                            let foodvalues: [String: Any] = ["title": "Food","image": "Pizza.jpg"]
                                            foodRef.setValue(foodvalues)
                                            let selectionFoodRef = foodRef.child("selectionData")
                                            let selectionFoodValues = ["Bagels","burger","carrot","cheese","Chocolate","Eggs","Ice-cream","nuts","pasta","Pizza","potato","Sandwich","vegetables"]
                                            selectionFoodRef.setValue(selectionFoodValues)
                                            
                                            //common default reference
                                            let commonvalues: [String: Any] = ["title": "common","image": "go.jpg"]
                                            commonRef.setValue(commonvalues)
                                            let selectionCommonRef = commonRef.child("selectionData")
                                            let selectionCommonValues = ["go","i","like","no","question","stop","you","yeet"]
                                            selectionCommonRef.setValue(selectionCommonValues)
                                            
                                            //people defualt reference
                                            let peoplevalues: [String: Any] = ["title": "people","image": "girl.jpg"]
                                            peopleRef.setValue(peoplevalues)
                                            let selectionPeopleRef = peopleRef.child("selectionData")
                                            let selectionPeopleValues = ["baby","boy","dad","girl","grandpa"]
                                            selectionPeopleRef.setValue(selectionPeopleValues)
                                            
                                            //initialize tileData reference which stores the actual information of the images
                                            let imageDefaultArray = ["bear","cat","chicken","cow","dog","fish","pig","rabbit","squirrel","turtle","glasses","gloves","hat","jacket","shirt","shoes","shorts","socks","Juice","Milk","Soda","Tea","Angry","Cold","confused","disgust","Happy","Hot","hungry","Love","Sad","shocked","Sick","Sleepy","Bagels","burger","carrot","cheese","Chocolate","Eggs","Ice-cream","nuts","pasta","Pizza","potato","Sandwich","vegetables","go","i","like","no","question","stop","you","yeet","baby","boy","dad","girl","grandpa"]
                                            
                                            
                                              let tileDataRef = userRef.child("tileData")

                                            for defaultimages in imageDefaultArray {
                                                let defaultImageRef = tileDataRef.child("\(defaultimages)")
                                                let imagevalue = ["frequency": 0, "title": "\(defaultimages)", "Image": "\(defaultimages).jpg"] as [String : Any]
                                                defaultImageRef.setValue(imagevalue)
                                            }
                                            
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
