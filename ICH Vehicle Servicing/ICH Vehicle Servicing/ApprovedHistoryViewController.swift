//
//  ApprovedHistoryViewController.swift
//  ICH Vehicle Servicing
//
//  Created by Ankit Garg on 4/20/17.
//  Copyright © 2017 OSS. All rights reserved.
//

import UIKit

class ApprovedHistoryViewController: UIViewController
{
    @IBOutlet var historyTbl:UITableView!
    
    var authorizationNosArray=NSMutableArray()
    var approvalDatesArray=NSMutableArray()
    
    override func viewDidLoad()
    {
        let userID=UserDefaults.standard.integer(forKey:"loggedInUserID")
        let identifier=UserDefaults.standard.integer(forKey:"user")
        
        getApprovalHistory(userID, identifier, {responseData in
            
            self.parseData(responseData)
        })
    }
    
    func parseData(_ responseData:NSDictionary)
    {
        let approvalhistory=responseData["approvalhistory"] as! NSArray
        
        for i in 0 ..< approvalhistory.count
        {
            let oneapprovalhistory=approvalhistory[i] as! NSDictionary
            
            let authorizationNo=oneapprovalhistory["authorization_no"] as! String
            let approvalDate=oneapprovalhistory["approval_date"] as! String
            
            authorizationNosArray.add(authorizationNo)
            approvalDatesArray.add(approvalDate)
        }
        
        historyTbl.reloadData()
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int)->Int
    {
        return authorizationNosArray.count
    }
    
    func tableView(_ tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath)->UITableViewCell
    {
        let cell=tableView.dequeueReusableCell(withIdentifier:"Cell")!
        
        cell.textLabel?.text=authorizationNosArray[indexPath.row] as? String
        cell.detailTextLabel?.text=approvalDatesArray[indexPath.row] as? String
        
        return cell
    }
}
