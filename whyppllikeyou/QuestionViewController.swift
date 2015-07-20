//
//  QuestionViewController.swift
//  WhyDoPeopleLikeYou
//
//  Created by KHUN NINE on 6/30/15.
//  Copyright (c) 2015 KHUN NINE. All rights reserved.
//

import Foundation
import UIKit

class QuestionViewController: UIViewController {
    
    let margin: CGFloat = 8
    let elementHeight: CGFloat = 44
    
    var questionNo: Int = 0
    
    var resultImageView: UIImageView!
    
    var question: UILabel!
    var choices = [String]()
    var choiceView: UIView!
}


// MARK: View life cycle
extension QuestionViewController {
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.clearColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        screenTracking()
    }
}

// MARK: - Google Analytic tracking
extension QuestionViewController {
    
    func screenTracking () {
        var tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "QuestionViewController \(questionNo)")
        
        var builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
}


// MARK: Set and generate choices
extension QuestionViewController {
    
    func generateChoice (position: CGFloat) {
        
        let buttonWidth  : CGFloat = CGRectGetMaxX( self.view.frame ) * 0.75
        let buttonHeight : CGFloat = 66
        
        let margin: CGFloat = 8
        let buttonMargin: CGFloat = buttonHeight + margin
        
        for (var i=0 ; i<choices.count ; i++) {
            
            var yPosition = position + (buttonMargin * CGFloat(i))
            var frame = CGRectMake(0, yPosition, buttonWidth ,buttonHeight )
            
            var button = makeButton(i, frame: frame)
            
            self.view.addSubview(button)
            
        }
    }
    
    func makeButton (index: Int, frame: CGRect) -> UIButton {
        
        var button = UIButton(frame: frame)
        button.titleLabel?.font = UIFont(name: "SukhumvitSet-Medium", size: 18)
        button.center.x = self.view.center.x
        button.setTitleColor(UIColor(white: 0.2, alpha: 1), forState: .Normal)
        button.setTitleColor(UIColor(white: 0.5, alpha: 1), forState: .Highlighted)
        button.backgroundColor = UIColor(white: 1, alpha: 1)
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.lightGrayColor().CGColor
        button.layer.borderWidth = 1
        button.setTitle( choices[index], forState: .Normal)
        button.addTarget(self, action: "choiceButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        button.tag = index

        return button
    }
    
    func choiceButtonClick (sender: UIButton!) {
        
        DataController.summation = DataController.summation + sender.tag
        println(DataController.summation)
        
        if (questionNo == DataController.questions.count - 1) {
            
            SwiftSpinner.show("กำลังประมวลผล", animated: true)
            
            let delay = 3 * Double(NSEC_PER_SEC)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue()) {
                
                SwiftSpinner.hide(completion: {
                    
                    var viewController = ResultViewController()
                    viewController.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
                    self.presentViewController(viewController, animated: true, completion: nil)
                })
                
            }
        }
        else {
            
            var viewController = DataController.list_questionViewController[ questionNo + 1 ]
            viewController.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
            self.presentViewController(viewController, animated: true, completion: nil)
        }
    }
}

// MARK: Set status bar 

extension QuestionViewController {
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}


// MARK: Setter methods
extension QuestionViewController {
    
    func setQuestionNumber (number: Int) {
        self.questionNo = number
    }
    
    func setQuestionPhoto () {
        
        var imageString = "q\(questionNo+1).jpg"
        var image = UIImage(named: imageString)
        
        resultImageView = UIImageView(image: image)
        resultImageView.frame = CGRect(x: 0, y: 0, width: CGRectGetMidX(self.view.frame)-10, height: CGRectGetMidX(self.view.frame)-10)
        resultImageView.center.x = CGRectGetMidX(self.view.frame)
        resultImageView.center.y = CGRectGetMaxY(self.view.frame) * 0.225
        resultImageView.layer.zPosition    = 3
        resultImageView.layer.borderWidth  = 4
        resultImageView.layer.borderColor  = UIColor.whiteColor().CGColor
        resultImageView.layer.cornerRadius = resultImageView.frame.width/2
        resultImageView.clipsToBounds = true
        
        self.view.addSubview( resultImageView )
    }
    
    func setQuestionLabel (questionText: String) {
        
        question = UILabel(frame: CGRectMake(0, 0, CGRectGetMaxX( self.view.frame ) * 0.8, 100))
        question.font = UIFont(name: "SukhumvitSet-Medium", size: 18)
        question.center.x = self.view.center.x
        question.center.y = self.view.frame.height * 0.435
        question.numberOfLines = 0
        question.textAlignment = NSTextAlignment.Center
        question.text = questionText
        
        self.view.addSubview(question)
    }
    
    
    func addChoice (newChoice: String) {
        
        choices.append( newChoice )
    }
    
    func setChoicesLabels () {
        
        let yPositionFirstChoice = self.view.frame.height * 0.5
        generateChoice( yPositionFirstChoice )
    }
    
