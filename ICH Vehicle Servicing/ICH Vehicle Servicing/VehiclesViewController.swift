//
//  VehiclesViewController.swift
//  ICH Vehicle Servicing
//
//  Created by Ankit Garg on 4/20/17.
//  Copyright © 2017 OSS. All rights reserved.
//

import UIKit

class VehicleCell: UITableViewCell
{
    @IBOutlet var driverNameLbl:UILabel!
    @IBOutlet var vehicleRegistrationNoLbl:UILabel!
    @IBOutlet var purchasingLimitLbl:UILabel!
}

class VehiclesViewController: UIViewController
{
    @IBOutlet var vehiclesTbl:UITableView!
    
    var vehicleRegistrationNosArray=NSMutableArray()
    var driverNamesArray=NSMutableArray()
    var purchasingLimitsArray=NSMutableArray()
    var vehicleIDsArray=NSMutableArray()
    var supplierIDsArray=NSMutableArray()
    var activityView:UIActivityIndicatorView!
    
    override func viewDidLoad()
    {
        navigationController?.navigationBar.isExclusiveTouch=true
        
        if UserDefaults.standard.integer(forKey:"user")==0
        {
            navigationItem.rightBarButtonItem=nil
        }
    }
    
    override func viewWillAppear(_ animated:Bool)
    {
        let customerID=UserDefaults.standard.integer(forKey:"loggedInUserID")
        
        vehicleRegistrationNosArray.removeAllObjects()
        driverNamesArray.removeAllObjects()
        purchasingLimitsArray.removeAllObjects()
        vehicleIDsArray.removeAllObjects()
        supplierIDsArray.removeAllObjects()
        
        activityView=showActivityIndicator(view)
        
        getVehicles(customerID, {responseData in
            
            self.parseData(responseData)
        })
    }
    
    func parseData(_ responseData:NSDictionary)
    {
        activityView.removeFromSuperview()
        
        let vehicles=responseData["vehicles"] as! NSArray
        
        for i in 0 ..< vehicles.count
        {
            let vehicle=vehicles[i] as! NSDictionary
            
            let vehicleRegistrationNo=vehicle["registration_no"] as! String
            let driverName=vehicle["driver_name"] as! String
            let purchasingLimit=vehicle["purchasing_limit"] as! String
            let vehicleID=vehicle["vehicle_id"] as! String
            let supplierID=vehicle["supplier_id"] as! String
            
            vehicleRegistrationNosArray.add(vehicleRegistrationNo)
            driverNamesArray.add(driverName)
            purchasingLimitsArray.add(purchasingLimit)
            vehicleIDsArray.add(vehicleID)
            supplierIDsArray.add(supplierID)
        }
        
        vehiclesTbl.reloadData()
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int)->Int
    {
        return vehicleIDsArray.count
    }
    
    func tableView(_ tableView:UITableView, cellForRowAtIndexPath indexPath:IndexPath)->UITableViewCell
    {
        let cell=tableView.dequeueReusableCell(withIdentifier:"VehicleCell") as! VehicleCell
        
        cell.driverNameLbl.text=(driverNamesArray[indexPath.row] as? String)=="" ? "NA" : driverNamesArray[indexPath.row] as? String
        cell.vehicleRegistrationNoLbl.text=(vehicleRegistrationNosArray[indexPath.row] as! String).uppercased()
        cell.purchasingLimitLbl.text=(purchasingLimitsArray[indexPath.row] as? String)=="0" ? "NA" : "$\(purchasingLimitsArray[indexPath.row])"
        
        return cell
    }
    
    func tableView(_ tableView:UITableView, editActionsForRowAtIndexPath indexPath:IndexPath)->[UITableViewRowAction]?
    {
        let editButton=UITableViewRowAction(style:.default, title:"Edit")
        {action, indexPath in
            
            self.performSegue(withIdentifier:"EditVehicle", sender:indexPath.row)
        }
        
        let deleteButton=UITableViewRowAction(style:.default, title:"Delete")
        {action, indexPath in
            
            let vehicleID=Int(self.vehicleIDsArray[indexPath.row] as! String)!
            
            deleteVehicle(vehicleID, {_ in
            })
            
            self.vehicleIDsArray.removeObject(at:indexPath.row)
            
            tableView.deleteRows(at:[indexPath], with:.automatic)
        }
        
        editButton.backgroundColor=UIColor.lightGray
        
        return [deleteButton, editButton]
    }
    
    override func prepare(for segue:UIStoryboardSegue, sender:Any?)
    {
        if segue.identifier=="EditVehicle"
        {
            let AVVC=segue.destination as! AddVehicleViewController
            
            AVVC.vehicleRegistrationNo=vehicleRegistrationNosArray[sender as! Int] as! String
            AVVC.driverName=driverNamesArray[sender as! Int] as! String
            AVVC.purchasingLimit=purchasingLimitsArray[sender as! Int] as! String
            AVVC.vehicleID=Int(vehicleIDsArray[sender as! Int] as! String)!
            AVVC.supplierID=Int(supplierIDsArray[sender as! Int] as! String)!
        }
    }
}
