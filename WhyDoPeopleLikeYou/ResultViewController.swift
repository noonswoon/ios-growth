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
    
    var shareButton: FBSDKShareButton!
    
    var spinner: UIActivityIndicatorView!
    
    var contentBackgroundImageShape: CAShapeLayer!
    var backgroundImageView: UIImageView!
    
    let margin: CGFloat = 8
    let elementHeight: CGFloat = 44
    
    
    var resultImageView: UIImageView!
    var resultImageForShare: UIImage!
    var userDisplayPhotoView: UIImageView!
    
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor.clearColor()
        
        // setContentBackgroundImageView()
        // setContentBackgroundTemplate() // Temporary use
        
        setBackground()
        setUserDisplayPhoto()
        setResultImage( DataController.summation )
        setSpinner()
        setLabels()
        
        
        println("Summation: \(DataController.summation)")
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if (!AdvertismentController.enableAds) {

            self.setShareButtonWith()
            self.setRetryButton()
            self.saveResult()
        }
    }
}


extension ResultViewController {
    
    func setContentForShare (#contentURLImage: String) {
        // Set the content of ShareLinkContent
        
        let contentURL = "https://goo.gl/pszrQA"
        let default_contentURLImage = "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c2/F_icon.svg/2000px-F_icon.svg.png"
        let contentTitle = "เหตุผลที่ทำไมคนถึงชอบคุณ"
        let contentDescription = " คุณเคยคิดหรือไม่ ว่าทำไมคนถึงชอบคุณ อะไรเป็นสาเหตุกันแน่นะ? ดาวน์โหลด 'ชอบฉันไม' สิ ด้วยอัลกอรึทึมขั้นสูงของเรา ที่วิเคราะห์จากการกดไลค์และการตอบคำถามของคุณ จะทำให้คุณรู้คำตอบที่น่าทึ่ง!"
        
        let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
        content.imageURL = NSURL(string: contentURLImage)
        content.contentURL = NSURL(string: contentURL)
        content.contentTitle = contentTitle
        content.contentDescription = contentDescription
        
        shareButton.shareContent = content
    }
    
    func setShareButtonWith () {
        
        shareButton = FBSDKShareButton()
        // shareButton.shareContent = content
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
        
        
        // Show up animation
        
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            self.shareButton.center.y = CGRectGetMaxY( self.view.frame ) - self.elementHeight/2 - self.margin
            self.spinner.startAnimating()
            
            }, completion: nil)
    }
    
    func shareButtonClicked () {
        
        // Log user activities
        UserLogged.shareButtonClicked()
        
        // Enable the advertisment alert
        AdvertismentController.enableAds = true
    }
}

// MARK: Set retry button

extension ResultViewController {
    
    func setRetryButton () {
        
        var retryButton = UICustomButton(frame: CGRectMake(8, 0, self.view.frame.width/2 - 12, elementHeight))
        retryButton.setTitle("เล่นใหม่", forState: .Normal)
        retryButton.titleLabel!.font = UIFont(name: "supermarket", size: 21)
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
        
        var myAppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var rootViewController = myAppDelegate.window?.rootViewController?.presentedViewController!
        rootViewController?.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
        rootViewController!.dismissViewControllerAnimated(true, completion: nil)

    }
}

// MARK: Setter methods

extension ResultViewController {
    
    func setBackground () {
        
        var backgroundImageView = UIImageView(image: UIImage(named: "main_background2"))
        backgroundImageView.frame = view.frame
        backgroundImageView.contentMode = .ScaleAspectFill
        
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
    }

    
    func setSpinner () {
        spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        spinner.frame = CGRectMake(self.view.frame.width/2 + 4, 0, self.view.frame.width/2 - 12, elementHeight)
        spinner.center.y = CGRectGetMaxY( self.view.frame ) - self.elementHeight/2 - self.margin
        spinner.layer.zPosition = 10
        
        self.view.addSubview(spinner)
    }
    
    func setLabels () {
        
        let frame = CGRectGetMaxY(self.view.frame)
        let title = "เหตุผลที่ทำไม\nคนถึงชอบคุณ"
        let firstName = DataController.userFirstNameText
        let codeName  = "สมญานาม: \(DataController.getCodeName())"
        let isThatYou = "นี่ใช่คุณหรือเปล่า"
        let description = DataController.getDescription()
        
        if (iPhoneScreenSize() == "3.5") {
            
            setLabel(title, yPosition: frame * 0.085, size: 26)
            setLabel(firstName, yPosition: frame * 0.41, size: 21)
            setLabel(codeName, yPosition: frame * 0.445, size: 21)
            setLabel(isThatYou, yPosition: frame * 0.51, size: 23)
            setLabel(description, yPosition: frame * 0.83, size: 20)
        }
        else if (iPhoneScreenSize() == "4") {
            
            setLabel(title, yPosition: frame * 0.085, size: 25)
            setLabel(firstName, yPosition: frame * 0.42, size: 25)
            setLabel(codeName, yPosition: frame * 0.45, size: 25)
            setLabel(isThatYou, yPosition: frame * 0.533, size: 24)
            setLabel(description, yPosition: frame * 0.81, size: 20)
        }

        else if (iPhoneScreenSize() == "4.7") {
            
            setLabel(title, yPosition: frame * 0.085, size: 25)
            setLabel(firstName, yPosition: frame * 0.42, size: 23)
            setLabel(codeName, yPosition: frame * 0.45, size: 23)
            setLabel(isThatYou, yPosition: frame * 0.545, size: 24)
            setLabel(description, yPosition: frame * 0.82, size: 23)
        }
        else if (iPhoneScreenSize() == "5.5") {
            
            setLabel(title, yPosition: frame * 0.085, size: 27)
            setLabel(firstName, yPosition: frame * 0.42, size: 25)
            setLabel(codeName, yPosition: frame * 0.45, size: 25)
            setLabel(isThatYou, yPosition: frame * 0.545, size: 27)
            setLabel(description, yPosition: frame * 0.82, size: 25)
        }
    }
    
