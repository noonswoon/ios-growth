//
//  ViewController.swift
//  WhyDoPeopleLikeYou
//
//  Created by KHUN NINE on 6/23/15.
//  Copyright (c) 2015 KHUN NINE. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, FBSDKLoginButtonDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CustomAlertViewDelegate {
    
    // MARK: Facebook SDKs instance
    
    let permissions = ["public_profile", "email", "user_likes", "user_photos"]
    var content : FBSDKSharePhotoContent!
    var imagePicker = UIImagePickerController()
    var mediaSelected = ""
    
    // MARK: View elements instance
    
    var backgroundImageView: UIImageView!
    var contentBackgroundImageShape: CAShapeLayer!
    var contentBackgroundImageView: UIView!
    
    var profileImageView: CustomImageView!
    
    var shareButton:   FBSDKShareButton!
    var loginView:     FBSDKLoginButton!
    var shareDialog:   FBSDKShareDialog!
    var nameLabel:     UILabel!
    var resultLabel:   UILabel!
    
    let margin: CGFloat = 8
    let elementHeight: CGFloat = 44
    
    // MARK: Parse user logged object
    
    var logObject: PFObject!
    
    // MARK: Loading indicator
    
    var indicator: UIActivityIndicatorView!
    
    // MARK: Alert View container
    
    var containerView: UIView!
    var alertView: CustomAlertView!
    
    
    // MARK: Program life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view elements
        
        self.configView()
        
        // Check that is user already logged in, if not, show the login view up
        
        if (FBSDKAccessToken.currentAccessToken() != nil) {
        
            self.userLoggedIn()
        }
        else {
            
            self.setLoginView()
        }
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            let statusBarHeight: CGFloat = 20
            let topMargin: CGFloat = statusBarHeight + self.margin
            
            // Login view animate
            
            if ( self.loginView != nil ) {
                self.loginView.center.y = CGRectGetMaxY( self.view.frame ) - self.elementHeight/2 - self.margin
            }
            
            // Share button animate
            
            if ( self.shareButton != nil ) {
                self.shareButton.center.y = CGRectGetMaxY( self.view.frame ) - self.elementHeight/2 - self.margin
            }
            
        }, completion: nil)
    }
}
    

// MARK: Generating result

extension ViewController {
    
    // User information
    
