//
//  CustomerRegistrationViewController.swift
//  ICH Vehicle Servicing
//
//  Created by Ankit Garg on 4/20/17.
//  Copyright © 2017 OSS. All rights reserved.
//

import UIKit

class CustomerRegistrationViewController: UIViewController
{
    @IBOutlet var emailTxt:UITextField!
    @IBOutlet var passwordTxt:UITextField!
    @IBOutlet var usernameTxt:UITextField!
    @IBOutlet var confirmPasswordTxt:UITextField!
    
    @IBAction func signup()
    {
        if(validateTextFieldsBeforeSubmit())
        {
            customerRegistration(email:emailTxt.text!, password:passwordTxt.text!, username:usernameTxt.text!, completionHandler:{responseData in
                
                let code=responseData["code"] as! Int
                
                if(code==200)
                {
                    let loggedInUserID=responseData["user_id"] as! Int
                    UserDefaults.standard.set(loggedInUserID, forKey:"loggedInUserID")
                    self.performSegue(withIdentifier:"GoToOptions", sender:nil)
                }
                else
                {
                    let alertController=createAlert("Email is already exist")
                    self.present(alertController, animated:true)
                }
            })
        }
    }
    
    func validateTextFieldsBeforeSubmit()->Bool
    {
        var alertController:UIAlertController?
        var validate=true
        
        if !validateEmail(emailTxt.text!)
        {
            alertController=createAlert("Please enter a valid email")
            validate=false
        }
        else if passwordTxt.text==""
        {
            alertController=createAlert("Please enter your password")
            validate=false
        }
        else if usernameTxt.text==""
        {
            alertController=createAlert("Please enter your user name")
            validate=false
        }
        else if !(confirmPasswordTxt.text==passwordTxt.text)
        {
            alertController=createAlert("Please make sure your password and repeat password are the same")
            validate=false
        }
        
        if let alert=alertController
        {
            present(alert, animated:true)
        }
        
        return validate
    }
    
    func textFieldShouldReturn(_ textField:UITextField)->Bool
    {
        textField.resignFirstResponder()
        return true
    }
}
