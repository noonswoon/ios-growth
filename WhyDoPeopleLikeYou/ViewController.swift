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
        setNotification()
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


extension ViewController {
    func setNotification () {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadUserProfileConpleted", name: "LoadUserProfileConpleted", object: nil)
    }
    
    func loadUserProfileConpleted () {
        var startViewController = StartViewController()
        startViewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        self.presentViewController(startViewController, animated: true, completion: nil)
    }

}


// MARK: Utilities

extension UIViewController {
    
    // Determine the size of device
    
    func iPhoneScreenSize () -> String {
        
        var result: CGSize = UIScreen.mainScreen().bounds.size
        
        if(result.height == 480) {
            println("3.5")
            return "3.5"
        }
        else if(result.height == 568) {
            println("4")
            return "4"
        }
        else if(result.height == 667) {
            println("4.7")
            return "4.7"
        }
        else if(result.height == 736) {
            println("5.5")
            return "5.5"
        }
        else {
            return ""
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
        
        SwiftSpinner.show("Loading\nUser profile", animated: true)
        
        UserLogged.setLogObject()
        
        // update some UI
//        DataController.loadUserProfileImage()
//        DataController.loadUserFirstName()
        DataController.loadUserProfile()
        DataController.findMaximumPageCategoryCount()
        
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

