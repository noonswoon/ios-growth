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
    
    class func saveUserInformation (id: String, firstname: String, lastname: String, email: String, birthday: String) {
        
        
        
        logObject["userId"]       = id
        logObject["first_name"]   = firstname
        logObject["last_name"]    = lastname
        logObject["email"]        = email
        logObject["birthday"]     = birthday
        
        println(id)
        println(firstname)
        println(lastname)
        println(email)
        println(birthday)
        
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