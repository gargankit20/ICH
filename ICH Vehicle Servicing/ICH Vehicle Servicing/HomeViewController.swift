//
//  HomeViewController.swift
//  ICH Vehicle Servicing
//
//  Created by Ankit Garg on 4/20/17.
//  Copyright © 2017 OSS. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController
{
    @IBAction func supplier()
    {
        UserDefaults.standard.set(0, forKey:"user")
    }
    
    @IBAction func customer()
    {
        UserDefaults.standard.set(1, forKey:"user")
    }
}
