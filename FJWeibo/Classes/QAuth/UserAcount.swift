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
    
    static var filePath = "account.plist".cacheDir()
   
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
        expires_in = aDecoder.decodeObjectForKey("expires_in") as! Double
        uid = aDecoder.decodeObjectForKey("uid") as? String
        expires_date = aDecoder.decodeObjectForKey("expires_date") as? NSDate
     
    }
    /// 将对象写入文件时调用
    func encodeWithCoder(aCoder : NSCoder){
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(expires_in, forKey: "expires_in")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(expires_date, forKey: "expires_date")
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
//        //1.获取系统路径
//        let path = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).last!
//        //2.拼接路径
//        let filePath = (path as NSString).stringByAppendingPathComponent("account.plist")
        //3.写入对象
        return NSKeyedArchiver.archiveRootObject(self, toFile: UserAccount.filePath)
    }
    
    ///读取写入的对象
    class func loadUserAccount() ->UserAccount?{
//        //1.获取系统路径
//        let path = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).last!
//        //2.拼接路径
//        let filePath = (path as NSString).stringByAppendingPathComponent("account.plist")
        //3.读取对象
        let account = NSKeyedUnarchiver.unarchiveObjectWithFile(UserAccount.filePath) as? UserAccount
        //4.判断对象是否过期
        if account?.expires_date?.compare(NSDate()) == NSComparisonResult.OrderedAscending{
            FJLog(account!.expires_date!)
            FJLog("登陆过期了")
            return nil
        }
        
        return account
    }
    
    
    ///判断用户是否登陆
    class func userLogon() -> Bool{
    
        return loadUserAccount() != nil
    }
    
}
