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
    
    private var fetchResult:PHFetchResult!
    
    func result()->PHFetchResult{
        if self.fetchResult != nil {
            return self.fetchResult
        }
        self.stopCachingImagesForAllAssets()
        
        let options:PHFetchOptions = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        self.fetchResult = PHAsset.fetchAssetsWithOptions(options)
        
        return self.fetchResult
        
    }
}
