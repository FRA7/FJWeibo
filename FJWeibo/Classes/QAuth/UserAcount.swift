//
//  UserAcount.swift
//  FJWeibo
//
//  Created by Francis on 3/13/16.
//  Copyright © 2016 FRAJ. All rights reserved.
//

import UIKit

class UserAccount: NSObject, NSCoding{
    /// 用于调用access_token，接口获取授权后的access token。
    var access_token: String?
    /// access_token的生命周期，单位是秒数。
    var expires_in: Double = -1{
        didSet{
            //根据多少秒过期,自动计算从现在开始的过期时间
            expires_date = NSDate(timeIntervalSinceNow: expires_in)
        }
    }
    ///真正过期的时间
    var expires_date: NSDate?
    
    /// 当前授权用户的UID。
    var uid: String?
    
    ///用户昵称
    var screen_name: String?
    ///用户头像URL字符串
    var avatar_large: String?
    
    static var filePath = "account.plist".cacheDir()
   
    //MARK: - 生命周期方法
    init(dict:[String: AnyObject]) {
        
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    //重写不用属性的方法,防止应用崩溃
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    ///打印对象
    override var description:String{
        get{
            return dictionaryWithValuesForKeys(["access_token", "expires_in", "uid", "expires_date", "screen_name", "avatar_large"]).description
        }
    }
    
    //MARK: - 归档&解档
    /// 从文件中读取一个模型时调用
    required init?(coder aDecoder: NSCoder){
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_in = aDecoder.decodeObjectForKey("expires_in") as! Double
        uid = aDecoder.decodeObjectForKey("uid") as? String
        expires_date = aDecoder.decodeObjectForKey("expires_date") as? NSDate
        screen_name = aDecoder.decodeObjectForKey("screen_name") as? String
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
        
    }
    /// 将对象写入文件时调用
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(expires_in, forKey: "expires_in")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(expires_date, forKey: "expires_date")
        aCoder.encodeObject(screen_name, forKey: "screen_name")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
    }
    
}
