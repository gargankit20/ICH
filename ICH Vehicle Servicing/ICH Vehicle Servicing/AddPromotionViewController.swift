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
    
    var productName:String!
    var discount:String!
    var promotionID=0
    var maxCharacters:Int!
    
    override func viewDidLoad()
    {
        productNameTxt.text=productName
        discountTxt.text=discount
        
        if promotionID>0
        {
            self.title="Edit Promotion"
        }
    }
    
    @IBAction func add()
    {
        productNameTxt.resignFirstResponder()
        discountTxt.resignFirstResponder()
        
        if(validateTextFieldsBeforeSubmit())
        {
            if promotionID==0
            {
                let supplierID=UserDefaults.standard.integer(forKey:"loggedInUserID")
                
                addPromotion(supplierID, productNameTxt.text!, discountTxt.text!, {responseData in
                    
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
        navigationController!.popViewController(animated:true)
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
    
    func textFieldDidBeginEditing(_ textField:UITextField)
    {
        if textField==productNameTxt
        {
            maxCharacters=30
        }
        else
        {
            maxCharacters=80
        }
    }
    
    func textField(_ textField:UITextField, shouldChangeCharactersInRange range:NSRange, replacementString string:String)->Bool
    {
        let currentCharacterCount=textField.text?.characters.count ?? 0
        if (range.length+range.location>currentCharacterCount)
        {
            return false
        }
        
        let newLength=currentCharacterCount+string.characters.count-range.length
        return newLength<=maxCharacters
    }
}
