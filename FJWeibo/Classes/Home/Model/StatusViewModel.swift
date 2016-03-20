//
//  StatusViewModel.swift
//  FJWeibo
//
//  Created by Francis on 16/3/17.
//  Copyright © 2016年 FRAJ. All rights reserved.
//

import UIKit

class StatusViewModel {
    
    // MARK:- 属性
    var status : Status?
    
    // MARK:- 自定义构造函数
    init (status : Status) {
        self.status = status
        
        // 1.对来源进行处理
        // 1.判断来源是否有值
        if let source = status.source where status.source != "" {
            // 2.截取字符串
            // 2.1.获取截取的起始位置
            let startIndex = (source as NSString).rangeOfString(">").location + 1
            
            // 2.2.获取截取的长度
            let length = (source as NSString).rangeOfString("</").location - startIndex
            
            // 2.3.截取字符串
            sourceText = "来自 " + (source as NSString).substringWithRange(NSRange(location: startIndex, length: length))
        }
        
        // 2.会员等级
        let mbrank = status.user?.mbrank ?? 0
        if  mbrank >= 1 && mbrank <= 6 {
            // 1.拼接会员图片名称
            let vipImageName = "common_icon_membership_level\(mbrank)"
            
            // 2.设置会员图片
            vipImage = UIImage(named: vipImageName)
        } else {
            vipImage = nil
        }
        
        
        // 3.认证图标
        let type = status.user?.verified_type ?? -1
        switch type {
        case 0:
            verifiedImage = UIImage(named: "avatar_vip")
        case 2, 3, 5:
            verifiedImage = UIImage(named: "avatar_enterprise_vip")
        case 220:
            verifiedImage = UIImage(named: "avatar_grassroot")
        default:
            verifiedImage = nil
        }
        
        // 4.处理头像的URL
        if let urlString = status.user?.profile_image_url {
            iconURL = NSURL(string: urlString)
        }
        
        // 5.处理微博所有的配图
        let picURLDicts = status.pic_urls?.count != 0 ? status.pic_urls : status.retweeted_status?.pic_urls
        if let picURLDicts = picURLDicts{
            for picURLDict in picURLDicts {
                let urlString = picURLDict["thumbnail_pic"] as? String
                let picURL = NSURL(string: urlString ?? "")
                picURLs.append(picURL!)
            }
        }
    }
    
    // MARK:- 对微博数据进行的处理
    /// 微博创建时间的显示字符串
    var createAtString : String? {
        guard let createAt = status?.created_at else {
            return ""
        }
        
        return NSDate.createTimeString(createAt)
    }
    
    /// 来源的显示字符串
    var sourceText : String?
    
    /// 会员显示的图标
    var vipImage : UIImage?
    
    /// 认证显示的图标
    var verifiedImage : UIImage?
    
    /// 头像的URL
    var iconURL : NSURL?
    
    /// 所有的配图对应的NSURL数组
    var picURLs : [NSURL] = [NSURL]()
}
