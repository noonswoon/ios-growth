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
}

// MARK: - Setter methods
extension AdvertismentController {
    
    class func setDelegate () {
        AdBuddiz.setDelegate(AdvertismentController.self())
    }
    
    class func enebleAds () {
        eneabledAds = true
    }
    
    class func disableAds () {
        eneabledAds = false
    }
}

// MARK: - AdBuddiz Delegate
extension AdvertismentController {
    
    func didHideAd() {
        println("didHideAd !!!!!!!!!!!")
    }
    
    func didShowAd() {
        AdvertismentController.disableAds()
    }
    
    func didClick() {
        UserLogged.adsClicked()
        trackEvent()
    }
}

// MARK: - Google Analytic track event
extension AdvertismentController {
    func trackEvent () {
        
        var tracker = GAI.sharedInstance().defaultTracker
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("UserAction", action: "User clicked try again",
            label: nil,
            value: nil).build()  as [NSObject : AnyObject])
    }
}
