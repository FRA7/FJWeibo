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
    var source: String?{
        didSet{
            //1.判断来源是否有值
            guard let source = source where source != "" else{
                return
            }
            //2.截取字符串
            //2.1获取截取的其实位置
            let startIndex = (source as NSString).rangeOfString(">").location + 1
            //2.2获取截取的字符串长度
            let length = (source as NSString).rangeOfString("</").location - startIndex
            //2.3截取字符串
            sourceText = "来自 " + (source as NSString).substringWithRange(NSRange(location: startIndex, length: length))
        }
    }
    ///来源显示内容
    var sourceText: String?
    
    ///创建时间显示字符串
    var creatAtTimeString: String?{
        guard let creatAt = created_at else{
            return ""
        }
        return NSDate.creatTimeString(creatAt)
    }
    
    ///用户信息
    var user: User?
    
    //MARK: - 自定义构造函数
    init(dict: [String: AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
        
    }
    //重写为定义参数方法,防止报错
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
        
    }

}
