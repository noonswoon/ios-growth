//
//  CustomImageView.swift
//  ImageLoaderIndicator
//
//  Created by Rounak Jain on 24/01/15.
//  Copyright (c) 2015 Rounak Jain. All rights reserved.
//

import UIKit


class CustomImageView: UIImageView {
    
    let progressIndicatorView = CircularLoaderView(frame: CGRectZero)
    var urlString: String!
    
    func setImage (#url: String) {
        self.urlString = url
    }
    
    func runProcess () {
        
        addSubview(self.progressIndicatorView)
        progressIndicatorView.frame = bounds
        progressIndicatorView.backgroundColor = UIColor.clearColor()
        progressIndicatorView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        
        let url = NSURL(string: urlString)
        self.sd_setImageWithURL(url, placeholderImage: nil, options: .CacheMemoryOnly , progress: { [weak self](receivedSize, expectedSize) -> Void in
            self!.progressIndicatorView.progress = CGFloat(receivedSize)/CGFloat(expectedSize)
            }) { [weak self](image, error, _, _) -> Void in
                self!.progressIndicatorView.reveal()
        }
    }
}
