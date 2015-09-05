//
//  SignUpViewController.swift
//  test
//
//  Created by adarsh bhatt on 8/6/15.
//  Copyright (c) 2015 adarsh bhatt. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {

    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Password: UITextField!
    
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0,150,150)) as
    UIActivityIndicatorView
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.actInd.center = self.view.center
        
        self.actInd.hidesWhenStopped = true
        self.actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(self.actInd)
        
        
        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    //Sign Up
    @IBAction func signUpAction(sender: AnyObject) {
        
        var username = self.Username.text
        var password = self.Password.text
        var email = self.Email.text
        
        if(count(username.utf16) < 4 || count(password.utf16) < 5) {
            
            var alert = UIAlertView(title: "Invalid", message: "Username must be grater than 4 and Password must be greater than 5.", delegate: self, cancelButtonTitle: "OK?")
            alert.show()
        } else if (count(email.utf16) < 8) {
            var alert = UIAlertView(title: "Invalid", message: "Enter Valid email", delegate: self, cancelButtonTitle: "OK?")
            alert.show()
        } else {
            
            self.actInd.startAnimating()
            
            var newUser = PFUser()
            
            newUser.username = username
            newUser.password = password
            newUser.email = email
            
            
            
            newUser.signUpInBackgroundWithBlock({ (succeed, error) -> Void in
                
                
                self.actInd.stopAnimating()
                
                if((error) != nil) {
                    var alert = UIAlertView(title: "Error", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
                    alert.show()

                } else {
                    var alert = UIAlertView(title: "Success", message: "Signed Up", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                }
        
            })
        }
}
}