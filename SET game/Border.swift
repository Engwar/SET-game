//
//  Border.swift
//  SET game
//
//  Created by Igor Shelginskiy on 4/24/19.
//  Copyright © 2019 Igor Shelginskiy. All rights reserved.
//

import UIKit

@IBDesignable class BorderButton: UIButton {
    @IBInspectable var colorBorder: UIColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1) {
        didSet {
            layer.borderColor = colorBorder.cgColor
        }
    }
    
    @IBInspectable var widthBorder: CGFloat = 8.0 {
        didSet {
            layer.borderWidth = widthBorder
        }
    }
    
    var disable: Bool {
        get{
            return !isEnabled
        }
        set{
            if newValue {
                isEnabled = false
                colorBorder = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            } else {
                isEnabled = true
                colorBorder = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            }
        }
    }
    
    @IBInspectable var radiusCorner: CGFloat = 2.0 {
        didSet {
            layer.cornerRadius = radiusCorner
        }
    }
    
    private func configure() {
        layer.cornerRadius = radiusCorner
        layer.borderWidth = widthBorder
        layer.borderColor = colorBorder.cgColor
        clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
}
