//
//  IBInspector.swift
//  Ninja Notes
//
//  Created by Apple on 29/07/23.
//

import UIKit

@IBDesignable

class CustomView:UIView{
    
    @IBInspectable var isSquared:Bool = false
    
    @IBInspectable var cornerRadius:CGFloat = 0 {
        didSet{
            self.layer.cornerRadius = 0
            self.layer.cornerRadius = cornerRadius
        }
    }
    @IBInspectable var makeViewCircle:Bool = false{
        didSet{
            self.layer.cornerRadius = 0
            if isSquared {
                self.layer.cornerRadius = self.frame.height/2
            }
        }
    }
    @IBInspectable  var backgroundColorAlpha: CGFloat = 1{
        didSet{
            self.backgroundColor = backgroundColor?.withAlphaComponent(backgroundColorAlpha)
        }
    }
}

@IBDesignable
class CustomButton:UIButton{
    
    @IBInspectable var isSquared:Bool = false
    
    @IBInspectable var cornerRadius:CGFloat = 0 {
        didSet{
            self.layer.cornerRadius = 0
            self.layer.cornerRadius = cornerRadius
        }
    }
    @IBInspectable var makeButtonCircle:Bool = false{
        didSet{
            self.layer.cornerRadius = 0
            if isSquared {
                self.layer.cornerRadius = self.frame.height/2
                
            }
        }
    }
    @IBInspectable  var backgroundColorAlpha: CGFloat = 1{
        didSet{
            self.backgroundColor = backgroundColor?.withAlphaComponent(backgroundColorAlpha)
        }
    }
}

@IBDesignable
class CustomImageView:UIImageView{
    
    @IBInspectable var isSquared:Bool = false
    
    @IBInspectable var cornerRadius:CGFloat = 0 {
        didSet{
            self.layer.cornerRadius = 0
            self.layer.cornerRadius = cornerRadius
        }
    }
    @IBInspectable var makeImageCircle:Bool = false{
        didSet{
            self.layer.cornerRadius = 0
            if isSquared {
                self.layer.cornerRadius = self.frame.height/2
                
            }
        }
    }
    @IBInspectable  var backgroundColorAlpha: CGFloat = 1{
        didSet{
            self.backgroundColor = backgroundColor?.withAlphaComponent(backgroundColorAlpha)
        }
    }
}
