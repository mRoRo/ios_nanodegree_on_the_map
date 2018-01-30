//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Maro on 25/1/18.
//  Copyright © 2018 Maro. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var contentView: UIView!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeToKeyboardNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Actions
    @IBAction func userDidTapView(_ sender: AnyObject) {
        resignIfFirstResponder(userNameTextField)
        resignIfFirstResponder(passwordTextField)
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        userDidTapView(self)
        
        if userNameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            performUIUpdatesOnMain {
                self.showAlert(text:"Username or Password Empty.")
            }
        }
        else {
            getSessionId()
        }
    }
    
    // MARK: Network
    func getSessionId() {
        let userName = userNameTextField.text
        let password = passwordTextField.text
        
        UdacityClient.sharedInstance().postToGetSessionID(userName: userName!, password: password!) { (sessionId, error) in
            if let error = error {
                print("There was an error at postToGetSessionID: \(error)")
                performUIUpdatesOnMain {
                    self.showAlert(text:error.localizedDescription)
                }
            }
            else {
                if sessionId != nil {
                    print("session ID: " + sessionId!)
                    // TODO: logout
                }
            }
        }
    }
    
    // TODO: Add the link to udacity web to sign up
    
    // MARK: Styling
    private func styling() {
        loginButton.backgroundColor = UIColor.udacityBlue
    }
}
