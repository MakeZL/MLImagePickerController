//
//  MLImagePickerGroupCell.swift
//  MLImagePickerController
//
//  Created by zhanglei on 16/3/15.
//  Copyright © 2016年 zhanglei. All rights reserved.
//
//  issue: https://github.com/MakeZL/MLImagePickerController/issues/new

import UIKit

class MLImagePickerGroupCell: UITableViewCell {

    @IBOutlet weak var assetCountLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var selectedImgV: UIImageView!
    var selectedStatus:Bool! = false {
        didSet{
            self.selectedImgV.hidden = !self.selectedStatus
            self.selectedImgV.image = UIImage.ml_imageFromBundleNamed("zl_star");
        }
    }
    
}
