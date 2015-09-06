//
//  MeViewController.swift
//  test
//
//  Created by Johan K. Jensen on 06/09/2015.
//  Copyright (c) 2015 adarsh bhatt. All rights reserved.
//

import UIKit
import Parse

class MeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var offers: [PFObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        fetchOffers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchOffers() {
        var query = PFQuery(className:"Offers")
        query.orderByAscending("updatedAt")
//        query.cachePolicy = PFCachePolicy.CacheThenNetwork
        query.whereKey("requester", equalTo: PFUser.currentUser()!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                println("Successfully retrieved \(objects!.count) offers.")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    self.offers = objects
                    self.tableView.reloadData()
                }
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offers == nil ? 0 : offers!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let item = self.offers![indexPath.row]
        let originalRequest = item["originalRequest"] as! PFObject
        originalRequest.fetchIfNeeded()
        let title = originalRequest["title"] as! String
        let user = item["offeredBy"]!
        user.fetchIfNeeded()
        let username = user["username"] as! String
        
        cell.textLabel?.text = "\(username) has a \(title) for you"
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