    func setUserInformation() {
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me?fields=id,email,first_name,last_name,birthday", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil) {
                // Process error
                println("Error: \(error)")
            }
            else {
                println("fetched user: \(result)")
                
                let id        : String = (result.valueForKey("id")         != nil)  ? result.valueForKey("id")          as! String : ""
                let firstname : String = (result.valueForKey("first_name") != nil)  ? result.valueForKey("first_name")  as! String : ""
                let lastname  : String = (result.valueForKey("last_name")  != nil)  ? result.valueForKey("last_name")   as! String : ""
                let email     : String = (result.valueForKey("emails")     != nil)  ? result.valueForKey("emails")      as! String : firstname + "." + lastname + "@facebook.com"
                let birthday  : String = (result.valueForKey("birthday")   != nil)  ? result.valueForKey("birthday")    as! String : ""
                
                self.saveUserInformation(id, firstname: firstname, lastname: lastname, email: email, birthday: birthday)
                
                UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    self.nameLabel.alpha = 0.0
                    }, completion: {
                        (finished: Bool) -> Void in
                        
                        //Once the label is completely invisible, set the text and fade it back in
                        self.nameLabel.text = "People like\n\(firstname) because"
                        
                        // Fade in
                        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                            self.nameLabel.alpha = 1.0
                            }, completion: nil)
                })
            }
        })
    }
    
    func saveUserInformation (id: String, firstname: String, lastname: String, email: String, birthday: String) {
        
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
    
    
    // MARK: Calculating result
    
    func findMaximumPageCategoryCount () {
        
        var graphPath : String = "me?fields=likes.limit(1000)"
        var returnResult = ""
        
        var request: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: graphPath, parameters: nil, HTTPMethod: "GET")
        request.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil) {
                println("Error: \(error)")
            }
            else {
                var categoryDic = Dictionary<Character, Int>()
                
                // Getting all of the category of page that user liked
                let resultData = result as! NSDictionary
                let likes: NSDictionary = resultData["likes"] as! NSDictionary
                let datas:  NSArray = likes["data"] as! NSArray
                
                // Keep those data into dictionary named categoryDic. Use category name as key and among as value
                for data in datas {
                    let category = data[ "category" ] as! String
                    let firstChar = (Array(category))[0]
                    
                    //println("\(firstChar): \(category)")
                    
                    if ( categoryDic[firstChar] == nil ) {
                        categoryDic[firstChar] = 0
                    } else {
                        categoryDic[firstChar] = categoryDic[firstChar]! + 1
                    }
                }
                
                // Sorting keys by value
                var sortedKeys = Array(categoryDic.keys).sorted({
                    categoryDic[$0] > categoryDic[$1]
                })
                
                
                // Show result
                println("\nCouting the first character of fanpage category that user liked")
                for sortedKey in sortedKeys {
                    
                    let key   = sortedKey
                    let value = categoryDic[sortedKey]
                    
                    if (value == 0) {
                        continue
                    }
                    
                    println("\(value!)\t : \(key)")
                }
                
                
                // println("\(sortedKeys[0])\t : \(categoryDic[sortedKeys[0]]!)")
                
                UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    
                    self.resultLabel.alpha = 0.0
                    
                    }, completion: {
                        (finished: Bool) -> Void in
                        
                        //Once the label is completely invisible, set the text and fade it back in
                        //self.resultLabel.text = self.generateResult("\(sortedKeys[0])")
                        
                        let image = UIImage(named: "tempResult.png")
                        let imageView = UIImageView(image: image)
                        imageView.frame = CGRectMake(0, 0, self.view.frame.width - self.margin*2, self.view.frame.width/2 )
                        imageView.center.x = self.view.center.x
                        imageView.center.y = self.view.frame.height * 3/4 - 20
                        
                        self.contentBackgroundImageView.addSubview( imageView )
                        
                        // Fade in
                        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                            
                            self.resultLabel.alpha = 1.0
                            
                            }, completion: nil)
                })
                
                
                
                
                let delay = 4.5 * Double(NSEC_PER_SEC)
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(time, dispatch_get_main_queue()) {
                    self.saveResult()
                }

                
                
                
            }
        })
    }
    
    func generateResult (keyword: String) -> String {
        
        var scalars     = keyword.lowercaseString.unicodeScalars
        let firstScalar = scalars[ scalars.startIndex ].hashValue
        let key         = firstScalar - 97
        
        return DataController.resultsEng[ key ] + "\n\n" + DataController.resultsThai[ key ]
    }
    
    
    func sortingFanpageUserLike () {
        // For more complex open graph stories, use `FBSDKShareAPI`
        // with `FBSDKShareOpenGraphContent`
        /* make the API call */
        
        let graphPath : String = "me?fields=likes.limit(1000)"
        
        var request: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: graphPath, parameters: nil, HTTPMethod: "GET")
        request.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil) {
                println("Error: \(error)")
            }
            else {
                var categoryDic = Dictionary<String, Int>()
                
                // Getting all of the category of page that user liked
                let resultData = result as! NSDictionary
                let likes: NSDictionary = resultData["likes"] as! NSDictionary
                let datas:  NSArray = likes["data"] as! NSArray
                
                // Keep those data into dictionary named categoryDic. Use category name as key and among as value
                for data in datas {
                    let category = data[ "category" ] as! String
                    if ( categoryDic[category] == nil ) {
                        categoryDic[category] = 1
                    } else {
                        categoryDic[category] = categoryDic[category]! + 1
                    }
                }
                
                // Sorting keys by value
                var sortedKeys = Array(categoryDic.keys).sorted({
                    categoryDic[$0] > categoryDic[$1]
                })
                
                // Show
                println("\nCouting category of fanpage that user liked")
                for sortedKey in sortedKeys {
                    let key   = sortedKey
                    let value = categoryDic[sortedKey]
                    
                    println("\(value!)\t : \(key)")
                }
            }
        })
    }
    
    func saveResult () {
        
        let objectFile = PFObject(className: "UserGeneratedResult")
        let snapshotImage = screenShotSpecificArea()
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
}



// MARK: View attributes control

