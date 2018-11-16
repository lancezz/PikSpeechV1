//
//  SettingsViewController.swift
//  PikSpeech.V1
//
//  Created by Lance Zhang on 2018-11-02.
//  Copyright © 2018 cmpt275group11. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    //logout handler
    func handlelogout() {
        let logincontroller = LoginViewController()
        present(logincontroller, animated: true, completion: nil)
    }

}
