//
//  VehiclesViewController.swift
//  ICH Vehicle Servicing
//
//  Created by Ankit Garg on 4/20/17.
//  Copyright © 2017 OSS. All rights reserved.
//

import UIKit

class VehiclesViewController: UIViewController
{
    @IBOutlet var vehiclesTbl:UITableView!
    
    var vehicleRegistrationNosArray=NSMutableArray()
    var driverNamesArray=NSMutableArray()
    var purchasingLimitsArray=NSMutableArray()
    var vehicleIDsArray=NSMutableArray()
    
    override func viewDidLoad()
    {
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
        
        getVehicles(customerID, {responseData in
            
            self.parseData(responseData)
        })
    }
    
    func parseData(_ responseData:NSDictionary)
    {
        let vehicles=responseData["vehicles"] as! NSArray
        
        for i in 0 ..< vehicles.count
        {
            let vehicle=vehicles[i] as! NSDictionary
            
            let vehicleRegistrationNo=vehicle["registration_no"] as! String
            let driverName=vehicle["driver_name"] as! String
            let purchasingLimit=vehicle["purchasing_limit"] as! String
            let vehicleID=vehicle["vehicle_id"] as! String
            
            vehicleRegistrationNosArray.add(vehicleRegistrationNo)
            driverNamesArray.add(driverName)
            purchasingLimitsArray.add(purchasingLimit)
            vehicleIDsArray.add(vehicleID)
        }
        
        vehiclesTbl.reloadData()
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int)->Int
    {
        return vehicleIDsArray.count
    }
    
    func tableView(_ tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath)->UITableViewCell
    {
        let cell=tableView.dequeueReusableCell(withIdentifier:"Cell")!
        
        cell.textLabel?.text=driverNamesArray[indexPath.row] as? String
        cell.detailTextLabel?.text=vehicleRegistrationNosArray[indexPath.row] as? String
        
        return cell
    }
    
    func tableView(_ tableView:UITableView, editActionsForRowAtIndexPath indexPath:NSIndexPath)->[UITableViewRowAction]?
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
        }
    }
}
