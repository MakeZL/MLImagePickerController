//
//  MLImagePickerController.swift
//  MLImagePickerController
//
//  Created by zhanglei on 16/3/14.
//  Copyright © 2016年 zhanglei. All rights reserved.
//

import UIKit
import Photos

protocol MLImagePickerControllerDelegate {
    func imagePickerDidSelectedAssets(assets:NSArray, assetIdentifiers:NSArray)
}

class MLImagePickerController:  UIViewController,
                                UICollectionViewDataSource,
                                UICollectionViewDelegate,
                                MLImagePickerAssetsCellDelegate,
                                UITableViewDataSource,
                                UITableViewDelegate
{
    
    var fetchResult:PHFetchResult!
    var collectionView:UICollectionView?
    let CELL_MARGIN:CGFloat = 2
    let CELL_ROW:CGFloat = 3
    var selectIndentifiers:NSMutableArray = []
    let selectImages:NSMutableArray = []
    let photoIdentifiers:NSMutableArray = []
    var groupTableView:UITableView?
    var groupSectionFetchResults:NSMutableArray = []
    var messageLbl:UILabel!
    var delegate:MLImagePickerControllerDelegate?
    var redTagLbl:UILabel!
    var titleBtn:UIButton!
    var AssetGridThumbnailSize:CGSize!
    var imageManager:PHCachingImageManager!
    
    func show(vc:UIViewController!){
        let imagePickerVc = MLImagePickerController()
        imagePickerVc.delegate = self.delegate
        imagePickerVc.selectIndentifiers = selectIndentifiers
        let navigationVc = UINavigationController(rootViewController: imagePickerVc)
        vc.presentViewController(navigationVc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageManager = PHCachingImageManager()
        self.imageManager.stopCachingImagesForAllAssets()
        
        let scale = UIScreen.mainScreen().scale
        let width = (self.view.frame.size.width - CELL_MARGIN * CELL_ROW + 1) / CELL_ROW;
        AssetGridThumbnailSize = CGSizeMake(width * scale, width * scale);
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.setupNavigationBar()
        self.setupCollectionView()
        
        let options:PHFetchOptions = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let result:PHFetchResult = PHAsset.fetchAssetsWithOptions(options)

        let requestOptions = PHImageRequestOptions()
        requestOptions.deliveryMode = .FastFormat
        requestOptions.networkAccessAllowed = true
        self.fetchResult = result
        
        
        for (var i = 0; i < result.count; i++){
            let asset:PHAsset = result[i] as! PHAsset
            self.photoIdentifiers.addObject(asset.localIdentifier)
            
            if self.selectIndentifiers.containsObject(asset.localIdentifier) == true {
                self.imageManager.requestImageForAsset(asset, targetSize: AssetGridThumbnailSize, contentMode: .AspectFill, options: requestOptions) { (let image, let info:[NSObject : AnyObject]?) -> Void in
                    self.selectImages.addObject(image!)
                }
            }
        }
        self.collectionView?.reloadData()
    }
    
    func setupNavigationBar(){
        let titleBtn = UIButton(type: .Custom)
        titleBtn.frame = CGRectMake(0, 0, 200, 44)
        titleBtn.titleLabel?.font = UIFont.systemFontOfSize(16)
        titleBtn.setTitleColor(UIColor.grayColor(), forState: .Normal)
        titleBtn.setTitle("所有图片", forState: .Normal)
        titleBtn.addTarget(self, action: "tappenTitleView", forControlEvents: .TouchUpInside)
        self.navigationItem.titleView = titleBtn
        self.titleBtn = titleBtn
        
        let doneBtn = UIButton(type: .System)
        doneBtn.titleLabel?.font = UIFont.systemFontOfSize(14)
        doneBtn.frame = CGRectMake(0, 0, 30, 44)
        doneBtn.setTitle("完成", forState: .Normal)
        doneBtn.addTarget(self, action: "done", forControlEvents: .TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneBtn)
        
        let redTagLbl = UILabel()
        redTagLbl.hidden = (self.selectIndentifiers.count == 0)
        redTagLbl.text = "\(self.selectIndentifiers.count)"
        redTagLbl.layer.cornerRadius = 8.0
        redTagLbl.layer.masksToBounds = true
        redTagLbl.backgroundColor = UIColor.redColor()
        redTagLbl.textColor = UIColor.whiteColor()
        redTagLbl.font = UIFont.systemFontOfSize(12)
        redTagLbl.textAlignment = .Center
        redTagLbl.frame = CGRectMake(doneBtn.frame.width-8,0, 16, 16)
        doneBtn.addSubview(redTagLbl)
        self.redTagLbl = redTagLbl
    }
    
    func done(){
        if self.delegate != nil{
            self.delegate?.imagePickerDidSelectedAssets(self.selectImages, assetIdentifiers: self.selectIndentifiers)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setupCollectionView(){
        let width = (self.view.frame.size.width - CELL_MARGIN * CELL_ROW + 1) / CELL_ROW;
        
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .Vertical
        collectionViewFlowLayout.minimumInteritemSpacing = 0
        collectionViewFlowLayout.minimumLineSpacing = 2
        collectionViewFlowLayout.itemSize = CGSizeMake(width, width)
        
        let assetsCollectionView = UICollectionView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height), collectionViewLayout: collectionViewFlowLayout)
        assetsCollectionView.registerNib(UINib(nibName: "MLImagePickerAssetsCell", bundle: nil), forCellWithReuseIdentifier: "MLImagePickerAssetsCell")
        assetsCollectionView.backgroundColor = UIColor.clearColor()
        assetsCollectionView.dataSource = self
        assetsCollectionView.delegate = self
        self.view.addSubview(assetsCollectionView)
        self.collectionView = assetsCollectionView
    }
    
    func setupGroupTableView(){
        if (self.groupTableView != nil){
            UIView.animateWithDuration(0.15, animations: { () -> Void in
                self.groupTableView?.alpha = (self.groupTableView?.alpha == 1.0) ? 0.0 : 1.0
            })
            
        }else{
            let groupTableView = UITableView(frame: CGRectMake(0, 64, self.view.frame.width, 300), style: .Plain)
            groupTableView.registerNib(UINib(nibName: "MLImagePickerGroupCell", bundle: nil), forCellReuseIdentifier: "MLImagePickerGroupCell")
            groupTableView.separatorStyle = .None
            groupTableView.alpha = 0.0
            groupTableView.dataSource = self
            groupTableView.delegate = self
            self.view.addSubview(groupTableView)
            self.groupTableView = groupTableView
            
            let options:PHFetchOptions = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            
            let allPhotos:PHFetchResult = PHAsset.fetchAssetsWithOptions(options)
            let smartAlbums:PHFetchResult = PHAssetCollection.fetchAssetCollectionsWithType(.SmartAlbum, subtype: .AlbumRegular, options: nil)
            let userCollections:PHFetchResult = PHCollectionList.fetchTopLevelUserCollectionsWithOptions(nil)
            self.groupSectionFetchResults = [allPhotos, smartAlbums, userCollections]
            
            UIView.animateWithDuration(0.15, animations: { () -> Void in
                self.groupTableView?.alpha = (self.groupTableView?.alpha == 1.0) ? 0.0 : 1.0
            })
        }
    }
    
    func tappenTitleView(){
        self.setupGroupTableView()
    }
    
    // MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.fetchResult.count > 0) ? self.fetchResult.count : 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:MLImagePickerAssetsCell = collectionView.dequeueReusableCellWithReuseIdentifier("MLImagePickerAssetsCell", forIndexPath: indexPath) as! MLImagePickerAssetsCell
        
        
        let asset:PHAsset = self.fetchResult[indexPath.item] as! PHAsset
        
        cell.delegate = self
        cell.indexPath = indexPath
        cell.localIdentifier = self.photoIdentifiers[indexPath.item] as! String
        cell.selectButtonSelected = self.selectIndentifiers.containsObject(cell.localIdentifier)
        cell.isShowVideo = (asset.mediaType == .Video)
        
        self.imageManager.requestImageForAsset(asset, targetSize: AssetGridThumbnailSize, contentMode: .AspectFill, options: nil) { (let image, let info:[NSObject : AnyObject]?) -> Void in
            
            // Set the cell's thumbnail image if it's still showing the same asset.
            if (cell.localIdentifier == asset.localIdentifier) {
                cell.imageV.image = image;
            }
        }
        
        
        return cell
    }
    
    // MARK TableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.groupSectionFetchResults.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            let result:PHFetchResult = self.groupSectionFetchResults[section] as! PHFetchResult
            return result.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let fetchResult:PHFetchResult = self.groupSectionFetchResults[indexPath.section] as! PHFetchResult
        
        let cell:MLImagePickerGroupCell = tableView.dequeueReusableCellWithIdentifier("MLImagePickerGroupCell") as! MLImagePickerGroupCell
        if indexPath.section == 0 {
            cell.titleLbl.text = "所有图片"
            cell.assetCountLbl.text = "\(fetchResult.count)"
        }else{
            let collection:PHAssetCollection = fetchResult[indexPath.row] as! PHAssetCollection
            let result:PHFetchResult = PHAsset.fetchAssetsInAssetCollection(collection, options: nil)
            cell.titleLbl.text = collection.localizedTitle
            cell.assetCountLbl.text = "\(result.count)"
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.setupGroupTableView()
        self.photoIdentifiers.removeAllObjects()
        
        let cell:MLImagePickerGroupCell = tableView.cellForRowAtIndexPath(indexPath) as! MLImagePickerGroupCell
        self.titleBtn.setTitle(cell.titleLbl.text, forState: .Normal)
        
        var fetchResult:PHFetchResult = self.groupSectionFetchResults[indexPath.section] as! PHFetchResult
        
        if indexPath.section != 0 {
            let collection:PHAssetCollection = fetchResult[indexPath.row] as! PHAssetCollection
            fetchResult = PHAsset.fetchAssetsInAssetCollection(collection, options: nil)
        }
        self.fetchResult = fetchResult
        
        for (var i = 0; i < fetchResult.count; i++){
            let asset:PHAsset = fetchResult[i] as! PHAsset
            self.photoIdentifiers.addObject(asset.localIdentifier)
        }
        for (var i = 0; i < fetchResult.count; i++){
            let asset:PHAsset = fetchResult[i] as! PHAsset
            self.photoIdentifiers.addObject(asset.localIdentifier)
        }
        self.collectionView?.reloadData()
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func imagePickerSelectAssetsCellWithSelected(indexPath: NSIndexPath, selected: Bool) {
        let identifier = self.photoIdentifiers[indexPath.item]
        let asset:PHAsset = self.fetchResult[indexPath.item] as! PHAsset
        
        if selected == true {
            // Insert
            self.selectIndentifiers.addObject(identifier)
        }else{
            // Delete
            if selectIndentifiers.containsObject(identifier) {
                let index = self.selectIndentifiers.indexOfObject(identifier)
                self.selectImages.removeObjectAtIndex(index)
            }
            self.selectIndentifiers.removeObject(identifier)
            
            self.redTagLbl.hidden = (self.selectIndentifiers.count == 0)
            self.redTagLbl.text = "\(self.selectIndentifiers.count)"
            
            return
        }
    
        let requestOptions = PHImageRequestOptions()
        requestOptions.deliveryMode = .HighQualityFormat
        requestOptions.networkAccessAllowed = true
        
        self.imageManager.requestImageForAsset(asset, targetSize: AssetGridThumbnailSize, contentMode: .AspectFill, options: requestOptions) { (let image, let info:[NSObject : AnyObject]?) -> Void in
            if image != nil {
                self.selectImages.addObject(image!)
                
                self.redTagLbl.hidden = (self.selectIndentifiers.count == 0)
                self.redTagLbl.text = "\(self.selectIndentifiers.count)"
            }
        }
        
    }
    
    func showWatting(){
        if self.collectionView != nil {
            self.collectionView!.userInteractionEnabled = false
        }
        if self.messageLbl != nil {
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.messageLbl.alpha = 1.0
            })
        }else {
            let width:CGFloat = 100
            let height:CGFloat = 35
            let x:CGFloat = (self.view.frame.width - width) * 0.5
            let y:CGFloat = (self.view.frame.height - height) * 0.5
            let messageLbl:UILabel = UILabel(frame: CGRectMake(x,y,width,height))
            messageLbl.layer.masksToBounds = true
            messageLbl.layer.cornerRadius = 5.0
            messageLbl.textAlignment = .Center
            messageLbl.text = "加载中..."
            messageLbl.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            messageLbl.textColor = UIColor.whiteColor()
            self.view.addSubview(messageLbl)
            self.messageLbl = messageLbl
        }
    }
    
    func hideWatting(){
        self.collectionView!.userInteractionEnabled = true
        UIView.animateWithDuration(0.25) { () -> Void in
            self.messageLbl.alpha = 0.0
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
}
