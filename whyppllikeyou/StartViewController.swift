//
//  LoadUserInformationViewController.swift
//  WhyDoPeopleLikeYou
//
//  Created by KHUN NINE on 7/6/15.
//  Copyright (c) 2015 KHUN NINE. All rights reserved.
//

import Foundation
import UIKit

class StartViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    var photoLabel: UILabel!
    var nameLabel: UILabel!
    var startButton: UIButton!
    var profileImageView: UIImageView!
    var profileImageViewMark : UIImageView!
    var userFirstNameTextField: UITextField!
    
    var imagePicker = UIImagePickerController()
    var mediaSelected = ""
    
    var firstTime = true
}

// MARK: - View life cycle 

extension StartViewController {
    
    override func viewDidLoad() {
        setUserDisplayPhoto()
        setUserDisplayMark()
        setNameLabel()
        setUserFirstName()
        setBackground()
        setObservers()
        setPhotoLabel()
    }
    
    override func viewWillAppear(animated: Bool) {
        screenTracking()
    }
    
    override func viewDidAppear(animated: Bool) {
        setStartButton()
        UserLogged.setLogObject()
        
        if (firstTime) {
            
            userFirstNameTextField.becomeFirstResponder()
            firstTime = false
        }
    }
}

// MARK: - Google Analytic tracking

extension StartViewController {
    
    func screenTracking () {
        var tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "StartViewController")
        
        var builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
}

// MARK: - Setter methods

extension StartViewController {
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func setBackground () {
        var backgroundImageView = UIImageView(image: UIImage(named: "main_background2"))
        backgroundImageView.frame = view.frame
        backgroundImageView.contentMode = .ScaleAspectFill
        
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
    }
    
    func setObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "deviceOrientationDidChange:", name: UIDeviceOrientationDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name:UIKeyboardWillHideNotification, object: nil)
    }

    func setUserDisplayPhoto () {
        profileImageView = UIImageView(image: DataController.userProfileImage)
        
        profileImageView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        profileImageView.center.x = self.view.center.x
        profileImageView.center.y = self.view.frame.height * 0.3
        profileImageView.contentMode = UIViewContentMode.ScaleAspectFill
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        profileImageView.layer.borderWidth = 3
        profileImageView.layer.borderColor = UIColor.appCreamColor().CGColor
        profileImageView.clipsToBounds = true
        
        self.view.addSubview(profileImageView)
    }

    func setUserDisplayMark () {
        profileImageViewMark = UIImageView(image: UIImage(named: "userProfileImageMark.png"))
        
        profileImageViewMark.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        profileImageViewMark.center.x = self.view.center.x
        profileImageViewMark.center.y = self.view.frame.height * 0.3
        
        profileImageViewMark.layer.cornerRadius = profileImageView.frame.width/2
        profileImageViewMark.clipsToBounds = true
        profileImageViewMark.alpha = 0.5
        
        self.view.addSubview(profileImageViewMark)
    }
    
    func setPhotoLabel () {
        photoLabel = UILabel(frame: CGRectMake(0, 0, self.view.frame.width - 44, 44))
        photoLabel.font = UIFont(name: "SukhumvitSet-Medium", size: 13)
        photoLabel.text = "เปลี่ยนรูป"
        photoLabel.textAlignment = NSTextAlignment.Center
        photoLabel.textColor = UIColor.whiteColor()
        photoLabel.center.x = self.view.center.x
        photoLabel.center.y = self.view.center.y * 0.825
        
        self.view.addSubview( photoLabel )
    }
    
    func setNameLabel () {
        nameLabel = UILabel(frame: CGRectMake(0, 0, self.view.frame.width - 44, 44))
        nameLabel.text = "คุณชื่อไร ?"
        nameLabel.font = UIFont(name: "SukhumvitSet-Medium", size: 13)
        nameLabel.center.x = self.view.center.x
        nameLabel.textColor = UIColor.whiteColor()
        nameLabel.textAlignment = NSTextAlignment.Center
        nameLabel.center.y = self.view.frame.height * 0.53
        
        self.view.addSubview( nameLabel )
    }
    
    func setUserFirstName () {
        userFirstNameTextField = UITextField(frame: CGRectMake(0, 0, self.view.frame.width - 44, 44))
        userFirstNameTextField.delegate = self
        userFirstNameTextField.text = DataController.userFirstNameText
        userFirstNameTextField.font = UIFont(name: "SukhumvitSet-Medium", size: 18)
        userFirstNameTextField.textAlignment = NSTextAlignment.Center
        userFirstNameTextField.textColor = UIColor.whiteColor()
        userFirstNameTextField.backgroundColor = UIColor(white: 0, alpha: 0.2)
        userFirstNameTextField.layer.cornerRadius = 6
        userFirstNameTextField.layer.borderColor = UIColor.appBrownColor().CGColor
        userFirstNameTextField.layer.borderWidth = 1
        userFirstNameTextField.returnKeyType = UIReturnKeyType.Done
        userFirstNameTextField.center.x = self.view.center.x
        userFirstNameTextField.center.y = self.view.frame.height * 0.62

        self.view.addSubview( userFirstNameTextField )
    }
    
    func setStartButton () {
        if (startButton == nil) {
            startButton = UIButton(frame: CGRectMake(0, 0, self.view.frame.width - 44, 44))
            startButton.titleLabel?.font = UIFont(name: "SukhumvitSet-Medium", size: 18)
            startButton.setTitle("เริ่มเลยสิ !", forState: .Normal)
            startButton.setTitleColor( UIColor.blackColor(), forState: .Normal)
            startButton.setTitleColor( UIColor.grayColor(), forState: .Highlighted)
            startButton.center.x = self.view.center.x
            startButton.center.y = CGRectGetMaxY( self.view.frame ) + CGRectGetMaxY( self.startButton.frame )
            startButton.backgroundColor = UIColor.whiteColor()
            startButton.layer.cornerRadius = 6
            startButton.layer.borderColor = UIColor.blackColor().CGColor
            startButton.layer.borderWidth = 1
            startButton.addTarget(self, action: "getStarted", forControlEvents: UIControlEvents.TouchUpInside)
        
            view.addSubview(startButton)
            
            UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.TransitionNone, animations: {
                self.startButton.center.y = CGRectGetMaxY( self.view.frame ) - self.startButton.frame.height/2 - 8
                }, completion: nil)

        }
    
    }
}

