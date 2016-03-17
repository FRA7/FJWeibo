//
//  StatusViewModel.swift
//  FJWeibo
//
//  Created by Francis on 16/3/17.
//  Copyright © 2016年 FRAJ. All rights reserved.
//

import UIKit

class StatusViewModel {
    
    //MARK: - 属性
    var status: Status?
    
    //MARK: - 构造属性
    init(status: Status){
     self.status = status
        
        //1.来源
        if let source = status.source where status.source != "" {
           
        //1.2.截取字符串
        //1.2.1获取截取的其实位置
        let startIndex = (source as NSString).rangeOfString(">").location + 1
        //1.2.2获取截取的字符串长度
        let length = (source as NSString).rangeOfString("</").location - startIndex
        //1.2.3截取字符串
        sourceText = "来自 " + (source as NSString).substringWithRange(NSRange(location: startIndex, length: length))
        
        }
   
    
        ///2.会员等级
        let mbrank = status.user?.mbrank ?? 0
                if mbrank >= 1 && mbrank <= 6 {
                    // 1.拼接会员图片名称
                    let vipImageName = "common_icon_membership_level\(mbrank)"
                    
                    // 2.设置会员图片
                    vipImage = UIImage(named: vipImageName)
                } else {
                    vipImage = nil
                }
        
    
    
        ///3.认证图标
        let type = status.user?.verified_type ?? -1
                switch type{
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
    
    
    //MARK: - 处理微博数据
    ///创建时间显示字符串
    var creatAtTimeString: String?{
        guard let creatAt = status?.created_at else{
            return ""
        }
        return NSDate.creatTimeString(creatAt)
    }
    
        ///来源显示内容
        var sourceText: String?
        /// 会员显示的图标
        var vipImage : UIImage?
        /// 认证显示的图标
        var verifiedImage : UIImage?
}
