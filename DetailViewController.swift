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
            self.createdBy.text = user["username"]! as! String
        }
        
        if let theNotes = feedItem!["notes"] as? String {
            self.notes.text = theNotes
        }
        
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
