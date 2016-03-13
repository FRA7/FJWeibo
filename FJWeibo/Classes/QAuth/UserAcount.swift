//
//  UserAcount.swift
//  FJWeibo
//
//  Created by Francis on 3/13/16.
//  Copyright © 2016 FRAJ. All rights reserved.
//

import UIKit

class UserAccount: NSObject{
    /// 用于调用access_token，接口获取授权后的access token。
    var access_token: String?
    /// access_token的生命周期，单位是秒数。
    var expires_in: Int = -1
    /// 当前授权用户的UID。
    var uid: String?
   
    //MARK: - 生命周期方法
    init(dict:[String: AnyObject]) {
        
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    /// 从文件中读取一个模型时调用
    required init?(coder aDecoder:NSCoder){
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_in = aDecoder.decodeObjectForKey("expires_in") as! Int
        uid = aDecoder.decodeObjectForKey("uid") as? String
     
    }
    /// 将对象写入文件时调用
    func encodeWithCoder(aCoder : NSCoder){
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(expires_in, forKey: "expires_in")
        aCoder.encodeObject(uid, forKey: "uid")
    }
    
    ///打印对象
    override var description:String{
        let keys = ["access_token","expires_in","uid"]
        let dict = dictionaryWithValuesForKeys(keys)
        return "\(dict)"
    }
    
    //MARK: - 内部控制方法
    ///写入对象
    func saveUserAccount() -> Bool{
        //1.获取系统路径
        let path = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).last!
        //2.拼接路径
        let filePath = (path as NSString).stringByAppendingPathComponent("account.plist")
        //3.写入对象
        return NSKeyedArchiver.archiveRootObject(self, toFile: filePath)
    }
    
    ///读取写入的对象
    class func loadUserAccount() ->UserAccount?{
        //1.获取系统路径
        let path = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).last!
        //2.拼接路径
        let filePath = (path as NSString).stringByAppendingPathComponent("account.plist")
        //3.写入对象
        return NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? UserAccount
    }
    
    
    ///判断用户是否登陆
    class func userLogon() -> Bool{
    
        return loadUserAccount() != nil
    }
    
}
