//
//  HomeViewCell.swift
//  FJWeibo
//
//  Created by Francis on 16/2/26.
//  Copyright © 2016年 FRAJ. All rights reserved.
//

import UIKit


class HomeViewCell: UITableViewCell {
    // MARK:- 控件属性
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var verifiedImageView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var vipImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var bottomToolView: UIView!
    @IBOutlet weak var picCollectionView: PicCollectionView!
    @IBOutlet weak var retweetedContentLabel: UILabel!
    @IBOutlet weak var retweetedBgView: UIView!
    
    // MARK:- 约束属性
    @IBOutlet weak var contentLabelWidthCons: NSLayoutConstraint!
    @IBOutlet weak var retweetedLabelTopCons: NSLayoutConstraint!
    @IBOutlet weak var picCollectionViewTopCons: NSLayoutConstraint!
    
    // MARK:- 定义模型对象的属性
    var statusViewModel : StatusViewModel? {
        didSet {
            // 1.nil的校验
            guard let statusViewModel = statusViewModel else {
                return
            }
            
            // 2.设置头像
            iconImageView.sd_setImageWithURL(statusViewModel.iconURL, placeholderImage: UIImage(named: "avatar_default"))
            
            // 3.设置认证图标
            verifiedImageView.image = statusViewModel.verifiedImage
            
            // 4.设置昵称
            screenNameLabel.text = statusViewModel.status?.user?.screen_name
            
            // 5.设置VIP图标
            vipImageView.image = statusViewModel.vipImage
            
            // 6.设置时间的Label
            timeLabel.text = statusViewModel.createAtString
            
            // 7.设置来源
            sourceLabel.text = statusViewModel.sourceText
            
            // 8.设置微博正文
            contentLabel.text = statusViewModel.status?.text
            
            
            // 10.设置picCollectionView的picURLs
            picCollectionView.picURLs = statusViewModel.picURLs
            
            //11.设置转发微博的内容
            if statusViewModel.status?.retweeted_status != nil {
                //1).设置转发微博正文
                retweetedContentLabel.text = "@" + (statusViewModel.status?.retweeted_status?.user?.screen_name)! + ": " + (statusViewModel.status?.retweeted_status?.text ?? "")
                //2).修改转发微博的label距离顶部的约束
                retweetedLabelTopCons.constant = 15
                //3).设置转发微博背景显示
                retweetedBgView.hidden = false
                
            }else{
                //1).设置转发微博内容
                retweetedContentLabel.text = nil
                //2).修改转发微博的label距离顶部的约束
                retweetedLabelTopCons.constant = 0
                //3).设置转发微博背景显示
                retweetedBgView.hidden = true
            }
            
            //12.判断是否有图片
            picCollectionViewTopCons.constant = statusViewModel.picURLs.count == 0 ? 0 : 10
        }
    }
    
    // MARK:- 系统回调的函数
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentLabelWidthCons.constant = UIScreen.mainScreen().bounds.width - 2 * edgeMargin
    }
}


// MARK:- 计算函数
extension HomeViewCell {
    func cellHeight(statusViewModel : StatusViewModel) -> CGFloat {
        // 1.给模型对象属性赋值
        self.statusViewModel = statusViewModel
        
        // 2.更新所有的约束
        self.layoutIfNeeded()
        
        // 3.拿到底部工具栏最大的Y值
        return CGRectGetMaxY(bottomToolView.frame)
    }
}
