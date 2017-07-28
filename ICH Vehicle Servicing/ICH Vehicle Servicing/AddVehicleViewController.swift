//
//  AddVehicleViewController.swift
//  ICH Vehicle Servicing
//
//  Created by Ankit Garg on 4/20/17.
//  Copyright © 2017 OSS. All rights reserved.
//

import UIKit

class AddVehicleViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource
{
    @IBOutlet var vehicleRegistrationNoTxt:UITextField!
    @IBOutlet var driverNameTxt:UITextField!
    @IBOutlet var brandNameTxt:UITextField!
    @IBOutlet var purchasingLimitTxt:UITextField!
    
    var vehicleRegistrationNo:String!
    var driverName:String!
    var purchasingLimit:String!
    var vehicleID=0
    var supplierID=0
    let brandNamePicker=UIPickerView()
    let supplierIDsArray=NSMutableArray()
    let brandNamesArray=NSMutableArray()
    
    override func viewDidLoad()
    {
        getAllSuppliers()
        
        brandNamePicker.delegate=self
        brandNamePicker.dataSource=self
        
        let barButtonItem1=UIBarButtonItem(barButtonSystemItem:.done, target:self, action:#selector(closePicker))
        let barButtonItem2=UIBarButtonItem(barButtonSystemItem:.flexibleSpace, target:nil, action:nil)
        
        let toolBar=UIToolbar(frame:CGRect(x:0, y:0, width:view.frame.width, height:44))
        toolBar.items=[barButtonItem2, barButtonItem1]
        
        brandNameTxt.inputView=brandNamePicker
        brandNameTxt.inputAccessoryView=toolBar

        vehicleRegistrationNoTxt.text=vehicleRegistrationNo
        driverNameTxt.text=driverName
        purchasingLimitTxt.text=purchasingLimit
        
        if vehicleID>0
        {
            self.title="Edit Vehicle"
        }
    }
    
    override func viewWillDisappear(_ animated:Bool)
    {
        view.endEditing(true)
    }
    
    func getAllSuppliers()
    {
        getSuppliers({responseData in
            
            let suppliers=responseData["suppliers"] as! NSArray
            
            for i in 0 ..< suppliers.count
            {
                let supplier=suppliers[i] as! NSDictionary
                
                let brandName=supplier["brand_name"] as! String
                let supplierID=supplier["supplier_id"] as! String
                
                self.brandNamesArray.add(brandName)
                self.supplierIDsArray.add(supplierID)
            }
            
            if self.supplierID>0
            {
                let index=self.supplierIDsArray.index(of:String(self.supplierID))
                self.brandNameTxt.text=self.brandNamesArray[index] as? String
            }
        })
    }
    
    func closePicker()
    {
        frameAnimationWithTextField(0)
        brandNameTxt.resignFirstResponder()
    }
    
    @IBAction func add()
    {
        frameAnimationWithTextField(0)
        vehicleRegistrationNoTxt.resignFirstResponder()
        driverNameTxt.resignFirstResponder()
        purchasingLimitTxt.resignFirstResponder()
        brandNameTxt.resignFirstResponder()
        
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
        var alertController:UIAlertController?
        var validate=true
        
        if vehicleRegistrationNoTxt.text==""
        {
            alertController=createAlert("Please enter vehicle registration number")
            validate=false
        }
        if brandNameTxt.text==""
        {
            alertController=createAlert("Please choose supplier")
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
        if textField==brandNameTxt
        {
            return false
        }
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField:UITextField)->Bool
    {
        if textField==driverNameTxt||textField==purchasingLimitTxt
        {
            frameAnimationWithTextField(-30)
        }
        else if textField==brandNameTxt
        {
            frameAnimationWithTextField(-75)
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
    
    func numberOfComponents(in pickerView:UIPickerView)->Int
    {
        return 1
    }
    
    func pickerView(_ pickerView:UIPickerView, numberOfRowsInComponent component:Int)->Int
    {
        return brandNamesArray.count
    }
    
    func pickerView(_ pickerView:UIPickerView, titleForRow row:Int, forComponent component:Int)->String?
    {
        return brandNamesArray[row] as? String
    }
    
    func pickerView(_ pickerView:UIPickerView, didSelectRow row:Int, inComponent component:Int)
    {
        brandNameTxt.text=brandNamesArray[row] as? String
        supplierID=Int(supplierIDsArray[row] as! String)!
    }
}
