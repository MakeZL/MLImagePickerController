//  github: https://github.com/MakeZL/UIView-Category
//  author: @email <120886865@qq.com>
//
//  MBIBDesignableExtension.swift
//  IBDesignable
//
//  Created by 张磊 on 15/4/29.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

import UIKit

extension UILabel{
    @IBInspectable var textHexColor: NSString {
        get {
            return "0xffffff";
        }
        set {
            let scanner = NSScanner(string: newValue as String)
            var hexNum = 0 as UInt32
            
            if (scanner.scanHexInt(&hexNum)){
                let r = (hexNum >> 16) & 0xFF
                let g = (hexNum >> 8) & 0xFF
                let b = (hexNum) & 0xFF
                
                self.textColor = UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0)
            }
        }
    }
}

extension UIButton{
    @IBInspectable var textHexColor: NSString {
        get {
            return "0xffffff";
        }
        set {
            let scanner = NSScanner(string: newValue as String)
            var hexNum = 0 as UInt32
            
            if (scanner.scanHexInt(&hexNum)){
                let r = (hexNum >> 16) & 0xFF
                let g = (hexNum >> 8) & 0xFF
                let b = (hexNum) & 0xFF
                
                self.setTitleColor(UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0), forState: .Normal)
            }
        }
    }
}

extension UIView{
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor(CGColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue.CGColor
        }
    }
    
    @IBInspectable var hexRgbColor: NSString {
        get {
            return "0xffffff";
        }
        set {
            
            let scanner = NSScanner(string: newValue as String)
            var hexNum = 0 as UInt32
            
            if (scanner.scanHexInt(&hexNum)){
                    let r = (hexNum >> 16) & 0xFF
                    let g = (hexNum >> 8) & 0xFF
                    let b = (hexNum) & 0xFF
                
                    self.backgroundColor = UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0)
            }
            
        }
    }
    
    @IBInspectable var onePx: Bool {
        get {
            return true
        }
        set {
            if (onePx == true){
                self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 1 / UIScreen.mainScreen().scale)
            }
        }
    }
}