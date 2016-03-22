//
//  PKA_CustomView.swift
//  Walk4Health
//
//  Created by Paul Kirk Adams on 3/22/16.
//  Copyright © 2016 Paul Kirk Adams. All rights reserved.
//

import UIKit

class PKA_CustomView: UIView {

    override func awakeFromNib() {
        layer.cornerRadius = 8.0
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 9.0
        layer.shadowOffset = CGSizeMake(0.0, 4.0)
    }
}