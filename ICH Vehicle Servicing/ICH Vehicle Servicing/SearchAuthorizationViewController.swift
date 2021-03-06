//
//  SearchAuthorizationViewController.swift
//  ICH Vehicle Servicing
//
//  Created by Ankit Garg on 4/20/17.
//  Copyright © 2017 OSS. All rights reserved.
//

import UIKit

class SearchAuthorizationViewController: UIViewController
{
    @IBOutlet var vehicleRegistrationNoTxt:UITextField!
    @IBOutlet var driverLbl:UILabel!
    @IBOutlet var driverNameLbl:UILabel!
    @IBOutlet var limitLbl:UILabel!
    @IBOutlet var limitValueLbl:UILabel!
    @IBOutlet var wouldYouLikeToAuthorizeLbl:UILabel!
    @IBOutlet var authorizationNumber:UILabel!
    @IBOutlet var authorizationNumberValue:UILabel!
    @IBOutlet var yesButton:UIButton!
    @IBOutlet var noButton:UIButton!
    @IBOutlet var saveButton:UIButton!
    
    var customerID:Int!
    var authorizationNo:String!
    
    @IBAction func yes()
    {
        generateAuthorizationNo()
        
        authorizationNumberValue.text=authorizationNo
        hideAuthorizationDetail(false)
    }
    
    @IBAction func no()
    {
        vehicleRegistrationNoTxt.text=""
        hideVehicleDetail(true)
        hideAuthorizationDetail(true)
    }
    
    @IBAction func save()
    {
        let supplierID=UserDefaults.standard.integer(forKey:"loggedInUserID")
        
        approveVehicleRegistration(supplierID, customerID, authorizationNo, {responseData in
            
            let message=responseData["message"] as! String
            let code=responseData["code"] as! Int
            
            if code==200
            {
                self.no()
            }
            
            let alertController=createAlert(message)
            self.present(alertController, animated:true)
        })
    }
    
    func textFieldShouldReturn(_ textField:UITextField)->Bool
    {
        let supplierID=UserDefaults.standard.integer(forKey:"loggedInUserID")
        
        searchVehicle(supplierID, vehicleRegistrationNoTxt.text!, {responseData in
            
            self.parseData(responseData)
        })
        
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField:UITextField, shouldChangeCharactersInRange range:NSRange, replacementString string:String)->Bool
    {
        let set=CharacterSet.alphanumerics.inverted
        return string.rangeOfCharacter(from:set)==nil
    }

    func parseData(_ responseData:NSDictionary)
    {
        let code=responseData["code"] as! Int
        
        if code==200
        {
            customerID=responseData["customer_id"] as! Int
            
            driverNameLbl.text=(responseData["driver_name"] as? String)=="" ? "NA" : responseData["driver_name"] as? String
            limitValueLbl.text="$\(responseData["purchasing_limit"]!)"
            
            hideVehicleDetail(false)
        }
        else
        {
            let message=responseData["message"] as! String
            
            let alertController=createAlert(message)
            present(alertController, animated:true)
            
            hideVehicleDetail(true)
        }
        
        hideAuthorizationDetail(true)
    }
    
    func hideVehicleDetail(_ isHide:Bool)
    {
        driverLbl.isHidden=isHide
        driverNameLbl.isHidden=isHide
        limitLbl.isHidden=isHide
        limitValueLbl.isHidden=isHide
        wouldYouLikeToAuthorizeLbl.isHidden=isHide
        yesButton.isHidden=isHide
        noButton.isHidden=isHide
    }
    
    func hideAuthorizationDetail(_ isHide:Bool)
    {
        authorizationNumber.isHidden=isHide
        authorizationNumberValue.isHidden=isHide
        saveButton.isHidden=isHide
    }
    
    func generateAuthorizationNo()
    {
        let formatter=DateFormatter()
        formatter.dateFormat="ddMMyy"
        
        let brandCode=UserDefaults.standard.string(forKey:"brandCode")!
        
        authorizationNo="\(brandCode)\(formatter.string(from:Date()))\(randomLetter())\(vehicleRegistrationNoTxt.text!.uppercased())"
    }
    
    func randomLetter()->String
    {
        let uppercaseLetters=Array(97...122).map{String(UnicodeScalar($0))}
        
        let randomIndex=arc4random_uniform(UInt32(uppercaseLetters.count))
        return uppercaseLetters[Int(randomIndex)]
    }
}
