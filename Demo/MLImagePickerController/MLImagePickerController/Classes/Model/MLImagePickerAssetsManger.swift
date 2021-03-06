//
//  MLImagePickerAssetsManger.swift
//  MLImagePickerController
//
//  Created by 张磊 on 16/3/27.
//  Copyright © 2016年 zhanglei. All rights reserved.
//

import UIKit
import PhotosUI

class MLImagePickerAssetsManger: PHCachingImageManager {
    
    private var fetchResult:PHFetchResult<PHAsset>!
    
    func result()->PHFetchResult<PHAsset>{
        if self.fetchResult != nil {
            return self.fetchResult
        }
        self.stopCachingImagesForAllAssets()
        
        let options:PHFetchOptions = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        self.fetchResult = PHAsset.fetchAssets(with: options)
        
        return self.fetchResult
        
    }
}
