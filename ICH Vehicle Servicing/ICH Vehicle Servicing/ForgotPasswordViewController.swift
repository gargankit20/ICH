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
    @IBAction func forgotPassword()
    {
        if validateEmail(email:emailTxt.text!)
        {
            
        }
        else
        {
            let alertController=createAlert(message:"Please enter a valid email")
            present(alertController, animated:true)
        }
    }
    
    func textFieldShouldReturn(_ textField:UITextField)->Bool
    {
        textField.resignFirstResponder()
        return true
    }
}
