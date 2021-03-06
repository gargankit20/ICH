//
//  PromotionsViewController.swift
//  ICH Vehicle Servicing
//
//  Created by Ankit Garg on 4/20/17.
//  Copyright © 2017 OSS. All rights reserved.
//

import UIKit

class PromotionCell: UITableViewCell
{
    @IBOutlet var productNameLbl:UILabel!
    @IBOutlet var detailLbl:UILabel!
}

class PromotionsViewController: UIViewController
{
    @IBOutlet var promotionsTbl:UITableView!
    
    var productNamesArray=NSMutableArray()
    var discountsArray=NSMutableArray()
    var promotionIDsArray=NSMutableArray()
    var canSwipe=true
    var supplierID=0
    
    override func viewDidLoad()
    {
        navigationController?.navigationBar.isExclusiveTouch=true
        
        if UserDefaults.standard.integer(forKey:"user")==1
        {
            navigationItem.rightBarButtonItem=nil
            
            canSwipe=false
        }
        else
        {
            supplierID=UserDefaults.standard.integer(forKey:"loggedInUserID")
        }
    }
    
    override func viewWillAppear(_ animated:Bool)
    {
        productNamesArray.removeAllObjects()
        discountsArray.removeAllObjects()
        promotionIDsArray.removeAllObjects()
        
        getPromotions(supplierID, {responseData in
            
            self.parseData(responseData)
        })
    }
    
    func parseData(_ responseData:NSDictionary)
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
    
    func tableView(_ tableView:UITableView, cellForRowAtIndexPath indexPath:IndexPath)->UITableViewCell
    {
        let cell=tableView.dequeueReusableCell(withIdentifier:"PromotionCell") as! PromotionCell
        
        cell.productNameLbl.text=productNamesArray[indexPath.row] as? String
        cell.detailLbl.text=discountsArray[indexPath.row] as? String
        
        return cell
    }
    
    func tableView(_ tableView:UITableView, editActionsForRowAtIndexPath indexPath:IndexPath)->[UITableViewRowAction]?
    {
        let editButton=UITableViewRowAction(style:.default, title:"Edit")
        {action, indexPath in
            
            self.performSegue(withIdentifier:"EditPromotion", sender:indexPath.row)
        }
        
        let deleteButton=UITableViewRowAction(style:.default, title:"Delete")
        {action, indexPath in
            
            let promotionID=Int(self.promotionIDsArray[indexPath.row] as! String)!
            
            deletePromotion(promotionID, {_ in
            })
            
            self.promotionIDsArray.removeObject(at:indexPath.row)
            
            tableView.deleteRows(at:[indexPath], with:.automatic)
        }
        
        editButton.backgroundColor=UIColor.lightGray
        
        return [deleteButton, editButton]
    }
    
    func tableView(_ tableView:UITableView, canEditRowAtIndexPath indexPath:IndexPath)->Bool
    {
        return canSwipe
    }
    
    override func prepare(for segue:UIStoryboardSegue, sender:Any?)
    {
        if segue.identifier=="EditPromotion"
        {
            let APVC=segue.destination as! AddPromotionViewController
            
            APVC.productName=productNamesArray[sender as! Int] as! String
            APVC.discount=discountsArray[sender as! Int] as! String
            APVC.promotionID=Int(promotionIDsArray[sender as! Int] as! String)!
        }
    }
}
