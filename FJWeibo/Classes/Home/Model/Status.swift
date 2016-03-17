//
//  Status.swift
//  FJWeibo
//
//  Created by Francis on 16/3/17.
//  Copyright © 2016年 FRAJ. All rights reserved.
//

import UIKit

class Status: NSObject {
    //MARK: - 属性
    ///创建时间
    var created_at: String?
    ///微博正文
    var text: String?
    ///微博ID
    var id: Int = 0
    ///来源
    var source: String?   

    ///用户信息
    var user: User?
    
    //MARK: - 自定义构造函数
    init(dict: [String: AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
        //将用户字典转成模型
        if let userDict = dict["user"] as? [String: AnyObject] {
            user = User(dict: userDict)
        }
        
    }
    //重写为定义参数方法,防止报错
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
        
    }

}
