//
//  ViewController.swift
//  WhyDoPeopleLikeYou
//
//  Created by KHUN NINE on 6/23/15.
//  Copyright (c) 2015 KHUN NINE. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate, UINavigationControllerDelegate {
    
    // MARK: Facebook SDKs permission
    let permissions = ["public_profile", "email", "user_likes", "user_photos"]
    var loginView:     FBSDKLoginButton!
    
    // MARK: View elements instance
    let margin: CGFloat = 8
    let elementHeight: CGFloat = 44
}

// MARK: - View life cycle
extension LoginViewController {
    
    override func viewDidLoad() {
        // Set the view elements
        setBackgroundImageView()
        setQuestionViewController()
        setNotificationCenter()
    }
    
    override func viewWillAppear(animated: Bool) {
        UserLogged.trackScreen("Login view")
    }
    
    override func viewDidAppear(animated: Bool) {
        if (!Reachability.isConnectedToNetwork()) {
            let myAlert = UIAlertView(title: "AlertView", message: "No internet connection", delegate: nil, cancelButtonTitle: "Cancel")
            myAlert.show()
        }
        else if (FBSDKAccessToken.currentAccessToken() != nil) {
            println("Current access token: \(FBSDKAccessToken.currentAccessToken().tokenString)")
            self.userLoggedIn()
        }
        else {
            self.setLoginView()
        }
    }
}

// MARK: Main method for starting application
extension LoginViewController {
    
    func userLoggedIn () {
        SwiftSpinner.show("กำลังโหลด\nข้อมูลผู้ใช้", animated: true)
        
        DataController.loadUserProfile()
        DataController.findMaximumPageCategoryCount()
    }
}

// MARK: Setter methods
extension LoginViewController {
    
    func setNotificationCenter () {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadUserProfileConpleted", name: "LoadUserProfileConpleted", object: nil)
    }
    
    func loadUserProfileConpleted () {
        var startViewController = StartViewController()
        startViewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        
        self.presentViewController(startViewController, animated: true, completion: nil)
    }
    
    func setBackgroundImageView () {
        let backgroundImageView = UIImageView(image: UIImage(named: "main_background"))
        backgroundImageView.frame = view.frame
        backgroundImageView.contentMode = .ScaleAspectFill
        
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
    }

    // Set the question to user for generating result
    func setQuestionViewController () {
        DataController.setQuestionAndChoice()
        DataController.setQuestionViewControllers()
    }
    
    // Set login button
    func setLoginView () {
        loginView = FBSDKLoginButton()
        loginView.frame = CGRectMake(8, 0, self.view.frame.width - margin*2, elementHeight)
        loginView.center.x = CGRectGetMidX( self.view.frame )
        loginView.center.y = CGRectGetMaxY( self.view.frame ) + CGRectGetMaxY( self.loginView.frame )
        loginView.layer.cornerRadius = 6
        loginView.layer.masksToBounds = true
        
        loginView.readPermissions = permissions
        loginView.delegate = self
        
        self.view.addSubview(loginView)
        
        UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.TransitionNone, animations: {
            self.loginView.center.y = CGRectGetMaxY( self.view.frame ) - self.elementHeight/2 - self.margin
            }, completion: nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}

// MARK: Facebook SDKs method
extension LoginViewController {
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if (error != nil) {
            return
        }
        else if result.isCancelled {
            return
        }
        else {
            self.userLoggedIn()
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("User did log out")
    }
}


// MARK: - Utility methods
extension UIViewController {
    
    // Get the size of device
    
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