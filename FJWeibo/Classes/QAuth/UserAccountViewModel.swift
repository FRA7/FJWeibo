//
//  UserAccountViewModel.swift
//  FJWeibo
//
//  Created by Francis on 3/13/16.
//  Copyright © 2016 FRAJ. All rights reserved.
//

import UIKit

class UserAccountViewModel{
    ///单例
    static let shareInstance: UserAccountViewModel = UserAccountViewModel()
    
    ///授权模型
    var account: UserAccount?
        
    var screen_name: String?{
        return account?.screen_name
    }
    
    var access_token: String?{
        return account?.access_token
    }
    
    ///记录授权模型是否过期
    var isExpires: Bool{
        if account?.expires_date?.compare(NSDate()) == NSComparisonResult.OrderedAscending{
            
            return true
        }
        return false
    }
    
    ///重写构造方法
    init(){
        //1.读取对象
        let account = NSKeyedUnarchiver.unarchiveObjectWithFile(UserAccount.filePath) as? UserAccount
        
        //2.判断是否过期
        if isExpires{
            return
        }
        
        //3.保存数据模型
        self.account = account
    }
   
}
extension UserAccountViewModel{
    
    /**
     判断用户是否登陆
     */
    func userLogon() -> Bool{
        
        return account != nil
    }
    
    
    /**
     利用RequestToken换取AccessToken
     
     - parameter code: RequestToken
     */
    func loadAccessToken(code: String, finished: (account: UserAccount?, error: NSError?)->()) {
        NetWorkTool.shareInstance.loadAccessToken(code, finished: finished)
    }
    
    /**
     获取用户信息
     
     - parameter account: 授权模型
     */
    func loadUserInfo(account: UserAccount,finished: (account: UserAccount?,error: NSError?) -> ()){
        NetWorkTool.shareInstance.loadUserInfo(account, finished: finished)
    }
}
