//
//  ComposeTitleView.swift
//  FJWeibo
//
//  Created by Francis on 16/3/22.
//  Copyright © 2016年 FRAJ. All rights reserved.
//

import UIKit
import SnapKit

class ComposeTitleView: UIView {

    //MARK: - 懒加载
    private lazy var postStatusLabel : UILabel = UILabel()
    private lazy var screenNameLabel : UILabel = UILabel()
    
    //MARK: -构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
}

extension ComposeTitleView{
    
    private func setupUI(){
        //1.添加子控件
        addSubview(postStatusLabel)
        addSubview(screenNameLabel)
        //2.设置frame
        postStatusLabel.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.snp_centerX)
            make.top.equalTo(self.snp_top)
        }
        
        screenNameLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(postStatusLabel.snp_bottom).offset(3)
            make.centerX.equalTo(postStatusLabel.snp_centerX)
        }
        
        //3.设置属性
        postStatusLabel.text = "发微博"
        postStatusLabel.font = UIFont.systemFontOfSize(14)
        screenNameLabel.text = UserAccountViewModel.shareInstance.account?.screen_name
        screenNameLabel.font = UIFont.systemFontOfSize(13)
        screenNameLabel.textColor = UIColor.lightGrayColor()
    }
}