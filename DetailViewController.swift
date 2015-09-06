//
//  DetailViewController.swift
//  test
//
//  Created by adarsh bhatt on 9/5/15.
//  Copyright (c) 2015 adarsh bhatt. All rights reserved.
//

import UIKit
import Parse

class DetailViewController: UIViewController, CameraDelegate {

    var feedItem: PFObject?
    var objectIdOfOfferer = "";
    
    @IBOutlet weak var createdBy: UILabel!
    @IBOutlet weak var from: UILabel!
    @IBOutlet weak var to: UILabel!
    @IBOutlet weak var notes: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBAction func takePicture(sender: AnyObject) {
        self.performSegueWithIdentifier("cameraSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "cameraSegue" {
            let rentOutVC = segue.destinationViewController as! RentOutViewController
            rentOutVC.delegate = self
        }
    }
    
    func pictureWasTaken(image: UIImage) {
        imageView.image = image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.title = feedItem!["title"] as? String
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        formatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        if let toDate = feedItem!["toDate"] as? NSDate {
            let dateString = formatter.stringFromDate(toDate)
            self.to.text = dateString
        }
        if let fromDate = feedItem!["fromDate"] as? NSDate {
            let dateString = formatter.stringFromDate(fromDate)
            self.from.text = dateString
        }
        
        if let user = feedItem!["createdBy"] as? PFUser {
            user.fetchIfNeeded()
            self.createdBy.text = user["username"]! as? String
            objectIdOfOfferer = user.objectId!
        }
        
        if let theNotes = feedItem!["notes"] as? String {
            self.notes.text = theNotes
        }
    }
    
    @IBAction func sendOffer(sender: AnyObject) {
        var parseObject = PFObject(className: "Offers")
        parseObject["offeredBy"] = PFUser.currentUser()
        
        if let imageData = UIImagePNGRepresentation(imageView.image) {
            let imageFile = PFFile(data: imageData)
            imageFile.saveInBackground()
            parseObject["image"] = imageFile
        }
        let createdByUser = feedItem!["createdBy"]
        createdByUser?.fetchIfNeeded()
        parseObject["requester"] = createdByUser
        parseObject["originalRequest"] = feedItem
        parseObject.saveInBackgroundWithBlock({ (success, error) -> Void in
            if success {
                let alertView = UIAlertView(title: "Offer was successfully send", message: ":)", delegate: self, cancelButtonTitle: "OK")
                alertView.show()
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                let alertView = UIAlertView(title: "Didn’t succeed sending the offer", message: ":(", delegate: self, cancelButtonTitle: "OK")
                alertView.show()
            }
        })
        
        
        var currentUser = PFUser.currentUser()!
        var accountId = currentUser.objectId!
        
        TransferRequest(block: {(builder:TransferRequestBuilder) in
            builder.requestType = HTTPType.POST
            builder.amount = 20
            builder.transferMedium = TransactionMedium.BALANCE
            builder.description = self.notes.text
            builder.payeeId = self.objectIdOfOfferer
            
        })?.send(completion: {(result) in
            TransferRequest(block: {(builder:TransferRequestBuilder) in
                builder.requestType = HTTPType.GET
            })?.send(completion: {(result:TransferResult) in
                var transfers = result.getAllTransfers()
                
                if transfers!.count > 0 {
                    let transferToGet = transfers![transfers!.count-1]
                    var transferToDelete:Transfer? = nil;
                    for transfer in transfers! {
                        if transfer.status == "pending" {
                            transferToDelete = transfer
                        }
                    }
                    
                }
            })
            
        })
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