// MARK: - Controller methods

extension StartViewController {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField.returnKeyType == UIReturnKeyType.Go) {
            getStarted ()
            return true
        }
        else if (textField.returnKeyType == UIReturnKeyType.Done) {
            self.view.endEditing(true)
            return true
        }
        else {
            return false
        }
    }
    
    func getStarted () {
        self.firstTime = true
        self.view.endEditing(true)
        
        UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.TransitionNone, animations: {
            
            self.startButton.center.y = self.view.frame.height + 44
            self.startButton = nil
            }, completion: { (finished: Bool) in
                DataController.getStartQuestion(self)
        })
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        var touch = touches.first as! UITouch
        var point = touch.locationInView( profileImageView )
        
        if (CGRectContainsPoint( profileImageView.bounds, point)) {
            photoBtnClicked()
        }
        else {
            self.view.endEditing(true)
        }

        super.touchesBegan(touches , withEvent:event)
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
    
    // Used for Both Photo & Video Methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if (self.mediaSelected == "Photo") {
            // Show the temporary image into device screen
            DataController.userProfileImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            self.profileImageView.image = DataController.userProfileImage
            
            picker.dismissViewControllerAnimated(true, completion: nil)
        }
        self.mediaSelected = ""
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    internal func keyboardWillShow(notification: NSNotification) {
        let frameHeight = self.view.frame.height
        if (iPhoneScreenSize() == "3.5") {
            profileImageView.center.y = frameHeight * 0.2
            profileImageViewMark.center.y = frameHeight * 0.2
            photoLabel.center.y = frameHeight * 0.3125
            nameLabel.center.y = frameHeight * 0.39
            userFirstNameTextField.center.y = frameHeight * 0.45
        }
        else if (iPhoneScreenSize() == "4") {
            profileImageView.center.y = frameHeight * 0.2
            profileImageViewMark.center.y = frameHeight * 0.2
            photoLabel.center.y = frameHeight * 0.295
            nameLabel.center.y = frameHeight * 0.39
            userFirstNameTextField.center.y = frameHeight * 0.45
        }
        else if (iPhoneScreenSize() == "4.7") {
            profileImageView.center.y = frameHeight * 0.28
            profileImageViewMark.center.y = frameHeight * 0.28
            photoLabel.center.y = frameHeight * 0.36
            nameLabel.center.y = frameHeight * 0.44
            userFirstNameTextField.center.y = frameHeight * 0.49
            
        }
        else if (iPhoneScreenSize() == "5.5") {
            profileImageView.center.y = frameHeight * 0.28
            profileImageViewMark.center.y = frameHeight * 0.28
            photoLabel.center.y = frameHeight * 0.35
            nameLabel.center.y = frameHeight * 0.44
            userFirstNameTextField.center.y = frameHeight * 0.49
            
        }
        
        nameLabel.alpha = 0
    }
    
    // Handle keyboard hide changes
    internal func keyboardWillHide(notification: NSNotification) {
        let frameHeight = self.view.frame.height
        if (iPhoneScreenSize() == "3.5") {
            profileImageView.center.y = frameHeight * 0.3
            profileImageViewMark.center.y = frameHeight * 0.3
            userFirstNameTextField.center.y = frameHeight * 0.62
            nameLabel.center.y = frameHeight * 0.53
            photoLabel.center.y = frameHeight * 0.4125
        }
        else if (iPhoneScreenSize() == "4") {
            profileImageView.center.y = frameHeight * 0.3
            profileImageViewMark.center.y = frameHeight * 0.3
            userFirstNameTextField.center.y = frameHeight * 0.62
            nameLabel.center.y = frameHeight * 0.53
            photoLabel.center.y = frameHeight * 0.395
        }
        else if (iPhoneScreenSize() == "4.7") {
            profileImageView.center.y = frameHeight * 0.3
            profileImageViewMark.center.y = frameHeight * 0.3
            userFirstNameTextField.center.y = frameHeight * 0.62
            nameLabel.center.y = frameHeight * 0.53
            photoLabel.center.y = frameHeight * 0.38
        }
        else if (iPhoneScreenSize() == "5.5") {
            profileImageView.center.y = frameHeight * 0.3
            profileImageViewMark.center.y = frameHeight * 0.3
            userFirstNameTextField.center.y = frameHeight * 0.62
            nameLabel.center.y = frameHeight * 0.53
            photoLabel.center.y = frameHeight * 0.37
        }
        
        nameLabel.alpha = 1
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        DataController.userFirstNameText = userFirstNameTextField.text
    }

}