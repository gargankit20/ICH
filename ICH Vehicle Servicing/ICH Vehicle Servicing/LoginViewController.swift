//
//  LoginViewController.swift
//  ICH Vehicle Servicing
//
//  Created by Ankit Garg on 4/20/17.
//  Copyright © 2017 OSS. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController
{
    @IBOutlet var emailTxt:UITextField!
    @IBOutlet var passwordTxt:UITextField!
    @IBOutlet var signupButton:UIButton!
    @IBOutlet var forgotPasswordButton:UIButton!
    
    override func viewDidLoad()
    {
        if UserDefaults.standard.integer(forKey:"user")==0
        {
            signupButton.isHidden=true
            forgotPasswordButton.isHidden=true
        }
    }
    
    @IBAction func login()
    {
        if validateTextFieldsBeforeSubmit()
        {
            if UserDefaults.standard.integer(forKey:"user")==0
            {
                supplierLogin(emailTxt.text!, passwordTxt.text!, {responseData in
                    
                    self.helperFunction(responseData)
                })
            }
            else
            {
                customerLogin(emailTxt.text!, passwordTxt.text!, {responseData in
                    
                    self.helperFunction(responseData)
                })
            }
        }
    }
    
    func helperFunction(_ responseData:NSDictionary)
    {
        let code=responseData["code"] as! Int
        
        if code==200
        {
            let loggedInUserID=responseData["user_id"] as! Int
            UserDefaults.standard.set(loggedInUserID, forKey:"loggedInUserID")
            performSegue(withIdentifier:"GoToFirst", sender:nil)
        }
        else
        {
            let alertController=createAlert("Invalid credentials")
            present(alertController, animated:true)
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
