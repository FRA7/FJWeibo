//
//  PicCollectionView.swift
//  FJWeibo
//
//  Created by Francis on 16/3/19.
//  Copyright © 2016年 FRAJ. All rights reserved.
//

import UIKit
import SDWebImage

class PicCollectionView: UICollectionView {

    // MARK:- 定义属性
    var picURLs : [NSURL] = [NSURL]() {
        didSet {
            // 1.计算对象本身的宽度和高度
            let (width, height) = calculatePicCollectionSize(picURLs.count)
            picCollectionViewWidthCons.constant = width
            picCollectionViewHeightCons.constant = height
            
            // 2.刷新
            reloadData()
        }
    }
    
    // MARK:- 约束的属性
    @IBOutlet weak var picCollectionViewWidthCons: NSLayoutConstraint!
    @IBOutlet weak var picCollectionViewHeightCons: NSLayoutConstraint!
    
    // MARK:- 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 1.设置数据源
        dataSource = self
        
        // 2.设置布局
        //        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        //        let imageWH = (UIScreen.mainScreen().bounds.width - 2 * edgeMargin - 2 * padding) / 3
        //        layout.itemSize = CGSize(width: imageWH, height: imageWH)
        //        layout.minimumInteritemSpacing = padding
        //        layout.minimumLineSpacing = padding
    }
}

extension PicCollectionView {
    private func calculatePicCollectionSize(count : Int) -> (CGFloat, CGFloat) {
        // 1.没有图片
        if count == 0 {
            return (0, 0)
        }
        
        // 2.取出布局
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        
        // 2.一张图片的处理
        if count == 1 {
            // 2.1.取出url对应的字符串
            let urlString = picURLs.last!.absoluteString
            
            // 2.2.取出对应的图片
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(urlString)
            
            // 2.3.设置流水布局
            let width = image.size.width * 2
            let height = image.size.height * 2
            layout.itemSize = CGSize(width: width, height: height)
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            
            // 2.3.返回collectionView的宽度和高度
            return (width, height)
        }
        
        // 2.计算图片的宽度和高度
        let imageWH = (UIScreen.mainScreen().bounds.width - 2 * edgeMargin - 2 * padding) / 3
        layout.itemSize = CGSize(width: imageWH, height: imageWH)
        layout.minimumInteritemSpacing = padding
        layout.minimumLineSpacing = padding
        
        // 3.四张图片
        if count == 4 {
            let width = 2 * imageWH + padding + 1
            let height = 2 * imageWH + padding
            return (width, height)
        }
        
        // 4.其他张图片
        // 4.1.计算行数
        let row = CGFloat((count - 1) / 3 + 1)
        
        // 4.2.计算宽度和高度
        let width = imageWH * 3 + padding * 2
        let height = row * imageWH + (row - 1) * padding
        
        return (width, height)
    }
}

extension PicCollectionView : UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // 1.创建cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PicViewCellID", forIndexPath: indexPath) as! PicCollectionViewCell
        
        // 2.给cell设置数据
        cell.picURL = picURLs[indexPath.item]
        
        return cell
    }
}




class PicCollectionViewCell : UICollectionViewCell {
    // MARK:- 定义属性
    var picURL : NSURL? {
        didSet {
            picImageView.sd_setImageWithURL(picURL, placeholderImage: UIImage(named: "empty_picture"))
        }
    }
    
    // MARK:- 控件属性
    @IBOutlet weak var picImageView: UIImageView!

}