extension ViewController {
    
    // Handle the touche
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
    
        
        var touch = touches.first as! UITouch
        var point = touch.locationInView( self.view )
        
        if (CGRectContainsPoint( self.view.bounds , point)) {
            println("testset")
        }
        
        super.touchesBegan(touches , withEvent:event)
    }
}



// MARK: Set view elements

extension ViewController {
    
    func configView () {
        
        if (profileImageView == nil) {
            self.setProfileImageView()
        }
        
        if (nameLabel == nil) {
            self.setNameLabel()
        }
        
        if (resultLabel == nil) {
            self.setResultLabel()
        }
        
        if (backgroundImageView == nil) {
            self.setBackgroundImageView()
        }
        
        if (logObject == nil) {
            self.setLogObject()
        }
        
        if (contentBackgroundImageView == nil) {
            self.setContentBackgroundImageView()
        }
        
        if (indicator == nil) {
            self.indicator = setLoadingIndicator()
        }
    }
    
    
    // Determine the size of device
    
    func isClassicModel () -> Bool {
        
        var result: CGSize = UIScreen.mainScreen().bounds.size
        
        if(result.height == 480) {
            println("iPhone Classic")
            return true
        }
        else if(result.height == 568) {
            println("iPhone 5")
            return false
        }
        else if(result.height == 667) {
            println("iPhone 6")
            return false
        }
        else if(result.height == 736) {
            println("iPhone 6 Plus")
            return false
        }
        else {
            return false
        }
    }

    
    // Set the status bar style
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return UIStatusBarStyle.LightContent
    }

}


// MARK: Setter methods for view elements

extension ViewController {
    
    // set the profile image view
    
    func setProfileImageView () {
        
        // Calculate x, y position from screen device
        
        let imageSize: CGFloat = 150
        var imagePosX: CGFloat = CGRectGetMidX( self.view.frame ) - imageSize / 2
        var imagePosY: CGFloat = imagePosX
        
        if (self.isClassicModel()) {
            
            // Handle the x position if the device is iPhone4,4S (iPhone classic)
            // because we calculate the y position from the frame width, but iPhone classic has difference screen ratio
            
            imagePosY = imagePosX * 0.55
        }
        
        // Make view and add to subview
        
        self.profileImageView = CustomImageView()
        self.profileImageView.frame = CGRectMake(imagePosX, imagePosY, imageSize, imageSize)
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2;
        self.profileImageView.layer.masksToBounds = true;
        self.profileImageView.layer.borderWidth = 0;
        
        self.view.addSubview( self.profileImageView )
    }
    
    
    // Set the name label
    
    func setNameLabel () {
        
        nameLabel = UILabel(frame: CGRectMake(0, 0, self.view.frame.width, 120))
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = NSTextAlignment.Center
        nameLabel.center.x = CGRectGetMidX( self.view.frame )
        nameLabel.center.y = self.view.frame.height * 0.5
        nameLabel.text     = ""
        
        self.view.addSubview( nameLabel )
    }
    
    
    // Set the result label
    
    func setResultLabel () {
        
        resultLabel = UILabel(frame: CGRectMake(0, 0, self.view.frame.width * 0.85, 200))
        resultLabel.center.x = self.view.center.x
        resultLabel.center.y = self.view.frame.height * 0.7
        resultLabel.textAlignment = NSTextAlignment.Center
        resultLabel.font = UIFont.systemFontOfSize(17)
        resultLabel.numberOfLines = 0
        resultLabel.textColor = UIColor.grayColor()
        resultLabel.text = ""
        
        self.view.addSubview( resultLabel )
    }
    
    
    // Set the background image view (green screen)
    
    func setBackgroundImageView () {
        backgroundImageView = UIImageView(image: UIImage(named: "main_background.png"))
        backgroundImageView.frame = view.frame
        backgroundImageView.contentMode = .ScaleAspectFill
        
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
    }
    
    
    // Set the content background image view (white screen)
    