    func setLabel (title: String, yPosition: CGFloat, size: CGFloat) {
        
        let label = UILabel(frame: CGRectMake(0, 0, self.view.frame.width, 200))
        label.numberOfLines = 0
        label.font = UIFont(name: "supermarket", size: size)
        label.text = title
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.whiteColor()
        //label.sizeToFit()
        label.center.x = self.view.center.x
        label.center.y = yPosition
        
        
        self.view.addSubview( label )

    }
    
    func setUserFirstName () {
        
        let userFirstNameLabel = UILabel(frame: CGRectMake(0, 0, self.view.frame.width, 80))
        userFirstNameLabel.text = DataController.userFirstNameText
        userFirstNameLabel.textAlignment = NSTextAlignment.Center
        userFirstNameLabel.textColor = UIColor.appCreamColor()
        userFirstNameLabel.backgroundColor = UIColor.lightGrayColor()
        userFirstNameLabel.sizeToFit()
        userFirstNameLabel.center.x = self.view.center.x
        userFirstNameLabel.center.y = self.view.frame.height * 0.4
        
        
        self.view.addSubview( userFirstNameLabel )
    }
    
    func setResultText () {
        
        let result = UILabel(frame: CGRectMake(0, 0, self.view.frame.width, 100))
        result.numberOfLines = 0
        result.lineBreakMode = .ByWordWrapping
        result.text = DataController.getDescription()
        result.textAlignment = NSTextAlignment.Center
        result.textColor = UIColor.appBrownColor()
        result.backgroundColor = UIColor.lightGrayColor()
        // result.sizeToFit()
        result.center.x = self.view.center.x
        result.center.y = self.view.frame.height * 0.52
        
        
        self.view.addSubview( result )
    }
    
    func setUserDisplayPhoto () {
        
        userDisplayPhotoView = UIImageView(image: DataController.userProfileImage)

        if (iPhoneScreenSize() == "3.5") {
            userDisplayPhotoView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width/3, height: self.view.frame.width/3)
            userDisplayPhotoView.center.x = CGRectGetMidX(self.view.frame)
            userDisplayPhotoView.center.y = CGRectGetMidY(self.view.frame) * 0.525
            userDisplayPhotoView.contentMode = UIViewContentMode.ScaleAspectFill
        } else {
            userDisplayPhotoView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width/2.4, height: self.view.frame.width/2.4)
            userDisplayPhotoView.center.x = CGRectGetMidX(self.view.frame)
            userDisplayPhotoView.center.y = CGRectGetMidY(self.view.frame) * 0.525
            userDisplayPhotoView.contentMode = UIViewContentMode.ScaleAspectFill
        }
        
        
