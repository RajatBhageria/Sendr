//
//  NSEClient.swift
//  Nessie-iOS-Wrapper
//
//  Created by Mecklenburg, William on 4/3/15.
//  Copyright (c) 2015 Nessie. All rights reserved.
//

import Foundation

public enum HTTPType : String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}
internal let baseString = "http://api.reimaginebanking.com"
internal var dateFormatter = NSDateFormatter()

public class NSEClient {
    
    public class var sharedInstance: NSEClient {
        struct Static {
            static var instance: NSEClient?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = NSEClient()
        }
        
        return Static.instance!
    }
    
    private var key = "57800de7eaf96cd51e205923a8be6db4"
    public func getKey() -> String {
        if key == "57800de7eaf96cd51e205923a8be6db4" {
            NSLog("Attempting to get unset key. Don't forget to set the key before sending requests!")
        }
        return key;
    }
    public func setKey(key:String) {
        self.key = key
    }
    private init() {
        dateFormatter.dateFormat = "yyyy-MM-dd"
    }
}