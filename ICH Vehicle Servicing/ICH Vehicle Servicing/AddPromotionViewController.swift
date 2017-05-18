//
//  AddPromotionViewController.swift
//  ICH Vehicle Servicing
//
//  Created by Ankit Garg on 4/20/17.
//  Copyright © 2017 OSS. All rights reserved.
//

import UIKit

class AddPromotionViewController: UIViewController
{
    @IBOutlet var productNameTxt:UITextField!
    @IBOutlet var discountTxt:UITextField!
    @IBOutlet var button:UIButton!
    
    var productName:String!
    var discount:String!
    var promotionID=0
    
    override func viewDidLoad()
    {
        productNameTxt.text=productName
        discountTxt.text=discount
        
        if promotionID>0
        {
            button.setTitle("Update Promotion", for:.normal)
        }
    }
    
    @IBAction func add()
    {
        if(validateTextFieldsBeforeSubmit())
        {
            if promotionID==0
            {
                addPromotion(productNameTxt.text!, discountTxt.text!, {responseData in
                    
                    self.helperFunction(responseData)
                })
            }
            else
            {
                editPromotion(productNameTxt.text!, discountTxt.text!, promotionID, {responseData in
                    
                    self.helperFunction(responseData)
                })
            }
        }
    }
    
    func helperFunction(_ responseData:NSDictionary)
    {
        let message=responseData["message"] as! String
        
        let alertController=createAlert(message)
        self.present(alertController, animated:true)
    }
    
    func validateTextFieldsBeforeSubmit()->Bool
    {
        var alertController:UIAlertController?
        var validate=true
        
        if productNameTxt.text==""
        {
            alertController=createAlert("Please enter product name")
            validate=false
        }
        else if discountTxt.text==""
        {
            alertController=createAlert("Please enter discount")
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
