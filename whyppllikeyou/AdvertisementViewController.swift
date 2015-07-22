//
//  AdvertisementViewController.swift
//  WhyDoPeopleLikeYou
//
//  Created by KHUN NINE on 6/24/15.
//  Copyright (c) 2015 KHUN NINE. All rights reserved.
//

import Foundation
import Parse

// MARK: Advertisment
class AdvertismentController: NSObject, AdBuddizDelegate{
    
    static var eneabledAds: Bool = false
    static var userClickedShareButton: Bool = true
    
    // Show the advertisments, it should has a few delays before showing up
    class func showAds (timeDelay: Double) {
        
        if (AdBuddiz.isReadyToShowAd() == false) {
            return
        }
        
        setDelegate ()
        
        let delay = timeDelay * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            AdBuddiz.showAd()
        }
    }
    
    class func isEnabled () -> Bool {
        return eneabledAds
    }
    
    class func isUserClickShareButton () -> Bool {
        return userClickedShareButton
    }
}

// MARK: - Setter methods
extension AdvertismentController {
    
    class func setDelegate () {
        AdBuddiz.setDelegate(AdvertismentController.self())
    }
    
    class func enebleAds () {
        self.eneabledAds = true
    }
    
    class func disableAds () {
        self.eneabledAds = false
    }
    
    class func setUserClickedShare (flag: Bool) {
        self.userClickedShareButton = flag
    }
}

// MARK: - AdBuddiz Delegate
extension AdvertismentController {
    
    func didHideAd() {
        println("didHideAd !!!!!!!!!!!")
    }
    
    func didShowAd() {
        // Disable ads after it shows
        AdvertismentController.disableAds()
    }
    
    func didClick() {
        UserLogged.adsClicked()
        UserLogged.trackEvent("User clicked ads")
    }
}
