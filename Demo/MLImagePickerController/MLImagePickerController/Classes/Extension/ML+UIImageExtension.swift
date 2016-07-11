//
//  ML+UIImageExtension.swift
//  MLImagePickerController
//
//  Created by 张磊 on 16/3/27.
//  Copyright © 2016年 zhanglei. All rights reserved.
//

import UIKit

extension UIImage{
    class func ml_imageFromBundleNamed(named:String)->UIImage{
        let image = UIImage(named: "MLImagePickerController.bundle".stringByAppendingString("/"+(named as String)))!
        return image
    }
}