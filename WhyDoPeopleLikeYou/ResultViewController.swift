//
//  ResultViewController.swift
//  WhyDoPeopleLikeYou
//
//  Created by KHUN NINE on 6/30/15.
//  Copyright (c) 2015 KHUN NINE. All rights reserved.
//

import Foundation
import UIKit
import Parse

class ResultViewController: UIViewController {
    
    var backgroundImageView: UIImageView!
    
    let margin: CGFloat = 8
    let elementHeight: CGFloat = 44
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.mainColor()
        setContentBackgroundImageView()
        setContentBackgroundTemplate() // Temporary use
        
        setUserDisplayPhoto()
        setResultImage()
        setUserFirstName()
        
        println("Summation: \(DataController.summation)")
    }
    
    override func viewDidAppear(animated: Bool) {
        saveResult()
    }
}


extension ResultViewController {
    func setShareButtonWith (#contentURLImage: String){
        
        // Set the content of ShareLinkContent
        
        let contentURL = "https://noonswoonapp.com"
        let default_contentURLImage = "http://blog.noonswoonapp.com/wp-content/uploads/2015/06/b04.jpg"
        let contentTitle = "Noonswoon, give yourself a change"
        let contentDescription = "Noonswoon introduces you to one NEW person every day at noon.You have 24 hours to decide whether you like your match.If both of you LIKE each other, the app will CONNECT you and you can CHAT privately"
        
        let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
        content.imageURL = NSURL(string: contentURLImage)
        content.contentURL = NSURL(string: contentURL)
        content.contentTitle = contentTitle
        content.contentDescription = contentDescription
        
        var shareButton = FBSDKShareButton()
        shareButton.shareContent = content
        shareButton.frame = CGRectMake(8, 0, self.view.frame.width - 16, elementHeight)
        shareButton.center.x = CGRectGetMidX( self.view.frame )
        
        // The y position should be animated
        shareButton.center.y = CGRectGetMaxY( self.view.frame ) + elementHeight/2 + self.margin
        
        shareButton.addTarget(self, action: "shareButtonClicked", forControlEvents: UIControlEvents.TouchUpInside)
        shareButton.layer.cornerRadius = 6
        shareButton.layer.masksToBounds = true
        
        
        // Add button into subview
        
        if (shareButton.superview == nil) {
            
            self.view.addSubview(shareButton)
        }
        
        
        // Show up animation
        
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
                shareButton.center.y = CGRectGetMaxY( self.view.frame ) - self.elementHeight/2 - self.margin
            
            }, completion: nil)
    }
    
    func shareButtonClicked () {

        // Log user activities
        UserLogged.shareButtonClicked()
        
        // Enable the advertisment alert
        AdvertismentController.enableAds = true
    }
}


extension ResultViewController {
    
    func saveResult () {
        
        let objectFile = PFObject(className: "UserGeneratedResult")
        let snapshotImage = takeScreenShot()
        let imageData: NSData = UIImagePNGRepresentation( snapshotImage )
        
        SwiftSpinner.showWithDelay(2.0, title: "It's taking longer than expected")
        SwiftSpinner.show("Processing \n0%")
        
        
        var newImageFile = PFFile(name: "UserGeneratedResult.png", data: imageData)
        newImageFile.saveInBackgroundWithBlock({
            (succeeded: Bool, error: NSError?) -> Void in
            if (error == nil){
                
                
                SwiftSpinner.hide()
                
                println(newImageFile.url)
                self.setShareButtonWith(contentURLImage: newImageFile.url!)
                
            }
            }, progressBlock: {
                (percentDone: Int32) -> Void in
                println("percentDone: \(percentDone)")
                
                SwiftSpinner.show("Processing \n\(percentDone-2)%")
                
        })
        
        objectFile["userID"] = "justUserID"
        objectFile["imageFile"] = newImageFile
        
        objectFile.saveInBackground()
    }
    
