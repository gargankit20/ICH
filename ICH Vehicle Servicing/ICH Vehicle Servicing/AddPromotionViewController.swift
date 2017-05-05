//
//  AddPromotionViewController.swift
//  ICH Vehicle Servicing
//
//  Created by Ankit Garg on 4/20/17.
//  Copyright © 2017 OSS. All rights reserved.
//

import UIKit

class AddPromotionViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet var productNameTxt:UITextField!
    @IBOutlet var discountTxt:UITextField!
    
    @IBAction func add()
    {
        if(validateTextFieldsBeforeSubmit())
        {
            addPromotion(productName:productNameTxt.text!, discount:discountTxt.text!, completionHandler:{responseData in
                
                let message=responseData["message"] as! String
                
                let alertController=createAlert(message:message)
                self.present(alertController, animated:true, completion:nil)
            })
        }
    }
    
    func validateTextFieldsBeforeSubmit()->Bool
    {
        var alertController:UIAlertController?
        var validate=true
        if productNameTxt.text==""
        {
            alertController=createAlert(message:"Please enter product name")
            validate=false
        }
        else if discountTxt.text==""
        {
            alertController=createAlert(message:"Please enter discount")
            validate=false
        }
        
        if let alert=alertController
        {
            present(alert, animated:true, completion:nil)
        }
        
        return validate
    }
    
    func textFieldShouldReturn(_ textField:UITextField)->Bool
    {
        textField.resignFirstResponder()
        return true
    }
}
