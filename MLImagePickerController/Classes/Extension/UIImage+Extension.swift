//
//  UIImage+Extension.swift
//  MLImagePickerController
//
//  Created by zhanglei on 16/3/15.
//  Copyright © 2016年 zhanglei. All rights reserved.
//

import UIKit

class ZLPhotoBundleClass: NSObject {
    func ml_imageFromBundleNamed(named:String)->UIImage{
        return UIImage(named: "ZLPhotoLib.bundle".stringByAppendingString("/"+(named as String)))!
    }
}

