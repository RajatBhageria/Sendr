//
//  CustomLoginViewController.swift
//  test
//
//  Created by adarsh bhatt on 8/6/15.
//  Copyright (c) 2015 adarsh bhatt. All rights reserved.
//

import UIKit
import Parse



class CustomLoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0,150,150))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.actInd.center = self.view.center
        
        self.actInd.hidesWhenStopped = true
        self.actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(self.actInd)
        
        usernameField.becomeFirstResponder()
        
        usernameField.delegate = self
        passwordField.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == usernameField {
            passwordField.becomeFirstResponder()
            return true
        }
        if count(usernameField.text) > 0 && count(passwordField.text) > 0 {
            loginAction(self)
            return true
        }
        return false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //Actions
    
    @IBAction func loginAction(sender: AnyObject) {
        
        var username = self.usernameField.text
        var password = self.passwordField.text
        
            self.actInd.startAnimating()
            
            PFUser.logInWithUsernameInBackground(username, password: password, block: { (user, error) ->
                Void in
                
                self.actInd.stopAnimating()
                
                if (user != nil) {
                    var alert = UIAlertView(title: "Success", message: "Logged In", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
//                    self.performSegueWithIdentifier("HomePage", sender: self)
                    self.dismissViewControllerAnimated(true, completion: { () -> Void in
                        
                    })
                } else {
                    var alert = UIAlertView(title: "Error", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
                    alert.show()

                }
            })
    }
    
    @IBAction func signUpAction(sender: AnyObject) {
        self.performSegueWithIdentifier("signUp", sender: self)
    }

}
