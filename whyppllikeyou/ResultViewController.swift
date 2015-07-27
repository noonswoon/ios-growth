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


// MARK: - Main methos for sharing contents
extension ResultViewController {
    
    // Set contents to share
    func setContentToShare (#contentURLImage: String) {
        
        let contentURL = "http://bit.ly/whyppllike"
        let default_contentURLImage = "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c2/F_icon.svg/2000px-F_icon.svg.png"
        let contentTitle = "เหตุผลที่ทำไมคนถึงชอบคุณ"
        let contentDescription = "คุณเคยคิดหรือไม่ ว่าทำไมคนถึงชอบคุณ อะไรเป็นสาเหตุกันแน่นะ? ดาวน์โหลด 'ชอบฉันไม' สิ ด้วยอัลกอรึทึมขั้นสูงของเรา ที่วิเคราะห์จากการกดไลค์และการตอบคำถามของคุณ จะทำให้คุณรู้คำตอบที่น่าทึ่ง!"
        
        let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
        content.imageURL = NSURL(string: contentURLImage)
        content.contentURL = NSURL(string: contentURL)
        content.contentTitle = contentTitle
        content.contentDescription = contentDescription
        
        shareButton.shareContent = content
    }

    // Draw UIImage for sharing
    func drawUIImageResult () -> UIImage {
        
        // Create at rectangle size
        let rectSize: CGSize = CGSizeMake(470, 246)
        
        // Create a result and display images size
        let resultSize: CGSize = CGSizeMake( rectSize.height-50, rectSize.height-50 )
        let displaySize: CGSize = CGSizeMake(130, 130)
        
        // Because it is an UIImage, we cannot use alpha method, we have to use image outside
        var background: UIImage = UIImage(named: "backgroundColor")!
        var waterMarkBG: UIImage = UIImage(named: "waterMarkBG")!
        var result: UIImage = rectImageWithBorder( UIImage(named: "\(DataController.summation)")! )
        
        // There are some problems I cannot solve when the user display image is not squre
        // I just fix that by snap the image from ResultViewController
        var display: UIImage = snapingUserDisplayPhotoView()
        
        // Make image border and circle radius
        display = roundedRectImageFromImage(display)
        result  = rectImageWithBorder(result)
        
        UIGraphicsBeginImageContext(rectSize);
        
        // Draw those image to recatangle
        background.drawInRect(CGRectMake(0, 0, rectSize.width, rectSize.height))
        waterMarkBG.drawInRect(CGRectMake(0, rectSize.height-18, rectSize.width, 18))
        result.drawInRect(CGRectMake(rectSize.width-resultSize.width-25, rectSize.height-resultSize.height-25, resultSize.width, resultSize.height))
        // display.drawAtPoint( CGPointMake(rectSize.width/4 - displaySize.width/2, rectSize.height/2 - displaySize.height/1.7 - 5) )
        display.drawInRect(CGRectMake(rectSize.width/4 - displaySize.width/2, rectSize.height/2 - displaySize.height/1.7 - 5, displaySize.width, displaySize.height))
        
        // finalImage in the image after we draw every images
        var finalImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext();
        
        // Drawing text into image
        
        let textTitle  = "เหตุผลว่าทำไมคนถึงชอบคุณ"
        let textName   = DataController.userFirstNameText
        let codeName   = DataController.getCodeName()
        let isThatYou  = "แล้วนี่ใช่คุณหรือเปล่า"
        let textResult = DataController.getDescription()
        let waterMark  = "คลิกที่นี่ เพื่อดาวน์โหลดแอพและหาเหตุผลของคุณ"
        
        finalImage = setText(textTitle, fontSize: 18, inImage: finalImage, atPoint: CGPoint(x:rectSize.width/4,         y:10))
        finalImage = setText(textName,  fontSize: 18, inImage: finalImage, atPoint: CGPoint(x:rectSize.width/4,         y:175))
        finalImage = setText(codeName,  fontSize: 18, inImage: finalImage, atPoint: CGPoint(x:rectSize.width/4,         y:195))
        finalImage = setText(isThatYou, fontSize: 18, inImage: finalImage, atPoint: CGPoint(x:rectSize.width*3/4,       y:1))
        finalImage = setText(textResult,fontSize: 20, inImage: finalImage, atPoint: CGPoint(x:rectSize.width*3/4-10,    y:185))
        finalImage = setText(waterMark, fontSize: 18, inImage: finalImage, atPoint: CGPoint(x:rectSize.width/2,         y:rectSize.height - 24))
        
        // Save image into album, use this method if you don't want to check it on Parse or Facebook
        // saveImageToAlbum( finalImage )
        
        return finalImage
    }
}

