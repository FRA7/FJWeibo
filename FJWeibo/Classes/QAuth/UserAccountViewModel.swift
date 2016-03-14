//
//  UserAccountViewModel.swift
//  FJWeibo
//
//  Created by Francis on 3/13/16.
//  Copyright © 2016 FRAJ. All rights reserved.
//

import UIKit

typealias SuccessCallBack = (isSuccess: Bool) -> ()

class UserAccountViewModel{
    /// 将视图模型设置到单例对象 --> 1.很多地方都会用 2.使用对象起来更多方便
    static let shareInstance: UserAccountViewModel = UserAccountViewModel()
    
    /// 用户账号的属性 --> UserAccountViewModel初衷就是对象account
    var account: UserAccount?
    
    /// 用户判断是否登录成功的属性 --> 快速判断是否登录
    var isLogin: Bool{
        return account != nil && !isExpires
    }
    
    
    
    var screen_name: String?{
        return account?.screen_name
    }
    
    var access_token: String?{
        return account?.access_token
    }
    
    
    
    /// 判断AccessToken是否过期 --> 快速判断是否过期
    var isExpires: Bool{
        
        guard let expires_date = account?.expires_date else{
            return true
        }
        
        return expires_date.compare(NSDate()) == NSComparisonResult.OrderedAscending
    }
    

    
    // MARK:- 构造函数 : 创建出来ViewModel对象之后,拥有account
    init(){
        //1.读取对象
        account = NSKeyedUnarchiver.unarchiveObjectWithFile(UserAccount.filePath) as? UserAccount

    }
   
}
extension UserAccountViewModel{
       
    /**
     利用RequestToken换取AccessToken
     
     - parameter code: RequestToken
     */
    func loadAccessToken(code: String, isSuccess: SuccessCallBack) {

        NetWorkTool.shareInstance.loadAccessToken(code) { (result, error) -> () in
            //1.错误校验
            if error != nil{
                FJLog(error)
                isSuccess(isSuccess: false)
                return
            }

            //2.获取结果字典
            guard let accountDict = result else{
                isSuccess(isSuccess: false)
                return
            }
            
            //3.字典转成模型对象
            let account = UserAccount(dict: accountDict)
            
            //4.请求用户信息
            self.loadUserInfo(account, isSuccess: isSuccess)
            
        }
        
    }
    
    /**
     获取用户信息
     
     - parameter account: 授权模型
     */
    func loadUserInfo(account: UserAccount,isSuccess: SuccessCallBack){
    
        //1.获取accessToken和uid
        guard let accessToken = account.access_token,uid = account.uid else{
            isSuccess(isSuccess: false)
            return
        }
        
        //2.请求用户信息
        NetWorkTool.shareInstance.loadUserInfo(accessToken, uid: uid) { (result, error) -> () in
            //1.错误校验
            if error != nil{
                FJLog(error)
                isSuccess(isSuccess: false)
                return
            }
            
            //2.获取字典结果
            guard let userInfoDict = result else{
                isSuccess(isSuccess: false)
                return
            }
            
            //3.从字典中获取头像的地址和昵称
            account.avatar_large = userInfoDict["avatar_large"] as? String
            account.screen_name = userInfoDict["screen_name"] as? String
            
            //4.将账号的对象进行归档
            FJLog(UserAccount.filePath)
            NSKeyedArchiver.archiveRootObject(account, toFile: UserAccount.filePath)
            
            //5.将创建出的账号对象,赋值给account属性
            self.account = account
            
            //6.回调成功
            isSuccess(isSuccess: true)
            
        }
    }
}
