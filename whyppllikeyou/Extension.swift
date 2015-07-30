//
//  Extension.swift
//  whyppllikeyou
//
//  Created by KHUN NINE on 7/29/15.
//  Copyright (c) 2015 KHUN NINE. All rights reserved.
//

import Foundation

// MARK: - Extension for UIColor
extension UIColor {
    
    class func mainColor () -> UIColor {
        return UIColor(red: 185/255, green: 0/255, blue: 52/255, alpha: 1)
    }
    
    class func appCreamColor () -> UIColor {
        return UIColor(red: 254/255, green: 255/255, blue: 187/255, alpha: 1)
    }
    
    class func appBrownColor () -> UIColor {
        return UIColor(red: 84/255, green: 32/255, blue: 0, alpha: 1)
    }
    
    class func appGreenColor () -> UIColor {
        return UIColor(red: 7/255, green: 89/255, blue: 1/255, alpha: 1)
    }
    
    class func appBlueColor () -> UIColor {
        return UIColor(red: 0, green: 0, blue: 234/255, alpha: 1)
    }
}

// MARK: - Extension for UIViewController
extension UIViewController {
    
    func setBackgroundImageView (view: UIView, imagePath: String) {
        
        var backgroundImageView = UIImageView(image: UIImage(named: imagePath))
        backgroundImageView.frame = view.frame
        backgroundImageView.contentMode = .ScaleAspectFill
        
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
    }
    
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