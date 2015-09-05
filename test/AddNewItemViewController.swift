//
//  AddNewItemViewController.swift
//  test
//
//  Created by Johan K. Jensen on 05/09/2015.
//  Copyright (c) 2015 adarsh bhatt. All rights reserved.
//

import UIKit
import AVFoundation

class AddNewItemViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("editTableViewCell") as! UITableViewCell //UITableViewCell(style: .Value1, reuseIdentifier: nil)
        
        if indexPath.row == 0 {
            let textField = cell.viewWithTag(1) as! UITextField
            textField.placeholder = "Title"
        } else if indexPath.row == 1 {
            let textField = cell.viewWithTag(1) as! UITextField
            textField.placeholder = "Price"
        }
        return cell
    }

    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
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