    func setContentBackgroundImageView () {
        
        setContentBackgroundImage_Style1()
        // Uncomment the like below to change the content background image style
        // setContentBackgroundImage_Style2()
    }
    
    func setContentBackgroundImage_Style2 () {
        
         setContentBackgroundImage()
         setCoverBackgroundImage()
         setBlurBackgroundImage()
    }
    
    func setContentBackgroundImage_Style1 () {
        
        var imageView = UIImageView(image: UIImage(named: "q\(questionNo+1).jpg"))
        imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - margin * 2, height: CGRectGetMaxY(self.view.frame) - margin*2)
        imageView.layer.cornerRadius = 0
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
        
        let blurEffect: UIBlurEffect = UIBlurEffect(style: .Light)
        let blurView: UIVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = imageView.frame
        blurView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        // Set image over layer
        var gradient: CAGradientLayer = CAGradientLayer(layer: imageView.layer)
        gradient.frame = imageView.frame;
        
        // Add colors to layer
        var startColor: UIColor   = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
        var endColor: UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
        gradient.colors = NSArray(objects: startColor.CGColor, endColor.CGColor) as [AnyObject]
        
        var clipper = UIImageView(frame: CGRect(x: margin, y: margin, width: self.view.frame.width - margin * 2, height: self.view.frame.height - margin*2))
        clipper.layer.cornerRadius = 8
        clipper.addSubview(imageView)
        clipper.addSubview(blurView)
        clipper.layer.addSublayer(gradient)
        clipper.clipsToBounds = true
        
        self.view.addSubview( clipper )
    }
    
    func setContentBackgroundImage () {
        
        // defind the top margin
        let statusBarHeight: CGFloat = 20
        let topMargin: CGFloat = margin
        
        // Create a shape
        var contentBackgroundImageShape = CAShapeLayer()
        contentBackgroundImageShape.frame = CGRect(x: margin, y: margin, width: self.view.frame.width - margin * 2, height: self.view.frame.height - ( margin + topMargin))
        contentBackgroundImageShape.path = UIBezierPath(roundedRect: contentBackgroundImageShape.bounds, cornerRadius: 6).CGPath
        contentBackgroundImageShape.fillColor = UIColor(white: 1, alpha: 1).CGColor
        contentBackgroundImageShape.strokeColor = UIColor.grayColor().CGColor
        contentBackgroundImageShape.lineWidth = 0.3;
        
        self.view.layer.addSublayer( contentBackgroundImageShape )
        
    }
    
    func setCoverBackgroundImage () {
        
        // Set background image view for each question
        var imageView = UIImageView(image: UIImage(named: "q\(questionNo+1).jpg"))
        imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - margin * 2, height: CGRectGetMaxY(self.view.frame) * 0.25 - margin)
        imageView.layer.cornerRadius = 0
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
        
        // Set blur effect to image view
        let blurEffect: UIBlurEffect = UIBlurEffect(style: .Light)
        let blurView: UIVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = imageView.frame
        blurView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        // Clips image view to bounds
        var clipper = UIImageView(frame: CGRect(x: margin, y: margin, width: self.view.frame.width - margin * 2, height: self.view.frame.height - margin))
        clipper.layer.cornerRadius = 8
        clipper.addSubview(imageView)
        clipper.addSubview(blurView)
        clipper.clipsToBounds = true
        
        self.view.addSubview( clipper )
    }
    
    func setBlurBackgroundImage () {
        
        // Set background image view for each question
        var imageView = UIImageView(image: UIImage(named: "q\(questionNo+1).jpg"))
        imageView.frame = CGRect(x: 0, y: CGRectGetMaxY(self.view.frame) * 0.25 - margin, width: self.view.frame.width - margin * 2, height: CGRectGetMaxY(self.view.frame) - CGRectGetMaxY(self.view.frame) * 0.25 - margin)
        imageView.layer.cornerRadius = 0
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
        
        // Set blur effect to image view
        let blurEffect: UIBlurEffect = UIBlurEffect(style: .ExtraLight)
        let blurView: UIVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = imageView.frame
        blurView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        // Set image over layer
        var gradient: CAGradientLayer = CAGradientLayer(layer: imageView.layer)
        gradient.frame = imageView.frame;
        
        // Add colors to layer
        var startColor:   UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        var fadeInColor:  UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        var centerColor:  UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        var fadeOutColor: UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
        var endColor:     UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
        gradient.colors = NSArray(objects: startColor.CGColor, fadeInColor.CGColor, centerColor.CGColor, fadeOutColor.CGColor, endColor.CGColor) as [AnyObject]
        
        var clipper = UIImageView(frame: CGRect(x: margin, y: margin, width: self.view.frame.width - margin * 2, height: self.view.frame.height - margin))
        clipper.layer.addSublayer( gradient )
        clipper.layer.cornerRadius = 8
        clipper.clipsToBounds = true
        clipper.addSubview(imageView)
        clipper.addSubview(blurView)
        
        self.view.addSubview( clipper )
    }
}

