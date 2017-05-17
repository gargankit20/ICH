//
//  OptionsViewController.swift
//  ICH Vehicle Servicing
//
//  Created by Ankit Garg on 4/20/17.
//  Copyright © 2017 OSS. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController
{
    @IBOutlet var firstButton:UIButton!
    
    override func viewDidLoad()
    {
        navigationItem.hidesBackButton=true
        
        if UserDefaults.standard.integer(forKey:"user")==0
        {
            self.title="Supplier"
            firstButton.setTitle("Search Authorization", for:.normal)
        }
        else
        {
            self.title="Customer"
            firstButton.setTitle("My Vehicles", for:.normal)
        }
    }
    
    @IBAction func goTo()
    {
        if UserDefaults.standard.integer(forKey:"user")==0
        {
            performSegue(withIdentifier:"GoToSearchAuthorization", sender:nil)
        }
        else
        {
            performSegue(withIdentifier:"GoToVehicles", sender:nil)
        }
    }
}
