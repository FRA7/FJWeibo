//
//  Status.swift
//  FJWeibo
//
//  Created by Francis on 16/3/17.
//  Copyright © 2016年 FRAJ. All rights reserved.
//

import UIKit

class Status: NSObject {
    // MARK:- 属性
    /// 创建时间
    var created_at : String?
    /// 微博的ID
    var id : Int = 0
    /// 微博正文
    var text : String?
    /// 来源
    var source : String?
    /// 用户属性
    var user : User?
    /// 所有的配图
    var pic_urls : [[String : AnyObject]]?
    /// 添加转发微博的属性
    var retweeted_status : Status?
    
    // MARK:- 自定义构造函数
    init(dict : [String : AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
        
        // 1.将用户字典转成用户模型对象
        if let userDict = dict["user"] as? [String : AnyObject] {
            user = User(dict: userDict)
        }
        
        // 2.将转发微博的字典转成模型对象
        if let retweetedStatusDict = dict["retweeted_status"] as? [String : AnyObject]{
            retweeted_status = Status(dict: retweetedStatusDict)
        }
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
}
