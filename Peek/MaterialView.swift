//
//  MaterialView.swift
//  Peek
//
//  Created by D'Andre Ealy on 1/30/16.
//  Copyright © 2016 D'Andre Ealy. All rights reserved.
//

import UIKit

class MaterialView: UIView {

    override func awakeFromNib() {
        layer.cornerRadius = 2.0
        layer.shadowColor = UIColor(red: SHAWDOW_COLOR, green: SHAWDOW_COLOR, blue: SHAWDOW_COLOR, alpha: 0.5).CGColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSizeMake(0.0, 2.0)
    }

}