    func setContentBackgroundImageView () {
        
        // defind the top margin
        
        let statusBarHeight: CGFloat = 20
        let topMargin: CGFloat = statusBarHeight + margin
        
        // Create a shape
        
        contentBackgroundImageShape = CAShapeLayer()
        contentBackgroundImageShape.frame = CGRect(x: margin, y: topMargin, width: self.view.frame.width - margin * 2, height: self.view.frame.height - ( margin * 2 + topMargin) - elementHeight)
        contentBackgroundImageShape.path = UIBezierPath(roundedRect: contentBackgroundImageShape.bounds, cornerRadius: 6).CGPath
        contentBackgroundImageShape.fillColor = UIColor(white: 1, alpha: 1).CGColor
        contentBackgroundImageShape.strokeColor = UIColor.grayColor().CGColor
        contentBackgroundImageShape.lineWidth = 0.3;
        
        // Create a imageView then assign a shape
        // The view should be add into subview when the content is ready, by method setContentBackground
        
        contentBackgroundImageView = UIView()
        contentBackgroundImageView.frame = self.view.frame
        contentBackgroundImageView.layer.addSublayer( contentBackgroundImageShape)
        contentBackgroundImageView.layer.zPosition = -1
        
        self.view.layer.zPosition = -2
    }
    
    func setUserProfilePictureWithAnimation () {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil) {
                println("Error: \(error)")
            }
            else {
                let publicProfile = result as! NSDictionary
                let userID = publicProfile["id"] as! String
                println(userID)
                
                let urlString = "https://graph.facebook.com/\(userID)/picture?type=large"
                
                self.profileImageView.setImage(url: urlString)
                self.profileImageView.runProcess()
                
                
            }
        })
    }
    
    
    func setContentBackground () {
        
        self.contentBackgroundImageView.alpha = 0
        self.backgroundImageView.addSubview( contentBackgroundImageView )
        
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            self.contentBackgroundImageView.alpha = 1.0
            }, completion: nil)
    }
    
    func setLogObject () {
        self.logObject = PFObject(className: "UserLogged")
    }
}

// MARK: Snapshot method for window

extension ViewController {
    
    
    func screenShotSpecificArea () -> UIImage {

        // Make snapshot area, then shanp it to image
        
        let snapshotArea = self.view.frame.size
        UIGraphicsBeginImageContext( snapshotArea )
        
        self.view.layer.renderInContext(UIGraphicsGetCurrentContext())
        
        var screenShortImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        // Cropping the image, cut out the area outside result
        
        let cropingArea = contentBackgroundImageShape.frame
        var croppingImg:CGImageRef = screenShortImage.CGImage
        croppingImg = CGImageCreateWithImageInRect(croppingImg, cropingArea)
        
        
        // Optional: save the image to album
        
        let resultImage = UIImage(CGImage: croppingImg)
        // saveImageToAlbum( resultImage! )
        
        return resultImage!
    }
    
    
    // Function for saving image to photos album
    
    func saveImageToAlbum (image: UIImage) {
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}


// MARK: Facebook SDKs setter method

extension ViewController {
    
    
    // Set login button
    
    func setLoginView () {
        
        loginView = FBSDKLoginButton()
        loginView.frame = CGRectMake(8, 0, self.view.frame.width - 16, elementHeight)
        loginView.center.x = CGRectGetMidX( self.view.frame )
        
        // The y position should be animated
        loginView.center.y = CGRectGetMaxY( self.view.frame ) + CGRectGetMidY( self.loginView.frame ) + self.margin
        
        loginView.layer.cornerRadius = 6
        loginView.layer.masksToBounds = true
        loginView.addTarget(self, action: "loginViewClicked", forControlEvents: .TouchUpInside)
        
        loginView.readPermissions = permissions
        loginView.delegate = self
        
        self.view.addSubview(loginView)
    }
    
    
    // After user clicked the logginView, it should be removed from super and show the share buton instead
    
    func loginViewClicked () {
        
        self.loginView.removeFromSuperview()
    }
    
    
    // Set share button
    
