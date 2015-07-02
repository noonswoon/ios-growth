//
//  RetryViewController.swift
//  WhyDoPeopleLikeYou
//
//  Created by KHUN NINE on 7/2/15.
//  Copyright (c) 2015 KHUN NINE. All rights reserved.
//

import Foundation
import UIKit

class RetryViewController: UIViewController {
    
    var backgroundImageView: UIImageView!
    
    override func viewDidLoad() {
        
        setBackgroundImageView()
        setRetryButton()
    }
}


// MARK: Set view elements

extension RetryViewController {
    
    // Set the background image view (green screen)
    
    func setBackgroundImageView () {
        
        backgroundImageView = UIImageView(image: UIImage(named: "retry"))
        backgroundImageView.frame = view.frame
        backgroundImageView.contentMode = .ScaleAspectFill
        
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
    }
    
    func setRetryButton () {
        
        var retryButton = UIButton(frame: CGRectMake(0, 0, self.view.frame.width - 16, 44))
        retryButton.setTitle("เล่นอีกครั้ง", forState: .Normal)
        retryButton.setTitleColor( UIColor.blackColor(), forState: .Normal)
        retryButton.setTitleColor( UIColor.grayColor(), forState: .Highlighted)
        retryButton.center.x = self.view.center.x
        retryButton.center.y = self.view.frame.height * 2/3
        retryButton.backgroundColor = UIColor.whiteColor()
        retryButton.layer.cornerRadius = 6
        retryButton.layer.borderColor = UIColor.blackColor().CGColor
        retryButton.layer.borderWidth = 1
        retryButton.addTarget(self, action: "retryAgain", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        view.addSubview(retryButton)
    }
    
    func retryAgain () {
        
        var myAppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var rootViewController = myAppDelegate.window?.rootViewController!
        rootViewController?.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
        rootViewController!.dismissViewControllerAnimated(true, completion: nil)
    }
}


extension RetryViewController {
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}