//
//  PKA_CustomButton.swift
//  Walk4Health
//
//  Created by Paul Kirk Adams on 3/22/16.
//  Copyright © 2016 Paul Kirk Adams. All rights reserved.
//

import UIKit

class PKA_CustomButton: UIButton {

    override func awakeFromNib() {
        layer.cornerRadius = 18
        layer.borderColor = UIColor.whiteColor().CGColor
        layer.borderWidth = 1.5
    }
}