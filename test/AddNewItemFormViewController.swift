//
//  AddNewItemFormViewController.swift
//  test
//
//  Created by Johan K. Jensen on 05/09/2015.
//  Copyright (c) 2015 adarsh bhatt. All rights reserved.
//

import UIKit

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
        
        let doneBarButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: "done:")
        self.navigationItem.rightBarButtonItem = doneBarButton
        
        initializeForm()
        // Do any additional setup after loading the view.
    }
    
    func cancel(sender: AnyObject?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func done(sender: AnyObject?) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
        
        // Date From
        row = XLFormRowDescriptor(tag: Tags.DateInline.rawValue, rowType: XLFormRowDescriptorTypeDateTimeInline, title:"From Date & Time")
        row.value = NSDate()
        section.addFormRow(row)
        
        // Date To
        row = XLFormRowDescriptor(tag: Tags.DateInline.rawValue, rowType: XLFormRowDescriptorTypeDateTimeInline, title:"To Date & Time")
        row.value = NSDate()
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
        if  formRow.tag ==  Tags.DatePicker.rawValue {
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
