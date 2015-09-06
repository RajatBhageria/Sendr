//
//  PaymentsView.swift
//  test
//
//  Created by Rajat Bhageria on 9/5/15.
//  Copyright (c) 2015 adarsh bhatt. All rights reserved.
//

import Foundation
import UIKit
import Parse

class PaymentsView: UIViewController {
    @IBOutlet weak var cardNumberTextView: NSLayoutConstraint!
    
    @IBOutlet weak var ExpDateTextView: UILabel!
    var accountId = "";
    override func viewDidLoad(){
        super.viewDidLoad()
        accountId = PFUser.currentUser()!.objectId!
        let client = NSEClient.sharedInstance
        
        client.setKey("57800de7eaf96cd51e205923a8be6db4")
        
        var accountPostRequest = AccountRequest(block: {(builder:AccountRequestBuilder) in
            builder.requestType = HTTPType.POST
            builder.accountType = AccountType.CHECKING
            builder.balance = 0
            builder.customerId = self.accountId
        })
        
        accountPostRequest?.send({(result:AccountResult) in
            //Should not be any result, should NSLog a message in console saying it was successful
        })

        var getOneRequest = AccountRequest(block: {(builder) in
            builder.requestType = HTTPType.GET
        })
        
        getOneRequest?.send({(result) in
            var account = result.getAccount()
            print("Account fetched:\(account?.nickname)\n")
        })
    }
}