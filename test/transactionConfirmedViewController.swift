//
//  transactionConfirmedViewController.swift
//  test
//
//  Created by Rajat Bhageria on 9/5/15.
//  Copyright (c) 2015 adarsh bhatt. All rights reserved.
//


import Foundation
import UIKit
import Parse

class transactionConfirmedViewController: UIViewController {
    
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    @IBAction func confirmButtonPressed(sender: AnyObject) {
        var currentUser = PFUser.currentUser()!
        var accountId = currentUser.objectId!
        
        TransferRequest(block: {(builder:TransferRequestBuilder) in
            builder.requestType = HTTPType.POST
            builder.amount = 10
            builder.transferMedium = TransactionMedium.BALANCE
            builder.description = "test"
            builder.payeeId = "55e94a1af8d877051ab4f6c1"
            
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
}