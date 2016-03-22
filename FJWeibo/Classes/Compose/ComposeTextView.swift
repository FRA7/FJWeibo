//
//  ComposeTextView.swift
//  FJWeibo
//
//  Created by Francis on 16/3/22.
//  Copyright © 2016年 FRAJ. All rights reserved.
//

import UIKit
import SnapKit

class ComposeTextView: UITextView {


    //MARK: - 懒加载属性
     lazy var placeHolderLabel : UILabel = UILabel()
    
    //MARK - 构造函数

    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        
        setupUI()
    }
    
}

extension ComposeTextView{
    
    private func setupUI(){
        
        //1.添加子控件
        addSubview(placeHolderLabel)
        //2.设置frame
        placeHolderLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(8)
            make.leading.equalTo(10)
        }
        //3.设置属性
        placeHolderLabel.font = font
        placeHolderLabel.text = "分享新鲜事"
        placeHolderLabel.textColor = UIColor.lightGrayColor()
        
        self.textContainerInset = UIEdgeInsets(top: 8, left: 7, bottom: 0, right: 7)
    }
}