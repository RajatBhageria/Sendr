//
//  AddNewItemFormViewController.swift
//  test
//
//  Created by Johan K. Jensen on 05/09/2015.
//  Copyright (c) 2015 adarsh bhatt. All rights reserved.
//

import UIKit
import Parse

class AddNewItemFormViewController: XLFormViewController {

    
    private enum Tags : String {
        case DateInline = "dateInline"
        case TimeInline = "timeInline"
        case DateTimeInline = "dateTimeInline"
        case CountDownTimerInline = "countDownTimerInline"
        case DatePicker = "datePicker"
        case Date = "date"
        case Time = "time"
        case DateTime = "dateTime"
        case CountDownTimer = "countDownTimer"
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add New Request"
        
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancel:")
        self.navigationItem.leftBarButtonItem = cancelBarButton
        
        let doneBarButton = UIBarButtonItem(title: "Submit", style: UIBarButtonItemStyle.Plain, target: self, action: "done:")
        self.navigationItem.rightBarButtonItem = doneBarButton
        
        initializeForm()
        // Do any additional setup after loading the view.
    }
    
    func cancel(sender: AnyObject?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func done(sender: AnyObject?) {
        
        let validationErrors : Array<NSError> = self.formValidationErrors() as! Array<NSError>
        if (validationErrors.count > 0){
//            self.showFormValidationError(validationErrors.first)
            validateForm()
            return
        }
        self.tableView.endEditing(true)
//        let alertView = UIAlertView(title: "Valid Form", message: "No errors found", delegate: self, cancelButtonTitle: "OK")
//        alertView.show()
        
        let formValues = self.formValues() as! [String: AnyObject]
        let address = (formValues["location"] as! NSString).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let dataUrl = "https://maps.googleapis.com/maps/api/geocode/json?address=" + address + "&key=AIzaSyB8w5z0QNIWZLokQwuMzVsiIgH-u6NRQJg"
        let url = NSURL(string: dataUrl)!
        
        let downloadTask: NSURLSessionDataTask = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            
            let res = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers | .AllowFragments, error: nil) as! [String: AnyObject]
            if let res2 = res["results"] as? [[String: AnyObject]] {
                if let geometry = res2[0]["geometry"] as? [String: AnyObject] {
                    if let location = geometry["location"] as? [String: AnyObject] {
                        let lat = location["lat"]! as! Double
                        let lng = location["lng"]! as! Double
                        
                        //title, created by, from datae, to date, location
                        
                        var parseObject = PFObject(className: "RentFeed")
                        parseObject["location"] = PFGeoPoint(latitude: lat, longitude: lng)
                        parseObject["createdBy"] = PFUser.currentUser()
                        parseObject["title"] = formValues["title"]
                        parseObject["notes"] = formValues["notes"]
                        parseObject["toDate"] = formValues["toDate"]
                        parseObject["toDate"] = formValues["fromDate"]
                        parseObject.saveInBackgroundWithBlock({ (success, error) -> Void in
                            if success {
                                self.dismissViewControllerAnimated(true, completion: nil)
                            } else {
                                let alertView = UIAlertView(title: "Didn’t succeed posting", message: ":(", delegate: self, cancelButtonTitle: "OK")
                                alertView.show()
                            }
                        })
                        
                        
                    }
                }
            }
        })
        downloadTask.resume()
    }
    
    
    func validateForm() {
        let array = self.formValidationErrors()
        for errorItem in array {
            let error = errorItem as! NSError
            let validationStatus : XLFormValidationStatus = error.userInfo![XLValidationStatusErrorKey] as! XLFormValidationStatus
            if validationStatus.rowDescriptor!.tag == Tags.DateInline.rawValue ||
                validationStatus.rowDescriptor!.tag == "title" ||
                validationStatus.rowDescriptor!.tag == "notes" ||
                validationStatus.rowDescriptor!.tag == "location" {
                    if let cell = self.tableView.cellForRowAtIndexPath(self.form.indexPathOfFormRow(validationStatus.rowDescriptor)!) {
                        self.animateCell(cell)
                    }
            }
        }
    }
    
    func animateCell(cell: UITableViewCell) {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values =  [0, 20, -20, 10, 0]
        animation.keyTimes = [0, (1 / 6.0), (3 / 6.0), (5 / 6.0), 1]
        animation.duration = 0.3
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.additive = true
        cell.layer.addAnimation(animation, forKey: "shake")
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeForm() {
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "Date & Time")
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Add new request")
        form.addFormSection(section)
        
        // Title
        row = XLFormRowDescriptor(tag: "title", rowType: XLFormRowDescriptorTypeText)
        row.cellConfigAtConfigure["textField.placeholder"] = "Title"
        row.required = true
        section.addFormRow(row)
        
        // Location
        row = XLFormRowDescriptor(tag: "location", rowType: XLFormRowDescriptorTypeText)
        row.cellConfigAtConfigure["textField.placeholder"] = "Location"
        row.required = true
        section.addFormRow(row)
        
        // Date From
        row = XLFormRowDescriptor(tag: "toDate", rowType: XLFormRowDescriptorTypeDateTimeInline, title:"From Date & Time")
        row.value = NSDate()
        row.required = true // Dates will always have a value (by default `now`)
        section.addFormRow(row)
        
        // Date To
        row = XLFormRowDescriptor(tag: "fromDate", rowType: XLFormRowDescriptorTypeDateTimeInline, title:"To Date & Time")
        row.value = NSDate(timeIntervalSinceNow: 60*60*24)
        row.required = true
        section.addFormRow(row)
        
        // Notes
        row = XLFormRowDescriptor(tag: "notes", rowType:XLFormRowDescriptorTypeTextView)
        row.cellConfigAtConfigure["textView.placeholder"] = "Notes"
        section.addFormRow(row)

        self.form = form
    }
    
    
    // MARK: - XLFormDescriptorDelegate
    
    override func formRowDescriptorValueHasChanged(formRow: XLFormRowDescriptor!, oldValue: AnyObject!, newValue: AnyObject!) {
        super.formRowDescriptorValueHasChanged(formRow, oldValue: oldValue, newValue: newValue)
        if formRow.tag ==  Tags.DatePicker.rawValue {
            let alertView = UIAlertView(title: "DatePicker", message: "Value Has changed!", delegate: self, cancelButtonTitle: "OK")
            alertView.show()
        }
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
