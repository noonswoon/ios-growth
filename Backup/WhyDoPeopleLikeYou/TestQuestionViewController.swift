//
//  TestQuestionViewController.swift
//  WhyDoPeopleLikeYou
//
//  Created by KHUN NINE on 7/10/15.
//  Copyright (c) 2015 KHUN NINE. All rights reserved.
//

import Foundation
import UIKit

class TestQuestionViewController: UIViewController {
    
    let margin: CGFloat = 8
    var question: UILabel!
    let choices: [String] = ["choice1", "choice2", "choice3"]
    var resultImageView: UIImageView!
    
    override func viewDidLoad() {

        setQuestionPhoto()
        setContentBackgroundImageView()
        setBackgroundImageView()
        setChoicesLabels()
        setQuestionLabel("คุณอาบน้ำบ่อยแค่ไหน")
    }
}


extension TestQuestionViewController {
    
    
    func setBackgroundImageView () {
        
        //self.window?.backgroundColor = UIColor.mainColor()
        
        var backgroundImageView = UIImageView(image: UIImage(named: "main_background"))
        backgroundImageView.frame = self.view.frame
        backgroundImageView.contentMode = .ScaleAspectFill
        
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
    }

    
    func setQuestionPhoto () {
        
        var imageString = "q2.jpg"
        
        println(imageString)
        
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
    
    func setContentBackgroundImageView () {
        
        setContentBackgroundImage()
        setCoverBackgroundImage()
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
        
        var imageView = UIImageView(image: UIImage(named: "q4.jpg"))
        imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - margin * 2, height: CGRectGetMaxY(self.view.frame) * 0.25 - margin)
        imageView.layer.cornerRadius = 0
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true

        let blurEffect: UIBlurEffect = UIBlurEffect(style: .Light)
        let blurView: UIVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - margin * 2, height: CGRectGetMaxY(self.view.frame) * 0.26 - margin)
        blurView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        
        var clipper = UIImageView(frame: CGRect(x: margin, y: margin, width: self.view.frame.width - margin * 2, height: self.view.frame.height - margin))
        clipper.layer.cornerRadius = 8
        clipper.addSubview(imageView)
        clipper.addSubview(blurView)
        clipper.clipsToBounds = true
        
        
        
        self.view.addSubview( clipper )
        
    }
    
    func setQuestionLabel (questionText: String) {
        
        question = UILabel(frame: CGRectMake(0, 0, CGRectGetMaxX( self.view.frame ) * 0.75, 100))
        question.center.x = self.view.center.x
        question.center.y = self.view.frame.height * 0.43
        question.numberOfLines = 0
        question.textAlignment = NSTextAlignment.Center
        question.text = questionText
        
        self.view.addSubview(question)
    }
    
    func setChoicesLabels () {
        
        let yPositionFirstChoice = self.view.frame.height * 0.5
        generateChoice( yPositionFirstChoice )
    }
    
    func generateChoice (position: CGFloat) {
        
        let buttonWidth  : CGFloat = CGRectGetMaxX( self.view.frame ) * 0.75
        let buttonHeight : CGFloat = 66
        
        let cornerRadius : CGFloat = 8
        let margin: CGFloat = 8
        let buttonMargin: CGFloat = buttonHeight + margin
        
        for (var i=0 ; i<choices.count ; i++) {
            
            var yPosition = position + (buttonMargin * CGFloat(i))
            var frame = CGRectMake(0, yPosition, buttonWidth ,buttonHeight )
            
            var button = UIButton(frame: frame)
            button.center.x = self.view.center.x
            button.setTitleColor(UIColor(white: 0.2, alpha: 1), forState: .Normal)
            button.setTitleColor(UIColor(white: 0.5, alpha: 1), forState: .Highlighted)
            button.backgroundColor = UIColor(white: 0.9, alpha: 1)
            button.layer.cornerRadius = cornerRadius
            button.layer.borderColor = UIColor.lightGrayColor().CGColor
            button.layer.borderWidth = 1
            button.setTitle( choices[i], forState: .Normal)
            button.addTarget(self, action: "choiceButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
            button.tag = i
            
            self.view.addSubview(button)
            
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
