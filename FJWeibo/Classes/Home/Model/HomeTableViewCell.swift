//
//  HomeTableViewCell.swift
//  FJWeibo
//
//  Created by Francis on 16/3/18.
//  Copyright © 2016年 FRAJ. All rights reserved.
//

import UIKit

private let edgeMargin:CGFloat = 15

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
    
    @IBOutlet weak var contentLabelWidthCons: NSLayoutConstraint!
    
    
    //MARK: - 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
         contentLabelWidthCons.constant = UIScreen.mainScreen().bounds.width - 2 * edgeMargin
    }
    
}
