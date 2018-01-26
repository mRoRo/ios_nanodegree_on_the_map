//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Maro on 25/1/18.
//  Copyright © 2018 Maro. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func styling() {
        loginButton.backgroundColor = UIColor.udacityBlue
    }
}

