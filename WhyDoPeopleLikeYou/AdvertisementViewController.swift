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

class AdvertismentController: NSObject {
    
    static var enableAds: Bool = false
    
    // MARK: Alert View container
    
    static var containerView: UIView!
    static var alertView: CustomAlertView!
    
    
    // Set the advertisments, it should has a few delays before showing up
    
    class func showAds (timeDelay: Double) {
        
        let delay = timeDelay * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.launchAlertView()
        }
        
    }
    
    class private func launchAlertView() {
        
        var buttons = ["Cancel"]
        
        alertView = CustomAlertView()
        
        alertView.buttonTitles = buttons
        alertView.containerView = createAds()
        alertView.onButtonTouchUpInside = { (alertView: CustomAlertView, buttonIndex: Int) -> Void in
            println("CLOSURE: Button '\(buttons[buttonIndex])' touched")
            alertView.close()
        }
        
        alertView.show()
    }
    
    class private func createAds () -> UIView {
        
        let width:  CGFloat = 290
        let height: CGFloat = 290
        
        containerView = UIView(frame: CGRectMake(0, 0, width, height))
        
        let adsString = "NoonswoonAds"
        let image = UIImage(named: adsString)!
        
        var button = UIButton(frame: CGRectMake(0, 0, width, height))
        button.setImage(image, forState: UIControlState.Normal)
        button.setImage(image, forState: UIControlState.Highlighted )
        button.addTarget(self, action: "adsClicked", forControlEvents: UIControlEvents.TouchUpInside)
        
        containerView.addSubview( button )
        
        return containerView
    }
    
    func adsClicked () {
        AdvertismentController.adsClicked()
    }
    
    class func adsClicked () {
        
        UserLogged.adsClicked()
        
        let itunesLink: NSURL = NSURL(string: "itms-apps://itunes.apple.com/th/app/noonswoon-top-dating-app-to/id605218289?mt=8")!
        UIApplication.sharedApplication().openURL(itunesLink)
        
        alertView.close()
    }
    
}
