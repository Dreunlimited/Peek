//
//  MaterialTextField.swift
//  Peek
//
//  Created by D'Andre Ealy on 1/30/16.
//  Copyright © 2016 D'Andre Ealy. All rights reserved.
//

import UIKit

class MaterialTextField: UITextField {

    override func awakeFromNib() {
        layer.cornerRadius = 2.0
        layer.backgroundColor = UIColor(red: SHAWDOW_COLOR, green: SHAWDOW_COLOR, blue: SHAWDOW_COLOR, alpha: 0.1).CGColor
        layer.borderWidth = 1.0
    }

    //For placeholder
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0)
    }
    
}