    func takeScreenShot () -> UIImage {
        
        // Make snapshot area, then shanp it to image
        
        let snapshotArea = self.view.frame.size
        UIGraphicsBeginImageContext( snapshotArea )
        
        self.view.layer.renderInContext(UIGraphicsGetCurrentContext())
        
        var screenShortImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        // Cropping the image, cut out the area outside result
        
        let cropingArea = self.backgroundImageView.frame
        var croppingImg:CGImageRef = screenShortImage.CGImage
        croppingImg = CGImageCreateWithImageInRect(croppingImg, cropingArea)
        
        
        // Optional: save the image to album
        
        let resultImage = UIImage(CGImage: croppingImg)
        // saveImageToAlbum( resultImage! )
        
        return resultImage!
    }
    
    
    func saveImageToAlbum (image: UIImage) {
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }

}


extension ResultViewController {
    
    func setUserFirstName () {
        let userFirstNameLabel = UILabel(frame: CGRectMake(0, 0, self.view.frame.width, 80))
        userFirstNameLabel.text = DataController.userFirstNameText
        userFirstNameLabel.textAlignment = NSTextAlignment.Center
        userFirstNameLabel.backgroundColor = UIColor.lightGrayColor()
        userFirstNameLabel.sizeToFit()
        userFirstNameLabel.center.x = self.view.center.x
        userFirstNameLabel.center.y = self.view.frame.height * 0.38

        
        self.view.addSubview( userFirstNameLabel )
    }

    func setUserDisplayPhoto () {
        
        var imageString = "ResultPictures/1.png"
        var image = UIImage(named: imageString)
        var imageView = UIImageView(image: DataController.userProfileImage)
        
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        imageView.center.x = self.view.frame.width * 2/5
        imageView.center.y = self.view.frame.height * 1/5 - 10
        imageView.layer.cornerRadius = imageView.frame.width/2
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor(red: 64/255, green: 34/255, blue: 0/255, alpha: 1).CGColor
        imageView.clipsToBounds = true
        
        self.view.addSubview(imageView)
    }
    
    func setResultImage () {

        var imageString = "ResultPictures/1.png"
        var image = UIImage(named: imageString)
        var imageView = UIImageView(image: image)
        
        imageView.frame = CGRect(x: 0, y: 0, width: 125, height: 125)
        imageView.center.x = self.view.frame.width * 5/7
        imageView.center.y = self.view.frame.height * 5/7
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor(red: 64/255, green: 34/255, blue: 0/255, alpha: 1).CGColor
        
        self.view.addSubview(imageView)
    }
    
    func setContentBackgroundTemplate () {
        
        let margin: CGFloat = self.margin * 2
        let statusBarHeight: CGFloat = 20
        let topMargin: CGFloat = statusBarHeight + margin
        
        var imageString = "tempContentBackground"
        var image = UIImage(named: imageString)
        
        backgroundImageView = UIImageView(image: image)
        backgroundImageView.frame = CGRect(x: margin, y: topMargin, width: self.view.frame.width - margin * 2, height: self.view.frame.height - ( margin * 2 + topMargin) - elementHeight)
        
        self.view.addSubview(backgroundImageView)
    }
    
    func setContentBackgroundImageView () {

        // defind the top margin
        
        let statusBarHeight: CGFloat = 20
        let topMargin: CGFloat = statusBarHeight + margin
        
        // Create a shape
        
        var contentBackgroundImageShape = CAShapeLayer()
        contentBackgroundImageShape.frame = CGRect(x: margin, y: topMargin, width: self.view.frame.width - margin * 2, height: self.view.frame.height - ( margin * 2 + topMargin) - elementHeight)
        contentBackgroundImageShape.path = UIBezierPath(roundedRect: contentBackgroundImageShape.bounds, cornerRadius: 6).CGPath
        contentBackgroundImageShape.fillColor = UIColor(white: 1, alpha: 1).CGColor
        contentBackgroundImageShape.strokeColor = UIColor.grayColor().CGColor
        contentBackgroundImageShape.lineWidth = 0.3;
        
        self.view.layer.addSublayer( contentBackgroundImageShape )
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}