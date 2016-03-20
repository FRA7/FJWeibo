//
//  UserAcount.swift
//  FJWeibo
//
//  Created by Francis on 3/13/16.
//  Copyright © 2016 FRAJ. All rights reserved.
//

import UIKit

class UserAccount: NSObject, NSCoding{
    // MARK:- 属性
    /// 令牌
    var access_token : String?
    /// 过期秒
    var expires_in : NSTimeInterval = 0 {
        didSet {
            expires_date = NSDate(timeIntervalSinceNow: expires_in)
        }
    }
    /// 用户ID
    var uid : String?
    /// 过期日期
    var expires_date : NSDate?
    
    /// 用户头像的地址
    var avatar_large : String?
    /// 昵称
    var screen_name : String?
    
    // MARK:- 自定义构造函数
    init(dict : [String : AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    // 重写description方法(计算属性)
    override var description : String {
        get {
            return dictionaryWithValuesForKeys(["access_token", "expires_in", "uid", "expires_date", "avatar_large", "screen_name"]).description
        }
    }
    
    // MARK:- 归档&解档
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(expires_date, forKey: "expires_date")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
        aCoder.encodeObject(screen_name, forKey: "screen_name")
    }
    
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        uid = aDecoder.decodeObjectForKey("uid") as? String
        expires_date = aDecoder.decodeObjectForKey("expires_date") as? NSDate
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
        screen_name = aDecoder.decodeObjectForKey("screen_name") as? String
    }
    
}
