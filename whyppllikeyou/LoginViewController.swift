//
//  ViewController.swift
//  WhyDoPeopleLikeYou
//
//  Created by KHUN NINE on 6/23/15.
//  Copyright (c) 2015 KHUN NINE. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate, UINavigationControllerDelegate, UIAlertViewDelegate {
    
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
        setBackgroundImageView(self.view, imagePath: "main_background")
        setQuestionViewController()
        setNotificationCenter()
    }
    
    override func viewWillAppear(animated: Bool) {
        UserLogged.trackScreen("Login view")
    }
    
    override func viewDidAppear(animated: Bool) {
        if (!Reachability.isConnectedToNetwork()) {
            self.showAlertMessage()
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

    // Set the question to user for generating result
    func setQuestionViewController () {
        DataController.setQuestionAndChoice()
        DataController.setQuestionViewControllers()
    }
    
    // Set login button
    func setLoginView () {
        loginView = FBSDKLoginButton()
        loginView.frame = CGRectMake(8, 0, self.view.frame.width * 0.9, elementHeight)
        loginView.center.x = CGRectGetMidX( self.view.frame )
        loginView.center.y = CGRectGetMaxY( self.view.frame ) + CGRectGetMaxY( self.loginView.frame )
        loginView.layer.cornerRadius = 6
        loginView.layer.masksToBounds = true
        
        loginView.readPermissions = permissions
        loginView.delegate = self
        
        self.view.addSubview(loginView)
        
        UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.TransitionNone, animations: {
            self.loginView.center.y = CGRectGetMaxY( self.view.frame ) * 0.65
            }, completion: nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
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
    
    // UIAlert view delegate
    func showAlertMessage () {
        let myAlert = UIAlertView(title: "AlertView", message: "No internet connection", delegate: nil, cancelButtonTitle: "Try agian")
        myAlert.delegate = self
        myAlert.show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        self.viewDidAppear(true)
    }
}