//
//  PromotionsViewController.swift
//  ICH Vehicle Servicing
//
//  Created by Ankit Garg on 4/20/17.
//  Copyright © 2017 OSS. All rights reserved.
//

import UIKit

class PromotionsViewController: UIViewController
{
    @IBOutlet var promotionsTbl:UITableView!
    
    var productNamesArray=NSMutableArray()
    var discountsArray=NSMutableArray()
    var promotionIDsArray=NSMutableArray()
    var canSwipe=true
    
    override func viewDidLoad()
    {
        if UserDefaults.standard.integer(forKey:"user")==1
        {
            navigationItem.rightBarButtonItem=nil
            
            canSwipe=false
        }
    }
    
    override func viewWillAppear(_ animated:Bool)
    {
        productNamesArray.removeAllObjects()
        discountsArray.removeAllObjects()
        promotionIDsArray.removeAllObjects()
        
        getPromotions(completionHandler:{responseData in
            
            self.parseData(responseData:responseData)
        })
    }
    
    func parseData(responseData:NSDictionary)
    {
        let promotions=responseData["promotions"] as! NSArray
        
        for i in 0 ..< promotions.count
        {
            let promotion=promotions[i] as! NSDictionary
            
            let productName=promotion["product_name"] as! String
            let discount=promotion["discount"] as! String
            let promotionID=promotion["promotion_id"] as! String
            
            productNamesArray.add(productName)
            discountsArray.add(discount)
            promotionIDsArray.add(promotionID)
        }
        
        promotionsTbl.reloadData()
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int)->Int
    {
        return promotionIDsArray.count
    }
    
    func tableView(_ tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath)->UITableViewCell
    {
        let cell=tableView.dequeueReusableCell(withIdentifier:"Cell")!
        
        cell.textLabel?.text=productNamesArray[indexPath.row] as? String
        cell.detailTextLabel?.text=discountsArray[indexPath.row] as? String
        
        return cell
    }
    
    func tableView(_ tableView:UITableView, editActionsForRowAtIndexPath indexPath:NSIndexPath)->[UITableViewRowAction]?
    {
        let editButton=UITableViewRowAction(style:.default, title:"Edit")
        {action, indexPath in
            
        }
        
        let deleteButton=UITableViewRowAction(style:.default, title:"Delete")
        {action, indexPath in
            
            tableView.deleteRows(at:[indexPath], with:.automatic)
        }
        
        editButton.backgroundColor=UIColor.lightGray
        
        return [deleteButton, editButton]
    }
    
    func tableView(_ tableView:UITableView, canEditRowAtIndexPath indexPath:NSIndexPath)->Bool
    {
        return canSwipe
    }
}
