//
//  ForgotPasswordViewController.swift
//  ICH Vehicle Servicing
//
//  Created by Ankit Garg on 5/15/17.
//  Copyright © 2017 OSS. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController
{
    @IBOutlet var emailTxt:UITextField!
    
    @IBAction func forgotPassword()
    {
        if validateEmail(emailTxt.text!)
        {
            getPassword(emailTxt.text!, completionHandler:{responseData in
                
                let message=responseData["message"] as! String
                
                let alertController=createAlert(message)
                self.present(alertController, animated:true)
            })
        }
        else
        {
            let alertController=createAlert("Please enter a valid email")
            present(alertController, animated:true)
        }
    }
    
    func textFieldShouldReturn(_ textField:UITextField)->Bool
    {
        textField.resignFirstResponder()
        return true
    }
}
