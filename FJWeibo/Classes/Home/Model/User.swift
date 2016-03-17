//
//  User.swift
//  FJWeibo
//
//  Created by Francis on 16/3/17.
//  Copyright © 2016年 FRAJ. All rights reserved.
//

import UIKit

class User:NSObject {
    
    //MARK: - 属性
    
    ///头像的Url地址
    var profile_image_url: String?
    ///认证的类型
    var verified_type: Int  = -1{
        didSet{
            switch verified_type{
            case 0:
                verifiedImage = UIImage(named: "avatar_vip")
            case 2,3,5:
                verifiedImage = UIImage(named: "avatar_enterprise_vip")
            case 220:
                verifiedImage = UIImage(named: "avatar_grassroot")
            default:
                verifiedImage = nil
                
            }
        }
    }
    
    ///认证显示的图标
    var verifiedImage: UIImage?
    
    ///昵称
    var screen_name: String?
    ///会员显示图标
    var vipImage: UIImage?
    ///会员等级
    var mbrank: Int?{
        didSet{
            if mbrank >= 1 && mbrank <= 6 {
                // 1.拼接会员图片名称
                let vipImageName = "common_icon_membership_level\(mbrank)"
                
                // 2.设置会员图片
                vipImage = UIImage(named: vipImageName)
            } else {
                vipImage = nil
            }
        }
    }
    
    
    //MARK: - 构造函数
    init(dict:[String: AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
        
    }
}