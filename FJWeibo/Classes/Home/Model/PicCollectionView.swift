//
//  PicCollectionView.swift
//  FJWeibo
//
//  Created by Francis on 16/3/19.
//  Copyright © 2016年 FRAJ. All rights reserved.
//

import UIKit
private let picCollectionCellID = "PicViewCellID"
class PicCollectionView: UICollectionView {



    //MARK: - 定义属性
    var picURLs:[NSURL] = [NSURL](){
        didSet{
            reloadData()
        }
    }
    
    
    
    //MARK: - 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clearColor()
        
        self.registerNib(UINib(nibName: "PicCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: picCollectionCellID)
        
        //1.设置数据源
        dataSource = self
        
        //2.设置布局
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        let imageWH = (UIScreen.mainScreen().bounds.width - 2 * edgeMargin - 2 * padding) / 3
        layout.itemSize = CGSize(width: imageWH, height: imageWH)
        layout.minimumInteritemSpacing = padding
        layout.minimumLineSpacing = padding
        
    }

}

extension PicCollectionView:UICollectionViewDataSource{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //1.创建cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(picCollectionCellID, forIndexPath: indexPath) as! PicCollectionViewCell
        
        //2.给cell设置数据
        cell.backgroundColor = UIColor.redColor()
        cell.picURL = picURLs[indexPath.item]
        
        return cell
    }
}

