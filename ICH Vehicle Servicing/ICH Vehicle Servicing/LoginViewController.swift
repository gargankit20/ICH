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
    @IBOutlet var messageLbl:UILabel!
    @IBOutlet var loginButton:UIButton!
    
    var activityView:UIActivityIndicatorView!
    
    override func viewDidLoad()
    {
        loginButton.isExclusiveTouch=true
        
        if UserDefaults.standard.integer(forKey:"user")==0
        {
            signupButton.isHidden=true
            forgotPasswordButton.isHidden=true
            messageLbl.isHidden=true
        }
    }
    
    @IBAction func login()
    {
        if validateTextFieldsBeforeSubmit()
        {
            activityView=showActivityIndicator(view)
            
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
        activityView.removeFromSuperview()
        
        let code=responseData["code"] as! Int
        
        if code==200
        {
            if UserDefaults.standard.integer(forKey:"user")==0
            {
                let brandCode=responseData["brand_code"] as! String
                UserDefaults.standard.set(brandCode, forKey:"brandCode")
            }
            
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
        
        if emailTxt.text==""
        {
            alertController=createAlert("Please enter a valid email or username")
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