// MARK: - Variables
class ResultViewController: UIViewController {
    
    var shareButton: FBSDKShareButton!

    // Loading indicator for upload result image to Parse
    var spinner: UIActivityIndicatorView!
    
    var contentBackgroundImageShape: CAShapeLayer!
    var backgroundImageView: UIImageView!
    
    let margin: CGFloat = 8
    let elementHeight: CGFloat = 44

    var resultImageView: UIImageView!
    var resultImageForShare: UIImage!
    var userDisplayPhotoView: UIImageView!

    // MARK: - View lief cycle
    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor.clearColor()
        
        setBackground()
        setUserDisplayPhoto()
        setResultImage( DataController.summation )
        setSpinner()
        setLabels()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if ( !AdvertismentController.isEnabled() ) {
            
            // Show the buttons up by animation
            self.setShareButton()
            self.setRetryButton()
            
            // Take a sanpshot
            self.saveResult()
            
            // Set the varible for sharing ads
            AdvertismentController.setUserClickedShare(false)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        UserLogged.trackScreen("Result view")
    }

    // MARK: - Set Facebook share button
    func setShareButton () {
        
        shareButton = FBSDKShareButton()
        shareButton.titleLabel?.text = "test"
        shareButton.frame = CGRectMake(self.view.frame.width/2 + 4, 0, self.view.frame.width/2 - 12, elementHeight)
        shareButton.enabled = false
        // The y position should be animated 
        shareButton.center.y = CGRectGetMaxY( self.view.frame ) + elementHeight/2 + self.margin
        shareButton.addTarget(self, action: "shareButtonClicked", forControlEvents: UIControlEvents.TouchUpInside)
        shareButton.layer.cornerRadius = 6
        shareButton.layer.masksToBounds = true
        
        // Add button into subview
        if (shareButton.superview == nil) {
            self.view.addSubview(shareButton)
        }
        
        // Show button up with animation
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            self.shareButton.center.y = CGRectGetMaxY( self.view.frame ) - self.elementHeight/2 - self.margin
            self.spinner.startAnimating()
            
            }, completion: nil)
    }
    
    func shareButtonClicked () {
        
        // Log user activities
        UserLogged.shareButtonClicked()
        UserLogged.trackEvent("User clicked share button")
        
        // Enable the advertisment alert
        AdvertismentController.enebleAds()
        AdvertismentController.setUserClickedShare(true)
    }

    // MARK: - Set retry button
    func setRetryButton () {
        
        var retryButton = UIButton(frame: CGRectMake(8, 0, self.view.frame.width/2 - 12, elementHeight))
        retryButton.setTitle("เล่นใหม่", forState: .Normal)
        retryButton.titleLabel?.font = UIFont(name: "SukhumvitSet-Medium", size: 18)
        retryButton.enabled = true
        // The y position should be animated
        retryButton.center.y = CGRectGetMaxY( self.view.frame ) + elementHeight/2 + self.margin
        retryButton.addTarget(self, action: "retryButtonClicked", forControlEvents: UIControlEvents.TouchUpInside)
        retryButton.backgroundColor = UIColor.appGreenColor()
        retryButton.layer.cornerRadius = 6
        retryButton.layer.masksToBounds = true
        
        // Add button into subview
        self.view.addSubview(retryButton)
        
        // Show up animation
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            retryButton.center.y = CGRectGetMaxY( self.view.frame ) - self.elementHeight/2 - self.margin
            
            }, completion: nil)
    }
    
    func retryButtonClicked () {
    
        // Post a notification to Retry
        NSNotificationCenter.defaultCenter().postNotificationName("RetryButtonClicked", object: nil)
        
        // Track user event
        UserLogged.trackEvent("User clicked retry button")
    }
}

// MARK: - Setter methods

extension ResultViewController {
    
    func setBackground () {
        
        var backgroundImageView = UIImageView(image: UIImage(named: "main_background2"))
        backgroundImageView.frame = view.frame
        backgroundImageView.contentMode = .ScaleAspectFill
        
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
    }

