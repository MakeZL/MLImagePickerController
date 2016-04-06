//
//  MLImagePickerQuickView.swift
//  MLImagePickerController
//
//  Created by 张磊 on 16/3/26.
//  Copyright © 2016年 zhanglei. All rights reserved.
//

import UIKit
import PhotosUI

let MLImagePickerMenuHeight:CGFloat = 40

class MLImagePickerQuickView: UIView,
                              UICollectionViewDataSource,
                              UICollectionViewDelegate,
                              UICollectionViewDelegateFlowLayout,
                              MLImagePickerAssetsCellDelegate
{
    
    private var fetchResult:PHFetchResult!
    private var imageManager:MLImagePickerAssetsManger!
    private var photoIdentifiers:Array<String> = []
    private var selectImages:Array<UIImage> = []
    private var listsImages:Array<UIImage> = []
    
    private var collectionView:UICollectionView!
    private var redTagLbl:UILabel!
    private var messageLbl:UILabel!
    private var albumContainerView:UIView!
    
    // MARK: Public
    // <MLImagePickerControllerDelegate>, SelectAssets CallBack
    var delegate:MLImagePickerControllerDelegate?
    // Selected Indentifiers Assets
    var selectIndentifiers:Array<String>! = []
    // Setting Max Multiselect Count
    var selectPickerMaxCount:Int! = 9
    // Scroll Selecte Pickers, Default is YES
    var cancleLongGestureScrollSelectedPicker:Bool! = false
    // picker list count, Default is 50
    var showListsPickerCount:Int! = 50
    // if viewControllerReponse is nil, but not open album.
    var viewControllerReponse:UIViewController?
    
    // Must realize.
    func prepareForInterfaceBuilderAndData() {
        self.setupCollectionView()
    }
    
    func setupCollectionView(){
        
        let albumContainerView:UIView = UIView(frame: CGRectMake(0, self.frame.height, self.frame.width, self.frame.height))
        albumContainerView.backgroundColor = UIColor.whiteColor()
        self.addSubview(albumContainerView)
        self.albumContainerView = albumContainerView
        
        let menuView:UIView = UIView()
        menuView.borderColor = UIColor(red: 231/256.0, green: 231/256.0, blue: 231/256.0, alpha: 1.0)
        menuView.borderWidth = 0.5
        menuView.frame = CGRectMake(0, 0, self.frame.width, MLImagePickerMenuHeight)
        albumContainerView.addSubview(menuView)
        
        if self.viewControllerReponse != nil {            
            let openAlbumBtn = UIButton(frame: CGRectMake(15, 0, 60, MLImagePickerMenuHeight))
            openAlbumBtn.setTitleColor(UIColor(red: 49/256.0, green: 105/256.0, blue: 245/256.0, alpha: 1.0), forState: .Normal)
            openAlbumBtn.titleLabel?.font = UIFont.systemFontOfSize(14)
            openAlbumBtn.setTitle("打开相册", forState: .Normal)
            openAlbumBtn.addTarget(self, action: "openAlbum", forControlEvents: .TouchUpInside)
            menuView.addSubview(openAlbumBtn)
        }
        
        let doneBtn = UIButton(frame: CGRectMake(self.frame.width - MLImagePickerMenuHeight - 15, 0, MLImagePickerMenuHeight, MLImagePickerMenuHeight))
        doneBtn.setTitleColor(UIColor(red: 49/256.0, green: 105/256.0, blue: 245/256.0, alpha: 1.0), forState: .Normal)
        doneBtn.titleLabel?.font = UIFont.systemFontOfSize(14)
        doneBtn.setTitle("完成", forState: .Normal)
        doneBtn.addTarget(self, action: "done", forControlEvents: .TouchUpInside)
        menuView.addSubview(doneBtn)
        
        let redTagLbl = UILabel()
        redTagLbl.hidden = (self.selectIndentifiers.count == 0)
        redTagLbl.text = "\(self.selectIndentifiers.count)"
        redTagLbl.layer.cornerRadius = 8.0
        redTagLbl.layer.masksToBounds = true
        redTagLbl.backgroundColor = UIColor.redColor()
        redTagLbl.textColor = UIColor.whiteColor()
        redTagLbl.font = UIFont.systemFontOfSize(12)
        redTagLbl.textAlignment = .Center
        redTagLbl.frame = CGRectMake(CGRectGetMaxX(doneBtn.frame)-10,4, 16, 16)
        menuView.addSubview(redTagLbl)
        self.redTagLbl = redTagLbl
        
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 0
        
        let collectionView:UICollectionView = UICollectionView(frame: CGRectMake(0, CGRectGetMaxY(menuView.frame), self.frame.width, self.frame.height - MLImagePickerMenuHeight), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.registerNib(UINib(nibName: "MLImagePickerAssetsCell", bundle: nil), forCellWithReuseIdentifier: "MLImagePickerAssetsCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        albumContainerView.addSubview(collectionView)
        self.collectionView = collectionView
        
        self.imageManager = MLImagePickerAssetsManger()
        self.imageManager.stopCachingImagesForAllAssets()
        self.fetchResult = self.imageManager.result()
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.deliveryMode = .HighQualityFormat
        requestOptions.networkAccessAllowed = true
        requestOptions.synchronous = true
        
        let count = self.fetchResult.count > 50 ? 50 : self.fetchResult.count
        
        for (var i = 0; i < count; i++){
            let asset:PHAsset = self.fetchResult[i] as! PHAsset
            self.photoIdentifiers.append(asset.localIdentifier)
            
            self.imageManager.requestImageForAsset(asset, targetSize: CGSizeMake(self.frame.height,self.frame.height), contentMode: .AspectFill, options: requestOptions) { (let image, let info:[NSObject : AnyObject]?) -> Void in
                self.listsImages.append(image!)
                
                if self.selectIndentifiers.contains(asset.localIdentifier) == true {
                    self.selectImages.append(image!)
                }
                
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.albumContainerView.frame = self.bounds
                })
                
                self.collectionView?.reloadData()
                self.collectionView?.layoutIfNeeded()
            }
            
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listsImages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:MLImagePickerAssetsCell = collectionView.dequeueReusableCellWithReuseIdentifier("MLImagePickerAssetsCell", forIndexPath: indexPath) as! MLImagePickerAssetsCell
        
        let asset:PHAsset = self.fetchResult[indexPath.item] as! PHAsset
        cell.delegate = self
        cell.asset = asset
        cell.indexPath = indexPath
        cell.localIdentifier = self.photoIdentifiers[indexPath.item]
        cell.selectButtonSelected = self.selectIndentifiers.contains(cell.localIdentifier)
        cell.isShowVideo = (asset.mediaType == .Video)
        cell.imageV.image = self.listsImages[indexPath.item]
        
        return cell
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let image:UIImage = self.listsImages[indexPath.item]
        let radio:CGFloat = image.size.height / collectionView.frame.height
        
        return CGSize(width: image.size.width / radio, height: collectionView.frame.height)
    }
    
    // MARK: MLImagePickerAssetsCellDelegate
    func imagePickerSelectAssetsCellWithSelected(indexPath: NSIndexPath, selected: Bool) -> Bool {
        let identifier = self.photoIdentifiers[indexPath.item]
        let asset:PHAsset = self.fetchResult[indexPath.item] as! PHAsset
        
        if selected == true {
            if (self.checkBeyondMaxSelectPickerCount() == false){
                return false
            }
            if self.selectIndentifiers.contains(identifier) == false {
                // Insert
                self.selectIndentifiers.append(identifier)
            }else{
                return false;
            }
        }else{
            // Delete
            if selectIndentifiers.contains(identifier) {
                let index = self.selectIndentifiers.indexOf(identifier)
                self.selectImages.removeAtIndex(index!)
            }
            
            let identifierIndex = self.selectIndentifiers.indexOf(identifier)
            self.selectIndentifiers.removeAtIndex(identifierIndex!)
            
            self.redTagLbl.hidden = (self.selectIndentifiers.count == 0)
            self.redTagLbl.text = "\(self.selectIndentifiers.count)"
            
            return true
        }
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.deliveryMode = .HighQualityFormat
        requestOptions.networkAccessAllowed = true
        
        self.imageManager.requestImageForAsset(asset, targetSize: CGSizeMake(100,100), contentMode: .AspectFill, options: requestOptions) { (let image, let info:[NSObject : AnyObject]?) -> Void in
            if image != nil {
                self.selectImages.append(image!)
                
                self.redTagLbl.hidden = (self.selectIndentifiers.count == 0)
                self.redTagLbl.text = "\(self.selectIndentifiers.count)"
            }
        }
        
        return true
    }
    
    private func checkBeyondMaxSelectPickerCount()->Bool{
        if (self.selectIndentifiers.count >= self.selectPickerMaxCount) {
            self.showWatting("选择照片不能超过\(self.selectPickerMaxCount!)张")
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                self.hideWatting()
            })
            return false
        }
        return true
    }
    
    func done(){
        if self.delegate != nil{
            self.delegate?.imagePickerDidSelectedAssets(self.selectImages, assetIdentifiers: self.selectIndentifiers)
        }
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.albumContainerView.frame = CGRectMake(0, self.frame.height, self.albumContainerView.frame.width, self.albumContainerView.frame.height)
            }) { (let flag:Bool) -> Void in
            self.removeFromSuperview()
        }
    }
    
    func openAlbum(){
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.albumContainerView.frame = CGRectMake(0, self.frame.height, self.albumContainerView.frame.width, self.albumContainerView.frame.height)
            }) { (let flag:Bool) -> Void in
                self.removeFromSuperview()
        }
        
        let pickerVc = MLImagePickerController()
        // 回调
        pickerVc.delegate = self.delegate
        // 最大图片个数
        pickerVc.selectPickerMaxCount = 20
        // 默认记录选择的图片
        pickerVc.selectIndentifiers = self.selectIndentifiers
        pickerVc.show(self.viewControllerReponse!)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.albumContainerView == nil{
            self.setupCollectionView()
        }
    }
}
