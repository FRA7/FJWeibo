//
//  HomeTableViewCell.swift
//  FJWeibo
//
//  Created by Francis on 16/3/18.
//  Copyright © 2016年 FRAJ. All rights reserved.
//

import UIKit



class HomeTableViewCell: UITableViewCell {

    var statusViewModel: StatusViewModel?{
        didSet{
            //0.nil校验
            guard let statusViewModel = statusViewModel else{
                return
            }
            //1.设置头像
            iconImageView.sd_setImageWithURL(statusViewModel.iconURL, placeholderImage: UIImage(named: "avatar_default"))
            //2.设置认证图标
            verifiedImageView.image = statusViewModel.verifiedImage
            //3.设置昵称
            screenLameLabel.text = statusViewModel.status?.user?.screen_name
            //4.设置VIP
            vipImageView.image = statusViewModel.vipImage
            //5.设置时间
            timeLabel.text = statusViewModel.creatAtTimeString
            //6.设置来源
            sourceLabel.text = statusViewModel.sourceText
            //7.设置内容
            contentLabel.text = statusViewModel.status?.text
            ///8.设置picCollectionView的宽度高度约束
            let (width,height) = calculatePicCollectionSize(statusViewModel.picURLs.count)
            picCollectionViewWidthCons.constant = width
            picCollectionViewHeightCons.constant = height
            
            
            ///9.设置picCollectionView的picURLs
            picCollectionView.picURLs = statusViewModel.picURLs
            
        }
    }
    
    
    
    //MARK: - 控件属性
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var screenLameLabel: UILabel!
    @IBOutlet weak var verifiedImageView: UIImageView!
    @IBOutlet weak var vipImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var bottomToolView: UIView!
    @IBOutlet weak var picCollectionView: PicCollectionView!
    
    //MARK: - 约束属性
    @IBOutlet weak var contentLabelWidthCons: NSLayoutConstraint!
    @IBOutlet weak var picCollectionViewWidthCons: NSLayoutConstraint!
    @IBOutlet weak var picCollectionViewHeightCons: NSLayoutConstraint!
    
    //MARK: - 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
         contentLabelWidthCons.constant = UIScreen.mainScreen().bounds.width - 2 * edgeMargin
    }
    
}

extension HomeTableViewCell{
    
    private func calculatePicCollectionSize(count: Int) -> (CGFloat, CGFloat){
        //1.如果没有图片
        if count == 0{
            return (0,0)
        }
        
        //2.计算图片的宽度和高度
        let imageWH = (UIScreen.mainScreen().bounds.width - 2 * edgeMargin - 2 * padding) / 3
        
        
        //3.如果为四张图片
        if count == 4{
            let width = 2 * imageWH + padding
            let height = 2 * imageWH + padding
            return (width,height)
        }
        
        //4.其他图片
        //4.1计算行数
        let row = CGFloat((count - 1)/3 + 1)
        //4.2计算宽度和高度
        let width = imageWH * 3 + padding * 2
        let height = row * imageWH + (row - 1) * padding
        return (width,height)
    }
    
    func cellHeight(statusViewModel:StatusViewModel) -> CGFloat{
        //1.给模型对象属性赋值
        self.statusViewModel = statusViewModel
        //2.更新所有约束
        self.layoutIfNeeded()
        //3.返回底部工具栏最大的Y值
        return CGRectGetMaxY(bottomToolView.frame)
    }
}
