//
//  DetailViewController.swift
//  test
//
//  Created by adarsh bhatt on 9/5/15.
//  Copyright (c) 2015 adarsh bhatt. All rights reserved.
//

import UIKit
import Parse

class DetailViewController: UIViewController {

    var feedItem: PFObject?
    
    @IBOutlet weak var createdBy: UILabel!
    
    @IBOutlet weak var from: UILabel!
    
    @IBOutlet weak var to: UILabel!
    
    @IBOutlet weak var notes: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func takePicture(sender: AnyObject) {
        self.performSegueWithIdentifier("RentOutViewController", sender: self)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.title = feedItem!["title"] as! String
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
