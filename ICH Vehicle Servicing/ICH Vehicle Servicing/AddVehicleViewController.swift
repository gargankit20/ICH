//
//  AddVehicleViewController.swift
//  ICH Vehicle Servicing
//
//  Created by Ankit Garg on 4/20/17.
//  Copyright © 2017 OSS. All rights reserved.
//

import UIKit

class AddVehicleViewController: UIViewController
{
    @IBOutlet var vehicleRegistrationNoTxt:UITextField!
    @IBOutlet var driverNameTxt:UITextField!
    @IBOutlet var purchasingLimitTxt:UITextField!
    
    var vehicleRegistrationNo:String!
    var driverName:String!
    var purchasingLimit:String!
    var vehicleID=0
    var supplierID=1
    
    override func viewDidLoad()
    {
        vehicleRegistrationNoTxt.text=vehicleRegistrationNo
        driverNameTxt.text=driverName
        purchasingLimitTxt.text=purchasingLimit
        
        if vehicleID>0
        {
            self.title="Edit Vehicle"
        }
    }
    
    @IBAction func add()
    {
        vehicleRegistrationNoTxt.resignFirstResponder()
        driverNameTxt.resignFirstResponder()
        purchasingLimitTxt.resignFirstResponder()
        
        if validateTextFieldsBeforeSubmit()
        {
            let customerID=UserDefaults.standard.integer(forKey:"loggedInUserID")
            
            if vehicleID==0
            {
                addVehicle(vehicleRegistrationNoTxt.text!, driverNameTxt.text!, purchasingLimitTxt.text!, customerID, supplierID, {responseData in
                    
                    self.helperFunction(responseData)
                })
            }
            else
            {
                editVehicle(vehicleRegistrationNoTxt.text!, driverNameTxt.text!, purchasingLimitTxt.text!, vehicleID, supplierID, {responseData in
                    
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
            navigationController!.popViewController(animated:true)
        }
        else
        {
            let message=responseData["message"] as! String
            
            let alertController=createAlert(message)
            present(alertController, animated:true)
        }
    }
    
    func validateTextFieldsBeforeSubmit()->Bool
    {
        var validate=true
        
        if vehicleRegistrationNoTxt.text==""
        {
            let alertController=createAlert("Please enter vehicle registration number")
            present(alertController, animated:true)
            validate=false
        }
        
        return validate
    }

    func textFieldShouldReturn(_ textField:UITextField)->Bool
    {
        frameAnimationWithTextField(0)
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField:UITextField, shouldChangeCharactersInRange range:NSRange, replacementString string:String)->Bool
    {
        if textField==vehicleRegistrationNoTxt
        {
            if string==" "
            {
                return false
            }
        }
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField:UITextField)->Bool
    {
        if textField==driverNameTxt||textField==purchasingLimitTxt
        {
            frameAnimationWithTextField(-30)
        }
        
        return true
    }
    
    func frameAnimationWithTextField(_ originY:CGFloat)
    {
        UIView.beginAnimations(nil, context:nil)
        var frame=view.frame
        frame.origin.y=originY
        view.frame=frame
        UIView.commitAnimations()
    }
}
