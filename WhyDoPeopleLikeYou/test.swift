//
//  test.swift
//  WhyDoPeopleLikeYou
//
//  Created by KHUN NINE on 7/7/15.
//  Copyright (c) 2015 KHUN NINE. All rights reserved.
//

import Foundation

// MARK: Drawing UIImage

class test: UIViewController {
    override func viewDidAppear(animated: Bool) {
        makeUIImageResult()
    }
}

extension test {
    
    func makeUIImageResult () -> UIImage {
        
        let rectSize: CGSize = CGSizeMake(470, 246)
        
        let resultSize: CGSize = CGSizeMake( rectSize.height-30, rectSize.height-30 )
        let displaySize: CGSize = CGSizeMake(120, 120)
        
        var background: UIImage = UIImage(named: "backgroundColor")!
        var result: UIImage = UIImage(named: "1")!
        var display: UIImage = UIImage(named: "2")!
        
        display = roundedRectImageFromImage(display)
        result = rectImageWithBorder(result)
        
        UIGraphicsBeginImageContext(rectSize);
        
        background.drawInRect(CGRectMake(0, 0, rectSize.width, rectSize.height))
        result.drawInRect(CGRectMake(rectSize.width-resultSize.width-15, rectSize.height-resultSize.height-15, resultSize.width, resultSize.height))
        display.drawInRect(CGRectMake(rectSize.width/4 - displaySize.width/2, rectSize.height/2 - displaySize.height/2, displaySize.width, displaySize.height))
        
        var finalImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext();
        
        let textTitle = "เหตุผลว่าทำไม\n คนถึงชอบคุณ"
        let textName  = "Khemmachart"
        let textCode  = "ฉายาฉายาฉายา"
        let textResult = "Result result result"
        
        finalImage = setText(textTitle, inImage: finalImage, atPoint: CGPoint(x:rectSize.width/4, y:10))
        finalImage = setText(textName,  inImage: finalImage, atPoint: CGPoint(x:rectSize.width/4, y:190))
        finalImage = setText(textCode,  inImage: finalImage, atPoint: CGPoint(x:rectSize.width/4, y:210))
        finalImage = setText(textResult,inImage: finalImage, atPoint: CGPoint(x:rectSize.width-resultSize.width/2-15, y:205))
        
        //Add image to view
        var imageView: UIImageView = UIImageView(frame: CGRectMake(0, 0, rectSize.width, rectSize.height))
        imageView.image = finalImage
        self.view.addSubview( imageView )
        
        return finalImage
    }
    
    func setText (drawText: NSString, inImage: UIImage, atPoint:CGPoint) -> UIImage{
        
        // Setup the font specific variables
        var textColor: UIColor = UIColor.whiteColor()
        var textFont: UIFont = UIFont.systemFontOfSize(18)
        
        //Setup the image context using the passed image.
        UIGraphicsBeginImageContext(inImage.size)
        
        //Setups up the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
        ]
        
        //Put the image into a rectangle as large as the original image.
        inImage.drawInRect(CGRectMake(0, 0, inImage.size.width, inImage.size.height))
        
        var textWidth = UILabel(frame: CGRectZero)
        textWidth.text = drawText as? String
        textWidth.sizeToFit()
        
        // Creating a point within the space that is as bit as the image.
        var rect: CGRect = CGRectMake(atPoint.x - textWidth.frame.width/2, atPoint.y, inImage.size.width, inImage.size.height)
        
        //Now Draw the text into an image.
        textWidth.text!.drawInRect(rect, withAttributes: textFontAttributes)
        
        // Create a new image out of the images we have created
        var newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        
        //And pass it back up to the caller.
        return newImage
        
    }
    
    func roundedRectImageFromImage (image: UIImage) -> UIImage {
        
        var imageResult = image
        
        let borderWidth: CGFloat = 5.0
        var imageViewer = UIImageView(frame: CGRectMake(0, 0, image.size.width, image.size.height))
        
        UIGraphicsBeginImageContextWithOptions(imageViewer.frame.size, false, 0)
        
        let path = UIBezierPath(roundedRect: CGRectInset(imageViewer.bounds, borderWidth / 2, borderWidth / 2), cornerRadius: image.size.width/2)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSaveGState(context)
        // Clip the drawing area to the path
        path.addClip()
        
        // Draw the image into the context
        imageResult.drawInRect(imageViewer.bounds)
        CGContextRestoreGState(context)
        
        // Configure the stroke
        UIColor.appCreamColor().setStroke()
        path.lineWidth = borderWidth
        
        // Stroke the border
        path.stroke()
        
        imageResult = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return imageResult
    }
    
    func rectImageWithBorder (image: UIImage) -> UIImage {
        
        var imageResult = image
        
        let borderWidth: CGFloat = 5.0
        var imageViewer = UIImageView(frame: CGRectMake(0, 0, image.size.width, image.size.height))
        
        UIGraphicsBeginImageContextWithOptions(imageViewer.frame.size, false, 0)
        
        let path = UIBezierPath(roundedRect: CGRectInset(imageViewer.bounds, borderWidth / 2, borderWidth / 2), cornerRadius: 0)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSaveGState(context)
        // Clip the drawing area to the path
        path.addClip()
        
        // Draw the image into the context
        imageResult.drawInRect(imageViewer.bounds)
        CGContextRestoreGState(context)
        
        // Configure the stroke
        UIColor.appCreamColor().setStroke()
        path.lineWidth = borderWidth
        
        // Stroke the border
        path.stroke()
        
        imageResult = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return imageResult
    }
}
