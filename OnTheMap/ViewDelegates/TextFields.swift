//
//  TextFields.swift
//  OnTheMap
//
//  Created by Maro on 26/1/18.
//  Copyright © 2018 Maro. All rights reserved.
//

import UIKit


// MARK: - LoginViewController: UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {


    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
 
    // MARK: Show/Hide Keyboard
    func getViewYShift(notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let buttonY = (loginButton?.frame.origin.y)! + stackView.frame.origin.y + contentView.frame.origin.y
        let keyboradY = view.frame.height - keyboardHeight(notification)
        
        // The keyboard would hide the TFs over the button
        // Move the view up
        if (buttonY > keyboradY) {
            view.frame.origin.y = keyboradY - buttonY
        }
            
        // The keyboard will not hide any TF
        // Do not move the view.
        else {
            view.frame.origin.y = 0
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    private func keyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    public func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
    // MARK: Notifications
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }

    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
}


extension AddLocationController: UITextFieldDelegate {
        // MARK: UITextFieldDelegate
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
        
        // MARK: Show/Hide Keyboard
        func getViewYShift(notification: Notification) -> CGFloat {
            let userInfo = notification.userInfo!
            let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
            return keyboardSize.cgRectValue.height
        }
        
        @objc func keyboardWillShow(_ notification: Notification) {
            let buttonY = (findLocationButton?.frame.origin.y)! + stackView.frame.origin.y
            let keyboradY = view.frame.height - keyboardHeight(notification)
            
            // The keyboard would hide the TFs over the button
            // Move the view up
            if (buttonY > keyboradY) {
                view.frame.origin.y = keyboradY - buttonY
            }
                
                // The keyboard will not hide any TF
                // Do not move the view.
            else {
                view.frame.origin.y = 0
            }
        }
        
        @objc func keyboardWillHide(_ notification: Notification) {
            view.frame.origin.y = 0
        }
        
        private func keyboardHeight(_ notification: Notification) -> CGFloat {
            let userInfo = (notification as NSNotification).userInfo
            let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
            return keyboardSize.cgRectValue.height
        }
        
        public func resignIfFirstResponder(_ textField: UITextField) {
            if textField.isFirstResponder {
                textField.resignFirstResponder()
            }
        }
        
        // MARK: Notifications
        func subscribeToKeyboardNotifications() {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        }
        
        func unsubscribeToKeyboardNotifications() {
            NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
            NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        }
    }