    // Loading indicator while uploading an result image (while the Facebook share button is disable)
    func setSpinner () {
        
        spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        spinner.frame = CGRectMake(self.view.frame.width/2 + 4, 0, self.view.frame.width/2 - 12, elementHeight)
        spinner.center.y = CGRectGetMaxY( self.view.frame ) - self.elementHeight/2 - self.margin
        spinner.layer.zPosition = 10
        
        self.view.addSubview(spinner)
    }
    
    // Set the labels and its positions
    func setLabels () {
        
        let title       = "เหตุผลที่ทำไมคนถึงชอบคุณ"
        let firstName   = DataController.userFirstNameText
        let codeName    = "สมญานาม: \(DataController.getCodeName())"
        let isThatYou   = "นี่ใช่คุณหรือเปล่า"
        let description = DataController.getDescription()
        
        let frameHeight = CGRectGetMaxY(self.view.frame)
        
        // Set the position for any screen size
        if (iPhoneScreenSize() == "3.5") {
            
            setLabel(title,         yPosition: frameHeight * 0.085, size: 22)
            setLabel(firstName,     yPosition: frameHeight * 0.41,  size: 18)
            setLabel(codeName,      yPosition: frameHeight * 0.45,  size: 18)
            setLabel(isThatYou,     yPosition: frameHeight * 0.51,  size: 21)
            setLabel(description,   yPosition: frameHeight * 0.83,  size: 18)
        }
        else if (iPhoneScreenSize() == "4") {
            
            setLabel(title,         yPosition: frameHeight * 0.085, size: 23)
            setLabel(firstName,     yPosition: frameHeight * 0.41,  size: 19)
            setLabel(codeName,      yPosition: frameHeight * 0.45,  size: 19)
            setLabel(isThatYou,     yPosition: frameHeight * 0.533, size: 22)
            setLabel(description,   yPosition: frameHeight * 0.81,  size: 18)
        }
        else if (iPhoneScreenSize() == "4.7") {
            
            setLabel(title,         yPosition: frameHeight * 0.085, size: 25)
            setLabel(firstName,     yPosition: frameHeight * 0.41,  size: 19)
            setLabel(codeName,      yPosition: frameHeight * 0.45,  size: 19)
            setLabel(isThatYou,     yPosition: frameHeight * 0.533, size: 24)
            setLabel(description,   yPosition: frameHeight * 0.81,  size: 20)
        }
        else if (iPhoneScreenSize() == "5.5") {
            
            setLabel(title,         yPosition: frameHeight * 0.085, size: 27)
            setLabel(firstName,     yPosition: frameHeight * 0.41,  size: 20)
            setLabel(codeName,      yPosition: frameHeight * 0.45,  size: 20)
            setLabel(isThatYou,     yPosition: frameHeight * 0.533, size: 26)
            setLabel(description,   yPosition: frameHeight * 0.81,  size: 23)
        }
    }
    
    func setLabel (title: String, yPosition: CGFloat, size: CGFloat) {
        
        let label = UILabel(frame: CGRectMake(0, 0, self.view.frame.width, 200))
        label.numberOfLines = 1
        label.font = UIFont(name: "SukhumvitSet-Medium", size: size)
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.whiteColor()
        label.text = title
//        label.sizeToFit()
        label.center.x = self.view.center.x
        label.center.y = yPosition
        
        self.view.addSubview( label )
    }
    
