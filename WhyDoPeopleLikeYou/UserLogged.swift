//
//  UserLogged.swift
//  WhyDoPeopleLikeYou
//
//  Created by KHUN NINE on 7/1/15.
//  Copyright (c) 2015 KHUN NINE. All rights reserved.
//

import Foundation
import Parse

class UserLogged: NSObject {
    
    // MARK: Parse user logged object
    
    static var logObject: PFObject!
    
    class func setLogObject () {
        logObject = PFObject(className: "UserLogged")
    }
    
    class func saveUserInformation () {
        
        for key in DataController.userInfo.keys {
            logObject[key] = DataController.userInfo[key]
            println(DataController.userInfo[key])
        }
        
        logObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            println("Object has been saved.")
        }
    }
    
    class func shareButtonClicked () {
        
        logObject["clickedShare"] = true
        logObject.saveInBackground()
        
    }
    
    class func adsClicked () {
        
        logObject["clickedAds"] = true
        logObject.saveInBackground()
    }
    
}