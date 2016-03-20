//
//  User.swift
//  FJWeibo
//
//  Created by Francis on 16/3/17.
//  Copyright © 2016年 FRAJ. All rights reserved.
//

import UIKit

class User:NSObject {
    
    // MARK:- 属性
    /// 头像的URL地址
    var profile_image_url : String?
    /// 认证的类型
    var verified_type : Int = -1
    /// 昵称
    var screen_name : String?
    /// 会员等级
    var mbrank : Int = 0
    
    
    // MARK:- 构造函数
    init(dict : [String : AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
}