    func setUserDisplayPhoto () {
        
        userDisplayPhotoView = UIImageView(image: DataController.userProfileImage)

        // Because I calculate the y position from the screen width, and iPhone 3.5" has the screen width the same with iPhone 4"
        // So, we have to identify the 3.5" and 4"
        
        if (iPhoneScreenSize() == "3.5") {
            
            userDisplayPhotoView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width/2.6, height: self.view.frame.width/2.6)
            userDisplayPhotoView.center.x = CGRectGetMidX(self.view.frame)
            userDisplayPhotoView.center.y = CGRectGetMidY(self.view.frame) * 0.5
            userDisplayPhotoView.contentMode = UIViewContentMode.ScaleAspectFill
        }
        else {
            
            userDisplayPhotoView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width/2.2, height: self.view.frame.width/2.2)
            userDisplayPhotoView.center.x = CGRectGetMidX(self.view.frame)
            userDisplayPhotoView.center.y = CGRectGetMidY(self.view.frame) * 0.5
            userDisplayPhotoView.contentMode = UIViewContentMode.ScaleAspectFill
        }
        
        userDisplayPhotoView.layer.cornerRadius = userDisplayPhotoView.frame.width/2
        userDisplayPhotoView.layer.borderWidth = 3
        userDisplayPhotoView.layer.borderColor = UIColor.appCreamColor().CGColor
        userDisplayPhotoView.clipsToBounds = true
        
        self.view.addSubview(userDisplayPhotoView)
    }
    
    func setResultImage (summation: Int) {
        
        var image = DataController.getPhotoResult()
        
        resultImageView = UIImageView(image: image)
        resultImageView.frame = CGRect(x: 0, y: 0, width: CGRectGetMidX(self.view.frame), height: CGRectGetMidX(self.view.frame))
        resultImageView.center.x = CGRectGetMidX(self.view.frame)
        resultImageView.center.y = CGRectGetMaxY(self.view.frame) * 7/10
        resultImageView.layer.borderWidth = 3
        resultImageView.layer.borderColor = UIColor.appCreamColor().CGColor
        
        self.view.addSubview(resultImageView)
        
        // setWaterMark()
    }

    func setWaterMark () {
        var waterMarkBG = UIImage(named: "waterMarkBG")
        var waterMarkBGView = UIImageView(image: waterMarkBG)
        
        waterMarkBGView.frame = CGRectMake(0, 0, resultImageView.frame.width, 20)
        waterMarkBGView.center.x = resultImageView.center.x
        waterMarkBGView.center.y = resultImageView.center.y - resultImageView.frame.width/2 + 10
        waterMarkBGView.alpha = 0.5
        
        self.view.addSubview(waterMarkBGView)
        
        var waterMarkText = UILabel(frame: CGRectMake(0, 0, resultImageView.frame.width, 20))
        waterMarkText.text = "Download โหลดได้ที่ Play Store และ App Store"
        waterMarkText.textColor = UIColor.whiteColor()
        waterMarkText.font = UIFont.systemFontOfSize( self.view.frame.width/45 )
        waterMarkText.textAlignment = NSTextAlignment.Center
        waterMarkText.center.x = resultImageView.center.x
        waterMarkText.center.y = resultImageView.center.y - resultImageView.frame.width/2 + 10
        
        self.view.addSubview(waterMarkText)
    }
    
    func setContentBackgroundTemplate () {
        
        let margin: CGFloat = self.margin + 6
        let statusBarHeight: CGFloat = 20
        let topMargin: CGFloat = statusBarHeight + self.margin + 3
        
        var imageString = "tempContentBackground"
        var image = UIImage(named: imageString)
        
        //        let frameHeight = self.view.frame.height - (topMargin) - elementHeight - margin - 6
        var frameWidth  = self.view.frame.width - (margin * 2)
        //        let frameWidth  = frameHeight * 0.7
        var frameHeight = frameWidth * 1.4
        
        if (iPhoneScreenSize() == "3.5") {
            frameWidth = frameWidth * 0.95
            frameHeight = frameHeight * 0.95
        }
        
        backgroundImageView = UIImageView(image: image)
        backgroundImageView.frame = CGRect(x: margin, y: topMargin, width: frameWidth, height: frameHeight)
        backgroundImageView.center = CGPoint(x: CGRectGetMidX(contentBackgroundImageShape.frame), y: CGRectGetMidY(contentBackgroundImageShape.frame))
        
        self.view.addSubview(backgroundImageView)
    }
    
    func setContentBackgroundImageView () {
        
        // defind the top margin
        
        let statusBarHeight: CGFloat = 20
        let topMargin: CGFloat = statusBarHeight + margin
        
        // Create a shape
        
        contentBackgroundImageShape = CAShapeLayer()
        contentBackgroundImageShape.frame = CGRect(x: margin, y: topMargin, width: self.view.frame.width - margin * 2, height: self.view.frame.height - ( margin * 2 + topMargin) - elementHeight)
        contentBackgroundImageShape.path = UIBezierPath(roundedRect: contentBackgroundImageShape.bounds, cornerRadius: 6).CGPath
        contentBackgroundImageShape.fillColor = UIColor.appCreamColor().CGColor
        contentBackgroundImageShape.strokeColor = UIColor.grayColor().CGColor
        contentBackgroundImageShape.lineWidth = 0.3;
        
        self.view.layer.addSublayer( contentBackgroundImageShape )
        
        var yPosition: CGFloat = topMargin + 30
        var line = CAShapeLayer()
        line.frame = CGRect(x: margin, y: yPosition, width: self.view.frame.width - margin * 2, height: 1)
        line.path = UIBezierPath(roundedRect: line.bounds, cornerRadius: 6).CGPath
        line.strokeColor = UIColor.lightGrayColor().CGColor
        line.lineWidth = 0.3;
        
        while (yPosition < contentBackgroundImageShape.frame.height) {
            var line = CAShapeLayer()
            line.frame = CGRect(x: margin - 16, y: yPosition, width: contentBackgroundImageShape.frame.width * 0.9, height: 1)
            line.position.x = contentBackgroundImageShape.position.x
            line.path = UIBezierPath(roundedRect: line.bounds, cornerRadius: 6).CGPath
            line.fillColor = UIColor.clearColor().CGColor
            line.strokeColor = UIColor(white: 0, alpha: 0.5).CGColor
            line.lineWidth = 0.3;
            
            self.view.layer.addSublayer(line)
            yPosition = yPosition + 30
        }
        
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

// MARK: - Upload image to Parse

extension ResultViewController {
    
    func saveResult () {
        
        // Draw an UIImage to share to Facebook
        let imageForShare = drawUIImageResult()
        let imageData: NSData = UIImagePNGRepresentation(imageForShare)
        // let imageData: NSData = UIImageJPEGRepresentation(imageForShare, 0.3)
        
        var newImageFile = PFFile(name: "UserGeneratedResult.png", data: imageData)
        newImageFile.saveInBackgroundWithBlock({
            (succeeded: Bool, error: NSError?) -> Void in
            
            // If saving the image is succeeded
            if (error == nil){
                
                // Show the image url
                println(newImageFile.url)
                
                // Use the image url we got to share on Facebook
                self.setContentToShare(contentURLImage: newImageFile.url!)
                
                // Stop the loading indicator and enable the Facebook share button
                self.shareButton.enabled = true
                self.spinner.stopAnimating()
                
            }
            }, progressBlock: { (percentDone: Int32) -> Void in
                
                // Show percentage of uploading an image
                println("percentDone: \(percentDone)")
                
        })
        
        // Save user result image to Parse, including the user information
        UserLogged.saveUserInformation()
        UserLogged.saveUserImageFile(newImageFile)

    }
}

// MARK: - Drawing UIImage methods

extension ResultViewController {

    // Draw a text into rectangle method
    func setText (drawText: NSString, fontSize: CGFloat, inImage: UIImage, atPoint:CGPoint) -> UIImage{
        
        // Setup the font specific variables
        var textColor: UIColor = UIColor.whiteColor()
        var textFont: UIFont = UIFont(name: "SukhumvitSet-Medium", size: fontSize)!
        
        //Setup the image context using the passed image.
        UIGraphicsBeginImageContext(inImage.size)
        
        //Setups up the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
        ]
        
        //Put the image into a rectangle as large as the original image.
        inImage.drawInRect(CGRectMake(0, 0, inImage.size.width, inImage.size.height))
        
        var textWidth = UILabel(frame: CGRectZero)
        textWidth.text = drawText as? String
        textWidth.sizeToFit()
        
        // Creating a point within the space that is as bit as the image.
        var rect: CGRect = CGRectMake(atPoint.x - textWidth.frame.width/2, atPoint.y, inImage.size.width, inImage.size.height)
        
        //Now Draw the text into an image.
        textWidth.text!.drawInRect(rect, withAttributes: textFontAttributes)
        
        // Create a new image out of the images we have created
        var newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        
        //And pass it back up to the caller.
        return newImage
        
    }
    
    func roundedRectImageFromImage (image: UIImage) -> UIImage {
        
        var imageResult = image
        
        let borderWidth: CGFloat = 5.0
        let imageSize: CGFloat = (image.size.width < image.size.height) ? image.size.width : image.size.height
        var imageViewer = UIImageView(frame: CGRectMake(0, 0, imageSize, imageSize))
        
        UIGraphicsBeginImageContextWithOptions(imageViewer.frame.size, false, 0)
        
        let path = UIBezierPath(roundedRect: CGRectInset(imageViewer.bounds, borderWidth / 2, borderWidth / 2), cornerRadius: imageViewer.frame.size.width/2)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSaveGState(context)
        // Clip the drawing area to the path
        path.addClip()
        
        // Draw the image into the context
        imageResult.drawInRect(imageViewer.bounds)
        CGContextRestoreGState(context)
        
        // Configure the stroke
        UIColor.appCreamColor().setStroke()
        path.lineWidth = borderWidth
        
        // Stroke the border
        path.stroke()
        
        imageResult = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return imageResult
    }
    
    func rectImageWithBorder (image: UIImage) -> UIImage {
        
        var imageResult = image
        
        let borderWidth: CGFloat = 5.0
        var imageViewer = UIImageView(frame: CGRectMake(0, 0, image.size.width, image.size.height))
        
        UIGraphicsBeginImageContextWithOptions(imageViewer.frame.size, false, 0)
        
        let path = UIBezierPath(roundedRect: CGRectInset(imageViewer.bounds, borderWidth / 2, borderWidth / 2), cornerRadius: 0)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSaveGState(context)
        // Clip the drawing area to the path
        path.addClip()
        
        // Draw the image into the context
        imageResult.drawInRect(imageViewer.bounds)
        CGContextRestoreGState(context)
        
        // Configure the stroke
        UIColor.appCreamColor().setStroke()
        path.lineWidth = borderWidth
        
        // Stroke the border
        path.stroke()
        
        imageResult = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return imageResult
    }
}

