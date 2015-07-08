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
    
    var startButton: UIButton!
    var profileImageView: UIImageView!
    var userFirstNameLabel: UITextField!
    
    var imagePicker = UIImagePickerController()
    var mediaSelected = ""
    
    override func viewDidLoad() {
        
        setUserDisplayPhoto()
        setUserFirstName()
        setBackground()
        setObservers()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        setStartButton()
        userFirstNameLabel.becomeFirstResponder()
    }
}

// MARK: Setter methods

extension StartViewController {
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return UIStatusBarStyle.LightContent
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
        profileImageView.center.y = self.view.center.y * 0.75
        
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        profileImageView.layer.borderWidth = 3
        profileImageView.layer.borderColor = UIColor.appCreamColor().CGColor
        profileImageView.clipsToBounds = true
        
        self.view.addSubview(profileImageView)
    }
    
    func setUserFirstName () {
        
        userFirstNameLabel = UITextField(frame: CGRectMake(0, 0, self.view.frame.width - 16, 44))
        userFirstNameLabel.delegate = self
        userFirstNameLabel.text = DataController.userFirstNameText
        userFirstNameLabel.textAlignment = NSTextAlignment.Center
        userFirstNameLabel.textColor = UIColor.whiteColor()
        userFirstNameLabel.backgroundColor = UIColor(white: 0, alpha: 0.2)
        userFirstNameLabel.layer.cornerRadius = 6
        userFirstNameLabel.layer.borderColor = UIColor.appBrownColor().CGColor
        userFirstNameLabel.layer.borderWidth = 1
        userFirstNameLabel.returnKeyType = UIReturnKeyType.Done
        userFirstNameLabel.center.x = self.view.center.x
        userFirstNameLabel.center.y = self.profileImageView.center.y + self.profileImageView.frame.width/2 + userFirstNameLabel.frame.height
        
        
        self.view.addSubview( userFirstNameLabel )
    }
    
    func setStartButton () {

        if (startButton == nil) {
        
            startButton = UIButton(frame: CGRectMake(0, 0, self.view.frame.width - 16, 44))
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

// MARK: Controller methods

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
        
        self.view.endEditing(true)
        
        UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.TransitionNone, animations: {
            self.startButton.center.y = self.view.frame.height + 44
            self.startButton = nil
            }, completion: { (finished: Bool) in
                DataController.getStart(self)
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
            setUserDisplayPhoto()
            
            picker.dismissViewControllerAnimated(true, completion: nil)
        }
        
        self.mediaSelected = ""
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    internal func keyboardWillShow(notification: NSNotification) {
        
        self.view.frame.origin.y -= self.view.frame.height * 0.175
        
        startButton.center.y += self.view.frame.height * 0.175
    }
    
    // Handle keyboard hide changes
    internal func keyboardWillHide(notification: NSNotification) {
        
        self.view.frame.origin.y += self.view.frame.height * 0.175
        
        startButton.center.y -= self.view.frame.height * 0.175

    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        DataController.userFirstNameText = userFirstNameLabel.text
    }

}