//
//  AccountScreen.swift
//  FoodCafe
//
//  Created by Nishain on 2/28/21.
//  Copyright © 2021 Nishain. All rights reserved.
//

import UIKit

class AccountScreen: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var contactNoLabel: UILabel!
    
    var username:String?
    @IBOutlet weak var overallTotal: UILabel!
    var contactNo:String?
    override func viewDidLoad() {
        usernameLabel.text = username
        contactNoLabel.text = contactNo
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

   

}
