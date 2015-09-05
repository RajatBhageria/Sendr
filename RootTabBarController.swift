//
//  RootTabBarController.swift
//  test
//
//  Created by Johan K. Jensen on 05/09/2015.
//  Copyright (c) 2015 adarsh bhatt. All rights reserved.
//

import UIKit
import Parse

class RootTabBarController: UITabBarController {

    override func viewDidAppear(animated: Bool) {
        if let currentUser = PFUser.currentUser() {
            NSLog("Logged in as %@ with email %@", currentUser.username!, currentUser.email!)
        } else {
            performSegueWithIdentifier("loginModally", sender: self);
        }
    }
    
}
