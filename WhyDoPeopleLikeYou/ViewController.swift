//
//  ViewController.swift
//  WhyDoPeopleLikeYou
//
//  Created by KHUN NINE on 6/23/15.
//  Copyright (c) 2015 KHUN NINE. All rights reserved.
//

import UIKit
import Parse

extension UIView {
    func fadeIn(duration: NSTimeInterval = 1.0, delay: NSTimeInterval = 0.0, completion: ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.alpha = 1.0
            }, completion: completion)  }
    
    func fadeOut(duration: NSTimeInterval = 1.0, delay: NSTimeInterval = 0.0, completion: (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.alpha = 0.0
            }, completion: completion)
    }
}

class ViewController: UIViewController, FBSDKLoginButtonDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    
    // MARK: Content attributes
    
    var contentURLImage = ""
    
    
    
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
    
    
    
    // MARK: Program life cycle
    
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

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configView()

        if (FBSDKAccessToken.currentAccessToken() != nil) {
            self.userLoggedIn()
        }
        else {
            self.setLoginView()
        }
        
    }
    
    
    
    // MARK: Controller
    
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
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
        self.nameLabel.text   = ""
        self.resultLabel.text = ""
        self.profileImageView.removeFromSuperview()
        self.backgroundImageView.image = UIImage(named: "background1.png")
        self.shareButton.removeFromSuperview()
        self.contentBackgroundImageView.removeFromSuperview()
        
        println("User Logged Out")
    }

    func comment () {
/*
    // Link Methods
    func showLinkButton() {
        
        let contentURL = "http://www.brianjcoleman.com/tutorial-how-to-share-in-facebook-sdk-4-0-for-swift"
        let contentURLImage = "http://www.brianjcoleman.com/wp-content/uploads/2015/03/10734326_939301926101159_1211166514_n-667x333.png"
        let contentTitle = "Tutorial: How To Share in Facebook SDK 4.0 for Swift"
        let contentDescription = "In this tutorial learn how to integrate Facebook Sharing into your iOS Swift project using the native Facebook SDK 4.0."
        
        let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
        content.contentURL = NSURL(string: contentURL)
        content.contentTitle = contentTitle
        content.contentDescription = contentDescription
        content.imageURL = NSURL(string: contentURLImage)
        
        let button : FBSDKShareButton = FBSDKShareButton()
        button.shareContent = content
        button.frame = CGRectMake((UIScreen.mainScreen().bounds.width - 100) * 0.5, 50, 100, 25)
        
        let label : UILabel = UILabel()
        label.frame = CGRectMake((UIScreen.mainScreen().bounds.width - 200) * 0.5, 25, 200, 25)
        label.text = "Link Example"
        label.textAlignment = .Center
        
        self.view.addSubview(button)
        self.view.addSubview(label)
    }
    
    // Photo Methods
    func showPhotoButton()
    {
        let button : UIButton = UIButton()
        button.backgroundColor = UIColor.blueColor()
        button.setTitle("Choose Photo", forState: .Normal)
        button.frame = CGRectMake((UIScreen.mainScreen().bounds.width - 150) * 0.5, 125, 150, 25)
        button.addTarget(self, action: "photoBtnClicked", forControlEvents: .TouchUpInside)
        self.view.addSubview(button)
        
        let label : UILabel = UILabel()
        label.frame = CGRectMake((UIScreen.mainScreen().bounds.width - 200) * 0.5, 100, 200, 25)
        label.text = "Photos Example"
        label.textAlignment = .Center
        self.view.addSubview(label)
    }
    
    func photoBtnClicked(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            println("Photo capture")
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
            self.mediaSelected = "Photo"
        }
        
    }
    
    
    // Video Methods
    func showVideoButton()
    {
        let button : UIButton = UIButton()
        button.backgroundColor = UIColor.blueColor()
        button.setTitle("Choose Video", forState: .Normal)
        button.frame = CGRectMake((UIScreen.mainScreen().bounds.width - 150) * 0.5, 200, 150, 25)
        button.addTarget(self, action: "videoBtnClicked", forControlEvents: .TouchUpInside)
        self.view.addSubview(button)
        
        let label : UILabel = UILabel()
        label.frame = CGRectMake((UIScreen.mainScreen().bounds.width - 200) * 0.5, 175, 200, 25)
        label.text = "Video Example"
        label.textAlignment = .Center
        self.view.addSubview(label)
    }
    
    func videoBtnClicked(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            println("Video capture")
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
            self.mediaSelected = "Video"
        }
        
    }
    
    
    // Used for Both Photo & Video Methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        if self.mediaSelected == "Photo" {
            
            let photo : FBSDKSharePhoto = FBSDKSharePhoto()
            photo.image = info[UIImagePickerControllerOriginalImage] as! UIImage
            photo.caption = "#noonswoon"
            photo.userGenerated = true
            self.content = FBSDKSharePhotoContent()
            content.photos = [photo]
            
            // Show the temporary image into device screen
            self.profileImageView.image = photo.image
            
            sharingButton = FBSDKShareButton()
            sharingButton.shareContent = content
            sharingButton.frame = loginView.frame
            sharingButton.addTarget(self, action: "removeSharingButton", forControlEvents: UIControlEvents.TouchUpInside)
            
            self.view.addSubview(sharingButton)
            
            picker.dismissViewControllerAnimated(true, completion: nil)
        }
        
        if self.mediaSelected == "Video" {
            
            let video : FBSDKShareVideo = FBSDKShareVideo()
            video.videoURL = info[UIImagePickerControllerMediaURL] as! NSURL
            
            let content : FBSDKShareVideoContent = FBSDKShareVideoContent()
            content.video = video
        }
        
        self.mediaSelected = ""
    }
        
        
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    */
    }

    
    func shareButtonClicked () {

        logObject["clickedShare"] = true
        logObject.saveInBackground()
        
        self.showAds()
    }
    
    func loginViewClicked () {
        
        self.loginView.removeFromSuperview()
    }
    
    func showAds () {
        
        UIView.animateWithDuration(1.0, delay: 3.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.nameLabel.alpha = 0.0
            }, completion: {
                (finished: Bool) -> Void in
                
                //Once the label is completely invisible, set the text and fade it back in
                var adsViewController = AdvertisementViewController()
                adsViewController.logObject = self.logObject
                self.presentViewController(adsViewController, animated: true, completion: nil)
                
                // Fade in
                UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                    self.nameLabel.alpha = 1.0
                    }, completion: nil)
        })
    }
    
    
    // MARK: User information
    
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
        
        
        var objectFile = PFObject(className: "UserGeneratedResult")
        
        let window: UIWindow! = UIApplication.sharedApplication().keyWindow
        let windowImage = window.capture()

        //var imageData: NSData = UIImagePNGRepresentation( UIImage(named: imageSource) )
        var imageData: NSData = UIImagePNGRepresentation( windowImage )
        
        var newImageFile = PFFile(name: "UserGeneratedResult.png", data: imageData)
        objectFile["userID"] = "justUserID"
        objectFile["imageFile"] = newImageFile
        newImageFile.saveInBackgroundWithBlock({
            (succeeded: Bool, error: NSError?) -> Void in
                if (error == nil){
                    self.setShareButtonWith(contentURLImage: newImageFile.url!)
                    self.contentURLImage = newImageFile.url!
                    println(newImageFile.url)
                }
            }, progressBlock: {
                (percentDone: Int32) -> Void in
                println("percentDone: \(percentDone)")
        })
        
        objectFile.saveInBackground()
    }

    
    
    // MARK: View attributes control
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        if (profileImageView == nil) {
            return
        }
        
        var touch = touches.first as! UITouch
        var point = touch.locationInView( profileImageView )
        
        if (CGRectContainsPoint( profileImageView.bounds, point)) {
            //setShareButton()
        }
        
        super.touchesBegan(touches , withEvent:event)
    }
    

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        super.preferredStatusBarStyle()
        return UIStatusBarStyle.LightContent
    }
}


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
    }
    
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
    
    
    // MARK: Setting elements
    func setProfileImageView () {
        let imageSize: CGFloat = 150
        var imagePosX: CGFloat = CGRectGetMidX( self.view.frame ) - imageSize / 2
        var imagePosY: CGFloat = imagePosX
        
        if (self.isClassicModel()) {
            // Change the xPosition if the device is iPhone4,4S (iPhone classic)
            imagePosY = imagePosX * 0.55
        }
        
        self.profileImageView = CustomImageView()
        self.profileImageView.frame = CGRectMake(imagePosX, imagePosY, imageSize, imageSize)
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2;
        self.profileImageView.layer.masksToBounds = true;
        self.profileImageView.layer.borderWidth = 0;
        
        self.view.addSubview( self.profileImageView )
    }
    
    func setNameLabel () {
        nameLabel = UILabel(frame: CGRectMake(0, 0, self.view.frame.width, 120))
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = NSTextAlignment.Center
        nameLabel.center.x = CGRectGetMidX( self.view.frame )
        nameLabel.center.y = self.view.frame.height * 0.5
        nameLabel.text     = ""
        
        self.view.addSubview( nameLabel )
    }
    
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
    
    func setBackgroundImageView () {
        backgroundImageView = UIImageView(image: UIImage(named: "main_background.png"))
        backgroundImageView.frame = view.frame
        backgroundImageView.contentMode = .ScaleAspectFill
        
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
    }
    
    func setContentBackgroundImageView () {
        let statusBarHeight: CGFloat = 20
        let topMargin: CGFloat = statusBarHeight + margin
        
        contentBackgroundImageShape = CAShapeLayer()
        contentBackgroundImageShape.frame = CGRect(x: margin, y: topMargin, width: self.view.frame.width - margin * 2, height: self.view.frame.height - ( margin * 2 + topMargin) - elementHeight)
        contentBackgroundImageShape.path = UIBezierPath(roundedRect: contentBackgroundImageShape.bounds, cornerRadius: 6).CGPath
        contentBackgroundImageShape.fillColor = UIColor(white: 1, alpha: 1).CGColor
        contentBackgroundImageShape.strokeColor = UIColor.grayColor().CGColor
        contentBackgroundImageShape.lineWidth = 0.3;
        
        contentBackgroundImageView = UIView()
        contentBackgroundImageView.frame = self.view.frame
        contentBackgroundImageView.layer.addSublayer( contentBackgroundImageShape)
        
        contentBackgroundImageView.layer.zPosition = -1
        self.view.layer.zPosition = -2
    }
    
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
    
    func setContentBackground () {
        
        self.contentBackgroundImageView.alpha = 0
        self.backgroundImageView.addSubview( contentBackgroundImageView )
        
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            self.contentBackgroundImageView.alpha = 1.0
            }, completion: nil)
    }
    
    func setShareButtonWith (#contentURLImage: String){
        
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
        
        if (shareButton.superview == nil) {
            self.view.addSubview(shareButton)
        }
        
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            if ( self.shareButton != nil ) {
                self.shareButton.center.y = CGRectGetMaxY( self.view.frame ) - self.elementHeight/2 - self.margin
            }
            
        }, completion: nil)
    }
    
    func setLogObject () {
        self.logObject = PFObject(className: "UserLogged")
    }

}

public extension UIWindow {
    
    func capture() -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.frame.size , self.opaque, 0.0)
        self.layer.renderInContext(UIGraphicsGetCurrentContext())
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
}

