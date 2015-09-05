//
//  ViewController.swift
//  test
//
//  Created by adarsh bhatt on 8/2/15.
//  Copyright (c) 2015 adarsh bhatt. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    
    var loginViewController: PFLogInViewController! = PFLogInViewController()
    var signUpViewController: PFSignUpViewController! = PFSignUpViewController()
    
    @IBOutlet weak var myLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let testObject = PFObject(className: "TestObject")
        testObject["foo"] = "bar"
        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            print("Object has been saved.")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if(PFUser.currentUser() == nil) {
            self.loginViewController.fields = PFLogInFields.Default //PFLoginFields(PFLogInFieldsUsernameAndPassword.value | PFLogInFieldsLogInButton.value | PFLogInFieldsSignUpButton.value | PFLogInFieldsPasswordForgotten.value | PFLogInFieldsDismissButton.value)
            
            var logInLogoTitle = UILabel()
            logInLogoTitle.text = "Test Login"
            
            self.loginViewController.logInView!.logo = logInLogoTitle
            self.loginViewController.delegate = self
            
            var signUpLogoTitle = UILabel()
            logInLogoTitle.text = "Test Sign Up"
            
            
            self.signUpViewController.signUpView!.logo = signUpLogoTitle
            self.signUpViewController.delegate = self
            self.loginViewController.signUpController = self.signUpViewController


        }
    }
    
    
    //Parse Login
     func logInViewController(logInController: PFLogInViewController!, shouldBeginLogInWithUsername username: String!, password: String!) -> Bool {
        if (!username.isEmpty || !password.isEmpty) {
            return true
        } else {
            return false
        }
    }
    
    func logInViewController(logInController: PFLogInViewController!, didLogInUser user: PFUser!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func logInViewController(logInController: PFLogInViewController!, didFailToLogInWithError error: NSError!) {
        print("failed to login")
    }
    
    //Parse Sign Up
    
    func signUpViewController(signUpController: PFSignUpViewController!, didSignUpUser user: PFUser!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController!, didFailToSignUpWithError error: NSError!) {
        print("user failed to sign up")
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController!) {
        print("user dismissed sign up")
    }
    
    //Actions
    
    @IBAction func simpleAction(sender: AnyObject) {
        self.presentViewController(self.loginViewController, animated: true, completion: nil)
    }

    @IBAction func customAction(sender: AnyObject) {
        self.performSegueWithIdentifier("Custom", sender: self)
    }
    
    @IBAction func logoutAction(sender: AnyObject) {
        PFUser.logOut()
    }
    
    
}

