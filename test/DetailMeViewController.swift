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
    
    var objectId = ""
    var topPrice = 0;
    
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
            self.title = originalRequest["title"] as! String
            let price = originalRequest["price"] as! NSNumber
            priceLabel.text = price.stringValue
            topPrice = price.integerValue
            let user = theOffer["offeredBy"] as! PFUser
            user.fetchIfNeeded()
            let username = user["username"] as! String
            nameLabel.text = username
            objectId = user.objectId!
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
        let client = NSEClient.sharedInstance
        client.setKey("57800de7eaf96cd51e205923a8be6db4")
        var accountToAccess:Account
        
        var currentUser = PFUser.currentUser()!
        var accountId = currentUser["bankAccountID"]! as! String
        
        let offeredUser = self.offer!["offeredBy"]!
        offeredUser.fetchIfNeeded()
        let payeeId = offeredUser["bankAccountID"] as! String
        
        TransferRequest(block: {(builder:TransferRequestBuilder) in
            builder.requestType = HTTPType.POST
            builder.amount = self.topPrice
            builder.transferMedium = TransactionMedium.BALANCE
            builder.description = self.titleLabel.text
            builder.payeeId = payeeId
            builder.accountId = accountId
            builder.status = "completed"
//            builder.accountId = accountToAccess.accountId
            
        })?.send(completion: {(result) in

//            TransferRequest(block: {(builder:TransferRequestBuilder) in
//                builder.requestType = HTTPType.GET
//            })?.send(completion: {(result:TransferResult) in
//                var transfers = result.getAllTransfers()
//                
//                if transfers!.count > 0 {
//                    let transferToGet = transfers![transfers!.count-1]
//                    var transferToDelete:Transfer? = nil;
//                    for transfer in transfers! {
//                        if transfer.status == "pending" {
//                            transferToDelete = transfer
//                        }
//                    }
//                    
//                }
//            })
        })
        
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