// MARK: - Capture screen methods
extension ResultViewController {

    func snapingUserDisplayPhotoView () -> UIImage {
        
        var screenShotImg = takeScreenShot()
        
        let cropingArea = self.userDisplayPhotoView.frame
        var cropingImg  = cropingImage(screenShotImg, cropingArea: cropingArea)
        
        var newSize     = CGSize(width: 130, height: 130)
        var resizeImg   = resizeImage(cropingImg , newSize: newSize)
        
        return resizeImg
        
    }

    // A method for treditional approach, take a screenshot, then croping a specific area, and rescale
    func snapingResult () -> UIImage {
        
        var screenShotImg = takeScreenShot()
        
        let cropingArea = self.backgroundImageView.frame
        var cropingImg  = cropingImage(screenShotImg, cropingArea: cropingArea)
        
        var newSize     = CGSize(width: 420, height: 221)
        var resizeImg   = resizeImage(cropingImg , newSize: newSize)
        
        // saveImageToAlbum(resizeImg)
        
        return resizeImg
    }
    
    func takeScreenShot () -> UIImage {
        
        // Make snapshot area, then shanp it to image
        
        let snapshotArea = self.view.frame.size
        UIGraphicsBeginImageContext( snapshotArea )
        
        self.view.layer.renderInContext(UIGraphicsGetCurrentContext())
        
        var screenShortImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        return screenShortImage
    }
    
    func cropingImage (image: UIImage, cropingArea: CGRect) -> UIImage {

        var croppingImg:CGImageRef = image.CGImage
        croppingImg = CGImageCreateWithImageInRect(croppingImg, cropingArea)
        
        return UIImage(CGImage: croppingImg)!
    }
    
    func resizeImage(image: UIImage, newSize: CGSize) -> UIImage {
        let newRect = CGRectIntegral(CGRectMake(0,0, newSize.width, newSize.height))
        let imageRef = image.CGImage
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        let context = UIGraphicsGetCurrentContext()
        
        // Set the quality level to use when rescaling
        CGContextSetInterpolationQuality(context, kCGInterpolationHigh)
        let flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height)
        
        CGContextConcatCTM(context, flipVertical)
        // Draw into the context; this scales the image
        CGContextDrawImage(context, newRect, imageRef)
        
        let newImageRef = CGBitmapContextCreateImage(context) as CGImage
        let newImage = UIImage(CGImage: newImageRef)
        
        // Get the resized image from the context and a UIImage
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func saveImageToAlbum (image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}

// MARK: - Controller methods
extension ResultViewController {
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        var touch = touches.first as! UITouch
        var point = touch.locationInView(self.view)
    }
}