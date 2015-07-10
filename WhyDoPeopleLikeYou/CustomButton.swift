//
//  CustomButton.swift
//  WhyDoPeopleLikeYou
//
//  Created by KHUN NINE on 7/10/15.
//  Copyright (c) 2015 KHUN NINE. All rights reserved.
//

import Foundation

class UICustomButton: UIButton  {
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        var frame: CGRect = self.titleLabel!.frame
        frame.size.height = self.bounds.size.height
        frame.origin.y = self.titleLabel!.frame.origin.y * 0.1
        self.titleLabel!.frame = frame
    }
}