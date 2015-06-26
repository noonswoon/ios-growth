//
//  AdvertisementViewController.swift
//  WhyDoPeopleLikeYou
//
//  Created by KHUN NINE on 6/24/15.
//  Copyright (c) 2015 KHUN NINE. All rights reserved.
//

import Foundation
import Parse

class AdvertisementViewController: UIViewController {
    
    var backgroundImageView: UIImageView!
    var noonswoonAds: UIImageView!
    var contentBackgroundImageShape: CAShapeLayer!
    var dismissButton: UIButton!
    
    let margin: CGFloat = 8
    let btnHeight: CGFloat = 44
    
    var logObject: PFObject!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        if (backgroundImageView == nil) {
            
            backgroundImageView = UIImageView(image: UIImage(named: "main_background.png"))
            backgroundImageView.frame = view.frame
            backgroundImageView.contentMode = .ScaleAspectFill
            
            view.addSubview(backgroundImageView)
            view.sendSubviewToBack(backgroundImageView)
        }
        
        if (contentBackgroundImageShape == nil) {
            
            let elementWidth:    CGFloat = CGRectGetMaxX( self.view.frame ) - margin * 2
            let statusBarHeight: CGFloat = 20
            let topMargin:       CGFloat = statusBarHeight + margin
            
            contentBackgroundImageShape = CAShapeLayer()
            contentBackgroundImageShape.frame = CGRect(x: margin, y: topMargin, width: elementWidth, height: self.view.frame.height - ( margin * 2 + topMargin) - btnHeight)
            contentBackgroundImageShape.path = UIBezierPath(roundedRect: contentBackgroundImageShape.bounds, cornerRadius: 6).CGPath
            contentBackgroundImageShape.fillColor = UIColor(white: 1, alpha: 1).CGColor
            contentBackgroundImageShape.strokeColor = UIColor.grayColor().CGColor
            contentBackgroundImageShape.lineWidth = 0.3;
            
            self.backgroundImageView.layer.addSublayer( contentBackgroundImageShape )
        }
        
        if (noonswoonAds == nil) {
            
            let adsString = "NoonswoonAds"
            let image = UIImage(named: adsString)!
            
            let width = image.size.width * 0.4
            let height = image.size.height * 0.4
            
            noonswoonAds = UIImageView(image: image)
            noonswoonAds.frame = CGRectMake(0, 0, width, height)
            noonswoonAds.center = contentBackgroundImageShape.position
            
            self.view.addSubview( noonswoonAds )
            
        }
        
        if (dismissButton == nil) {
            
            let buttonWidth = CGRectGetMaxX( self.view.frame ) - margin * 2
            let yPosition   = CGRectGetMaxY( self.view.frame ) - btnHeight - margin
            
            dismissButton = UIButton(frame: CGRectMake(margin, yPosition, buttonWidth, btnHeight))
            dismissButton.setTitle("Back", forState: .Normal)
            dismissButton.addTarget(self, action: "dismissButtonClicked", forControlEvents: UIControlEvents.TouchUpInside)
            dismissButton.layer.cornerRadius = 6
            dismissButton.layer.masksToBounds = true
            dismissButton.backgroundColor = UIColor(red:0.365, green:0.612, blue:0.925, alpha:1)
            
            self.view.addSubview( dismissButton )
        }
    }
    
    func dismissButtonClicked () {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        var touch = touches.first as! UITouch
        var point = touch.locationInView( self.view )
        
        if (CGRectContainsPoint( contentBackgroundImageShape.bounds, point)) {
            
            logObject["clickedAds"] = true
            logObject.saveInBackground()
            
            let itunesLink: NSURL = NSURL(string: "itms-apps://itunes.apple.com/th/app/noonswoon-top-dating-app-to/id605218289?mt=8")!
            UIApplication.sharedApplication().openURL(itunesLink)
        }
        
        super.touchesBegan(touches , withEvent:event)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}