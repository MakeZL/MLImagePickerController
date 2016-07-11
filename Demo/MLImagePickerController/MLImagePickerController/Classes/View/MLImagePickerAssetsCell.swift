//
//  MLImagePickerAssetsCell.swift
//  MLImagePickerController
//
//  Created by zhanglei on 16/3/15.
//  Copyright © 2016年 zhanglei. All rights reserved.
//
//  issue: https://github.com/MakeZL/MLImagePickerController/issues/new

import UIKit
import PhotosUI

protocol MLImagePickerAssetsCellDelegate {
    func imagePickerSelectAssetsCellWithSelected(indexPath:NSIndexPath,let selected:Bool) -> Bool;
}

class MLImagePickerAssetsCell: UICollectionViewCell {

    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var videoMaskImgV:UIImageView!
    
    var asset:PHAsset!
    var delegate:MLImagePickerAssetsCellDelegate?
    var localIdentifier:String!
    var indexPath:NSIndexPath!
    var isShowVideo:Bool!{ // Default is Hide
        didSet{
            self.videoMaskImgV.hidden = !isShowVideo
        }
    }
    var selectButtonSelected:Bool! {
        didSet{
            if self.selectButton.selected == selectButtonSelected {
                return
            }
            self.selectButton.selected = selectButtonSelected
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let noImage = UIImage.ml_imageFromBundleNamed("zl_icon_image_no") as UIImage
        let yesImage = UIImage.ml_imageFromBundleNamed("zl_icon_image_yes") as UIImage
        
        self.videoMaskImgV.image = UIImage.ml_imageFromBundleNamed("zl_video-play") as UIImage
        self.selectButton.setImage(noImage, forState: .Normal)
        self.selectButton.setImage(yesImage, forState: .Selected)
    }
    
    @IBAction func selectPhoto() {
        if self.delegate != nil {
            let btnSelected = self.delegate?.imagePickerSelectAssetsCellWithSelected(self.indexPath, selected: !self.selectButton.selected)
            if btnSelected == true {
                self.selectButton.selected = !self.selectButton.selected
            }
        }
    }
}
