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
    

// MARK: Generating result

extension ViewController {
    
    // User information
    
    
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
    
}




// MARK: Utilities

extension ViewController {
    
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


// MARK: Set view elements

extension ViewController {
    
    // Set the background image view (green screen)
    
    func setBackgroundImageView () {
        
        backgroundImageView = UIImageView(image: UIImage(named: "main_background.png"))
        backgroundImageView.frame = view.frame
        backgroundImageView.contentMode = .ScaleAspectFill
        
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
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
        
        // Load user information from Facebook API
        DataController.loadUserProfileImage()
        DataController.loadUserFirstName()
        DataController.loadUserProfile()

        // Start the question to user for generating result
        DataController.setQuestionAndChoice()
        DataController.setQuestionViewControllers()
        DataController.getStart(self)
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

