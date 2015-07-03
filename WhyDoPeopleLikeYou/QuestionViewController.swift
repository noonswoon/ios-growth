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
    
    var questionNo: Int!
    
    var question: UILabel!
    var choices = [String]()
    var choiceView: UIView!
    

    
    override func viewDidLoad() {
        
        view.backgroundColor = UIColor.clearColor()
        setContentBackgroundImageView()

    }
    
    func setQuestionNumber (number: Int) {
        self.questionNo = number
    }
    
    func setQuestionLabel (questionText: String) {
        
        question = UILabel(frame: CGRectMake(0, 0, CGRectGetMaxX( self.view.frame ) * 0.75, 100))
        question.center.x = self.view.center.x
        question.center.y = self.view.frame.height * 1/4 - 50
        question.numberOfLines = 0
        question.textAlignment = NSTextAlignment.Center
        question.text = questionText
        
        self.view.addSubview(question)
    }
    
    func addChoice (newChoice: String) {
        
        choices.append( newChoice )
    }
    
    func setChoicesLabels () {
        
        let yPositionFirstChoice = self.view.frame.height * 1/3 - 50
        generateChoice( yPositionFirstChoice )
    }
    
    func setContentBackgroundImageView () {
        
        // defind the top margin
        
        let statusBarHeight: CGFloat = 20
        let topMargin: CGFloat = statusBarHeight + margin
        
        // Create a shape
        
        var contentBackgroundImageShape = CAShapeLayer()
        contentBackgroundImageShape.frame = CGRect(x: margin, y: topMargin, width: self.view.frame.width - margin * 2, height: self.view.frame.height - ( margin * 2 + topMargin) - elementHeight)
        contentBackgroundImageShape.path = UIBezierPath(roundedRect: contentBackgroundImageShape.bounds, cornerRadius: 6).CGPath
        contentBackgroundImageShape.fillColor = UIColor(white: 1, alpha: 1).CGColor
        contentBackgroundImageShape.strokeColor = UIColor.grayColor().CGColor
        contentBackgroundImageShape.lineWidth = 0.3;
        
        self.view.layer.addSublayer( contentBackgroundImageShape )
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
    
    
    func choiceButtonClick (sender: UIButton!) {

        println(choices[sender.tag])
        
        DataController.summation += sender.tag - 1
        
        if (questionNo == DataController.questions.count - 1) {
            
            var viewController = ResultViewController()
            viewController.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
            self.presentViewController(viewController, animated: true, completion: nil)
        }
        else {
        
            var viewController = DataController.list_questionViewController[ questionNo + 1 ]
            viewController.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
            self.presentViewController(viewController, animated: true, completion: nil)
        }
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}

