//
//  ViewController.swift
//  WhyDoPeopleLikeYou
//
//  Created by KHUN NINE on 6/23/15.
//  Copyright (c) 2015 KHUN NINE. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, FBSDKLoginButtonDelegate, UINavigationControllerDelegate {
    
    // MARK: Facebook SDKs permission
    
    let permissions = ["public_profile", "email", "user_likes", "user_photos"]
    var loginView:     FBSDKLoginButton!
    
    var startButton: UIButton!
    
    // MARK: View elements instance
    
    var backgroundImageView: UIImageView!
    
    let margin: CGFloat = 8
    let elementHeight: CGFloat = 44
    
    
    
    
    // MARK: Program life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view elements
        
        setBackgroundImageView()
        setQuestion()
    }
    
    override func viewDidAppear(animated: Bool) {
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            
            self.userLoggedIn()
        }
        else {
            
            self.setLoginView()
        }
    }
}



// MARK: Utilities

extension UIViewController {
    
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

    
}

extension ViewController {
    
    // Set the status bar style
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return UIStatusBarStyle.LightContent
    }

}


// MARK: Set view elements

extension ViewController {
    
    // Set the background image view (green screen)
    
    func setBackgroundImageView () {
        
        backgroundImageView = UIImageView(image: UIImage(named: "main_background"))
        backgroundImageView.frame = view.frame
        backgroundImageView.contentMode = .ScaleAspectFill
        
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
    }
    
    func setQuestion () {
        
        // Set the question to user for generating result
        
        DataController.setQuestionAndChoice()
        DataController.setQuestionViewControllers()
    }
}


// MARK: Facebook SDKs setter method

extension ViewController {
    
    
    // Set login button
    
    func setLoginView () {
        
        loginView = FBSDKLoginButton()
        loginView.frame = CGRectMake(8, 0, self.view.frame.width - margin*2, elementHeight)
        loginView.center.x = CGRectGetMidX( self.view.frame )
        loginView.center.y = CGRectGetMaxY( self.view.frame ) + CGRectGetMaxY( self.loginView.frame )
        loginView.layer.cornerRadius = 6
        loginView.layer.masksToBounds = true
        loginView.addTarget(self, action: "loginViewClicked", forControlEvents: .TouchUpInside)
        
        loginView.readPermissions = permissions
        loginView.delegate = self

        self.view.addSubview(loginView)
        
        UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.TransitionNone, animations: {
            self.loginView.center.y = CGRectGetMaxY( self.view.frame ) - self.elementHeight/2 - self.margin
            }, completion: nil)
    }
    
    
    // After user clicked the logginView, it should be removed from super and show the share buton instead
    
    func loginViewClicked () {
        
        self.loginView.removeFromSuperview()
    }
    
    
    func userLoggedIn () {
        
        setStartButton()
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            
            // Do some task
            
            dispatch_async(dispatch_get_main_queue()) {

                UserLogged.setLogObject()
                
                // update some UI
                DataController.loadUserProfileImage()
                DataController.loadUserFirstName()
                DataController.loadUserProfile()
                DataController.findMaximumPageCategoryCount()
            }
        }
    }
    
    func setStartButton () {
        
        startButton = UIButton(frame: CGRectMake(0, 0, self.view.frame.width - 16, 44))
        startButton.setTitle("เริ่ม!", forState: .Normal)
        startButton.setTitleColor( UIColor.blackColor(), forState: .Normal)
        startButton.setTitleColor( UIColor.grayColor(), forState: .Highlighted)
        startButton.center.x = self.view.center.x
        startButton.center.y = self.view.frame.height + 44
        startButton.backgroundColor = UIColor.whiteColor()
        startButton.layer.cornerRadius = 6
        startButton.layer.borderColor = UIColor.blackColor().CGColor
        startButton.layer.borderWidth = 1
        startButton.addTarget(self, action: "getStarted", forControlEvents: UIControlEvents.TouchUpInside)
        
        view.addSubview(startButton)
        
        UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.TransitionNone, animations: {
            self.startButton.center.y = self.view.frame.height * 2/3
            }, completion: nil)
    }
    
    func getStarted () {
        
        UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.TransitionNone, animations: {
            self.startButton.center.y = self.view.frame.height + 44
            }, completion: { (finished: Bool) in
                DataController.getStart(self)
        })
        
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