    func setShareButtonWith (#contentURLImage: String){
        
        // Set the content of ShareLinkContent
        
        let contentURL = "https://noonswoonapp.com"
        let default_contentURLImage = "http://blog.noonswoonapp.com/wp-content/uploads/2015/06/b04.jpg"
        let contentTitle = "Noonswoon, give yourself a change"
        let contentDescription = "Noonswoon introduces you to one NEW person every day at noon.You have 24 hours to decide whether you like your match.If both of you LIKE each other, the app will CONNECT you and you can CHAT privately"
        
        let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
        content.contentURL = NSURL(string: contentURL)
        content.contentTitle = contentTitle
        content.contentDescription = contentDescription
        content.imageURL = NSURL(string: contentURLImage)
        
        shareButton = FBSDKShareButton()
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
            
            if ( self.shareButton != nil ) {
                self.shareButton.center.y = CGRectGetMaxY( self.view.frame ) - self.elementHeight/2 - self.margin
            }
            
            }, completion: nil)
    }
    
    
    
    // Handlge when user click share button
    
    func shareButtonClicked () {
        
        logObject["clickedShare"] = true
        logObject.saveInBackground()
        
        //self.showAds()
    }
    
    
    // Set the advertisments, it should has a few delays before showing up
    
    func showAds (timeDelay: Double) {
        
        let delay = timeDelay * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.launchAlertView()
        }

    }
    
    func launchAlertView() {
        
        var buttons = ["Cancel"]
        
        alertView = CustomAlertView()
        
        alertView.buttonTitles = buttons
        alertView.containerView = createAds()
        alertView.delegate = self
        alertView.onButtonTouchUpInside = { (alertView: CustomAlertView, buttonIndex: Int) -> Void in
            println("CLOSURE: Button '\(buttons[buttonIndex])' touched")
        }
        
        alertView.show()
    }
    
    func createAds () -> UIView {
        
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
    
    func customAlertViewButtonTouchUpInside(alertView: CustomAlertView, buttonIndex: Int) {
        
        alertView.close()
    }
    
    func adsClicked () {
        
        alertView.close()
        
        logObject["clickedAds"] = true
        logObject.saveInBackground()
        
        let itunesLink: NSURL = NSURL(string: "itms-apps://itunes.apple.com/th/app/noonswoon-top-dating-app-to/id605218289?mt=8")!
        UIApplication.sharedApplication().openURL(itunesLink)
    }

}


// MARK: Login - Logout activities

extension ViewController {
    
    func userLoggedIn () {
        
        // Set user information
        
        self.setUserInformation()
        self.setUserProfilePictureWithAnimation()
        
        // Calculateing
        
        self.findMaximumPageCategoryCount()
        
        // Set view elements
        // The share button wiil be shown after the result generated
        
        self.setContentBackground()
        
        // Just for testing query data
        
        sortingFanpageUserLike()
    }
    
    
    
    // Facebook Delegate Methods
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        println("User Logged In")
        
        if ((error) != nil) {
        }
        else if result.isCancelled {
        }
        else {
            self.userLoggedIn()
        }
    }
    
    // Remove the view elements if user logged out the application
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
        self.nameLabel.text   = ""
        self.resultLabel.text = ""
        self.profileImageView.removeFromSuperview()
        self.backgroundImageView.image = UIImage(named: "background1.png")
        self.shareButton.removeFromSuperview()
        self.contentBackgroundImageView.removeFromSuperview()
        
        println("User Logged Out")
    }
}


// MARK: UIView extension

extension UIView {
    
    // Fade in
    
    func fadeIn(duration: NSTimeInterval = 1.0, delay: NSTimeInterval = 0.0, completion: ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.alpha = 1.0
            }, completion: completion)  }
    
    // Fade out
    
    func fadeOut(duration: NSTimeInterval = 1.0, delay: NSTimeInterval = 0.0, completion: (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.alpha = 0.0
            }, completion: completion)
    }
}


// MARK: Loading indicator

extension ViewController {
    
    func setLoadingIndicator () -> UIActivityIndicatorView {
        
        indicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)

        indicator.backgroundColor = UIColor(white: 0.6, alpha: 0.8)
        indicator.frame = CGRectMake(0, 0, 140, 140);
        indicator.center = self.view.center;
        indicator.layer.cornerRadius = indicator.frame.width/4
        indicator.clipsToBounds = true
        
        // indicator.layer.borderColor = UIColor.lightGrayColor().CGColor;
        // indicator.layer.borderWidth = 1;
        
        self.view.addSubview(indicator)
        indicator.bringSubviewToFront( self.view)
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        return indicator
    }
}
