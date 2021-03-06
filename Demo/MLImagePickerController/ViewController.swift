//
//  ViewController.swift
//  MLImagePickerController
//
//  Created by zhanglei on 16/3/14.
//  Copyright © 2016年 zhanglei. All rights reserved.
//
//  issue: https://github.com/MakeZL/MLImagePickerController/issues/new

import UIKit
import PhotosUI

class ViewController: UIViewController,
                      MLImagePickerControllerDelegate,
                      UITableViewDataSource,
                      UITableViewDelegate
{

    @IBOutlet weak var tableView: UITableView!
    var assets:Array<UIImage>? = []
    var assetIdentifiers:Array<String>? = []
    var phImageFileUrls:Array<NSURL>? = []
    var quickView:MLImagePickerQuickView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.assets != nil ? self.assets!.count : 0
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.imageView!.image = self.assets![indexPath.item]
        return cell!
    }
    
    /**
     CallBack
     
     - parameter assets:           Array<UIImage>
     - parameter assetIdentifiers: Array<String>
     */
    func imagePickerDidSelectedAssets(assets: Array<UIImage>, assetIdentifiers: Array<String>, phImageFileUrls: Array<NSURL>) {
        self.assets = assets
        self.assetIdentifiers = assetIdentifiers
        self.phImageFileUrls = phImageFileUrls
        self.tableView.reloadData()
    }

    /**
    *  @IBAction
    */
    @IBAction func selectPhoto() {
        let pickerVc = MLImagePickerController()
        // 回调
        pickerVc.delegate = self
        // 最大图片个数
        pickerVc.selectPickerMaxCount = 20
        // 默认记录选择的图片
        pickerVc.selectIndentifiers = self.assetIdentifiers!
        pickerVc.show(vc: self)
    }
    
    @IBAction func quick() {
        self.quickView?.removeFromSuperview()
        
        let quickView = MLImagePickerQuickView(frame: CGRect(x:0, y:self.view.frame.height - 250, width:self.view.frame.width, height:250))
        quickView.delegate = self
        // 最大图片个数
        quickView.selectPickerMaxCount = 20
        // 默认记录选择的图片
        quickView.selectIndentifiers = self.assetIdentifiers
        // 如果不传的话，预览不能打开相册
        quickView.viewControllerReponse = self
        // 准备工作
        quickView.prepareForInterfaceBuilderAndData()
        self.view.addSubview(quickView)
        self.quickView = quickView
    }
}
