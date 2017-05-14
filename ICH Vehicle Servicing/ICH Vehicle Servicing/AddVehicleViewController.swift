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
        
    @IBAction func add()
    {
        if validateTextFieldsBeforeSubmit()
        {
            let customerID=UserDefaults.standard.integer(forKey:"loggedInUserID")
            
            addVehicle(registrationNo:vehicleRegistrationNoTxt.text!, driverName:driverNameTxt.text!, purchasingLimit:purchasingLimitTxt.text!, customerID:customerID, completionHandler:{responseData in
                
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
        if vehicleRegistrationNoTxt.text==""
        {
            alertController=createAlert(message:"Please enter vehicle registration number")
            validate=false
        }
        else if driverNameTxt.text==""
        {
            alertController=createAlert(message:"Please enter driver name")
            validate=false
        }
        else if purchasingLimitTxt.text==""
        {
            alertController=createAlert(message:"Please enter purchasing limit")
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
