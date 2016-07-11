//
//  ML+UIViewExtension.swift
//  MLImagePickerController
//
//  Created by 张磊 on 16/3/27.
//  Copyright © 2016年 zhanglei. All rights reserved.
//

import UIKit

var messageLbl:UILabel!

extension UIView{    
    func showWatting(str:String){
        self.userInteractionEnabled = false
        
        let width:CGFloat = 180
        let height:CGFloat = 35
        let x:CGFloat = (self.frame.width - width) * 0.5
        let y:CGFloat = (self.frame.height - height) * 0.5
        
        let messageLblFrame = CGRectMake(x, y, width, height)
        if messageLbl != nil && (CGRectEqualToRect(messageLbl.frame, messageLblFrame) == true) {
            UIView.animateWithDuration(0.35, animations: { () -> Void in
                messageLbl!.alpha = 1.0
            })
        }else {
            messageLbl = UILabel(frame: CGRectMake(x,y,width,height))
            messageLbl.layer.masksToBounds = true
            messageLbl.layer.cornerRadius = 5.0
            messageLbl.textAlignment = .Center
            messageLbl.text = str
            messageLbl.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            messageLbl.textColor = UIColor.whiteColor()
            self.addSubview(messageLbl)
        }
    }
    
    func hideWatting(){
        self.userInteractionEnabled = true
        UIView.animateWithDuration(0.35) { () -> Void in
            messageLbl.alpha = 0.0
        }
    }
}