//        if (isClassicModel()) {
//            imageView.center.y = CGRectGetMaxY(self.view.frame) * 0.2
//        }
        
        userDisplayPhotoView.layer.cornerRadius = userDisplayPhotoView.frame.width/2
        userDisplayPhotoView.layer.borderWidth = 3
        userDisplayPhotoView.layer.borderColor = UIColor.appCreamColor().CGColor
        userDisplayPhotoView.clipsToBounds = true
        
        self.view.addSubview(userDisplayPhotoView)
    }
    
    func setResultImage (summation: Int) {
        
        var imageKey = (summation < 1) ? 1 : summation
        
        var imageString = "\(imageKey)"
        
        println(imageString)
        
        var image = UIImage(named: imageString)
        
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

extension ResultViewController {
    
    func saveResult () {
        
        let objectFile = UserLogged.logObject
        let imageForShare = makeUIImageResult()
        let imageData: NSData = UIImagePNGRepresentation( imageForShare )
        //let imageData: NSData = UIImagePNGRepresentation( UIImage(named: "testRatioImage"))
        
        // SwiftSpinner.showWithDelay(2.0, title: "It's taking longer than expected")
        // SwiftSpinner.show("Processing \n0%")
        
        var newImageFile = PFFile(name: "UserGeneratedResult.png", data: imageData)
        newImageFile.saveInBackgroundWithBlock({
            (succeeded: Bool, error: NSError?) -> Void in
            if (error == nil){
                
                // SwiftSpinner.hide()
                
                println(newImageFile.url)
                // self.setShareButtonWith(contentURLImage: newImageFile.url!)
                
                self.setContentForShare(contentURLImage: newImageFile.url!)
                self.shareButton.enabled = true
                self.spinner.stopAnimating()
                
                println(self.shareButton.enabled)
                
            }
            }, progressBlock: {
                (percentDone: Int32) -> Void in
                println("percentDone: \(percentDone)")
                
                // SwiftSpinner.show("Processing \n\(percentDone-2)%")
                
        })
        
        UserLogged.saveUserInformation()
    
        objectFile["imageFile"] = newImageFile    
        objectFile.saveInBackground()
    }
}

// MARK: Drawing UIImage

extension ResultViewController {
    
    func makeUIImageResult () -> UIImage {
        
        let rectSize: CGSize = CGSizeMake(470, 246)
        
        let resultSize: CGSize = CGSizeMake( rectSize.height-40, rectSize.height-40 )
        let displaySize: CGSize = CGSizeMake(120, 120)

        var background: UIImage = UIImage(named: "backgroundColor")!
        var waterMarkBG: UIImage = UIImage(named: "waterMarkBG")!
        var result: UIImage = rectImageWithBorder( UIImage(named: "\(DataController.summation)")! )
        
        var display: UIImage = snapingUserDisplayPhotoView()
        
        display = roundedRectImageFromImage(display)
        result  = rectImageWithBorder(result)
        
        UIGraphicsBeginImageContext(rectSize);
        
        background.drawInRect(CGRectMake(0, 0, rectSize.width, rectSize.height))
        waterMarkBG.drawInRect(CGRectMake(0, rectSize.height-20, rectSize.width, 20))
        result.drawInRect(CGRectMake(rectSize.width-resultSize.width-20, rectSize.height-resultSize.height-20, resultSize.width, resultSize.height))
        display.drawInRect(CGRectMake(rectSize.width/4 - displaySize.width/2, rectSize.height/2 - displaySize.height/2 - 15, displaySize.width + 10, displaySize.height + 10))
        
        var finalImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext();
        
        let textTitle  = "เหตุผลว่าทำไม\nคนถึงชอบคุณ"
        let textName   = DataController.userFirstNameText
        let textCode   = DataController.getCodeName()
        let isThatYou  = "แล้วนี่ใช่คุณหรือเปล่า"
        let textResult = DataController.getDescription()
        let waterMark  = "คลิกที่นี่ เพื่อดาวน์โหลดแอพและหาเหตุผลของคุณ"
        
        finalImage = setText(textTitle, fontSize: 25, inImage: finalImage, atPoint: CGPoint(x:rectSize.width/4, y:10))
        finalImage = setText(textName,  fontSize: 23, inImage: finalImage, atPoint: CGPoint(x:rectSize.width/4, y:180))
        finalImage = setText(textCode,  fontSize: 24, inImage: finalImage, atPoint: CGPoint(x:rectSize.width/4, y:200))
        finalImage = setText(isThatYou, fontSize: 19, inImage: finalImage, atPoint: CGPoint(x:rectSize.width*3/4+4, y:5))
        finalImage = setText(textResult,fontSize: 27, inImage: finalImage, atPoint: CGPoint(x:rectSize.width*3/4-15, y:195))
        finalImage = setText(waterMark, fontSize: 23, inImage: finalImage, atPoint: CGPoint(x:rectSize.width/2, y:rectSize.height - 17))
        
        //Add image to view
//        var imageView: UIImageView = UIImageView(frame: CGRectMake(0, 0, rectSize.width, rectSize.height))
//        imageView.image = finalImage
//        self.view.addSubview( imageView )
        
//        saveImageToAlbum( finalImage )
        
        return finalImage
    }
    
    func setText (drawText: NSString, fontSize: CGFloat, inImage: UIImage, atPoint:CGPoint) -> UIImage{
        
        // Setup the font specific variables
        var textColor: UIColor = UIColor.whiteColor()
        var textFont: UIFont = UIFont(name: "supermarket", size: fontSize)!
        
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
        // path.lineWidth = borderWidth
        
        // Stroke the border
        // path.stroke()
        
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


// MARK: Capture screen methods

extension ResultViewController {

    func snapingUserDisplayPhotoView () -> UIImage {
        
        var screenShotImg = takeScreenShot()
        
        let cropingArea = self.userDisplayPhotoView.frame
        var cropingImg  = cropingImage(screenShotImg, cropingArea: cropingArea)
        
        // var newSize     = CGSize(width: 420, height: 221)
        // var resizeImg   = resizeImage(cropingImg , newSize: newSize)
        
        // saveImageToAlbum(resizeImg)
        
        return cropingImg
        
    }
    
    func snapingResultImageView () -> UIImage {
        
        var screenShotImg = takeScreenShot()
        
        let cropingArea = self.resultImageView.frame
        var cropingImg  = cropingImage(screenShotImg, cropingArea: cropingArea)
        
        // var newSize     = CGSize(width: 420, height: 221)
        // var resizeImg   = resizeImage(cropingImg , newSize: newSize)
        
        // saveImageToAlbum(resizeImg)
        
        return cropingImg

    }
    
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
