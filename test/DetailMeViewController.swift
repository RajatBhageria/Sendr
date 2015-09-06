//
//  DetailMeViewController.swift
//  test
//
//  Created by Johan K. Jensen on 06/09/2015.
//  Copyright (c) 2015 adarsh bhatt. All rights reserved.
//

import UIKit
import Parse

class DetailMeViewController: UIViewController {

    var offer: PFObject?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This shouldn’t be on the main thread
        if let theOffer = offer {
            if let file = theOffer["image"] as? PFFile {
                file.getDataInBackgroundWithBlock({ (data, error) -> Void in
                    if (error != nil) { return }
                    self.imageView.image = UIImage(data: data!)
                })
            }
            let originalRequest = theOffer["originalRequest"]!
            originalRequest.fetchIfNeeded()
            titleLabel.text = originalRequest["title"] as! String
            let price = originalRequest["price"] as! NSNumber
            priceLabel.text = price.stringValue
            let user = theOffer["offeredBy"] as! PFUser
            user.fetchIfNeeded()
            let username = user["username"] as! String
            nameLabel.text = username
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func acceptOffer(sender: AnyObject) {
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
