//
//  NetWorkTool.swift
//  FJWeibo
//
//  Created by Francis on 3/12/16.
//  Copyright © 2016 FRAJ. All rights reserved.
//

import UIKit
import AFNetworking

class NetWorkTool: AFHTTPSessionManager {

    static let shareInstance: NetWorkTool = {
    let baseUrl = NSURL(string: "https://api.weibo.com/")
    let instance = NetWorkTool(baseURL: baseUrl, sessionConfiguration: NSURLSessionConfiguration.defaultSessionConfiguration())
    
        instance.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json", "text/json", "text/javascript", "text/plain") as? Set<String>

    return instance
    }()
    
}

//MARK: - 授权相关
extension NetWorkTool{
    ///获取accessToken
//    func loadAccessToken(code: String,finished:(account: UserAccount?,error: NSError?) ->()){
//        
//            let url = "oauth2/access_token"
//            let parameter = ["client_id": FJ_App_Key,"client_secret": FJ_App_Secret,"grant_type": "authorization_code","code": code,"redirect_uri": FJ_Redirect_uri]
//    
//            //发送请求
//            NetWorkTool.shareInstance.POST(url, parameters: parameter, success: { (task:NSURLSessionDataTask, objc: AnyObject?) -> Void in
//    
//                let account = UserAccount(dict: objc as! [String : AnyObject])
////                account.saveUserAccount()
//                
//                finished(account: account, error: nil)
//                FJLog(account)
//    
//                }) { (task:NSURLSessionDataTask?, error:NSError) -> Void in
////                    FJLog(error)
//                    finished(account: nil, error: error)
//            }
//        
//    }
    
    func loadAccessToken(code: String, finished: (account: UserAccount?, error: NSError?)->()) {
        // 1.准备路径
        let path = "oauth2/access_token"
        
        // 2.准备参数
        let parameters = ["client_id": FJ_App_Key, "client_secret": FJ_App_Secret, "grant_type": "authorization_code", "code": code, "redirect_uri": FJ_Redirect_uri]
        
        // 3.发送请求
        NetWorkTool.shareInstance.POST(path, parameters: parameters, success: { (task, objc) -> Void in
            
            // 3.1字典转换模型
            let account = UserAccount(dict: objc as! [String : AnyObject])
            
            // 3.2获取用户信息
            //            self.loadUserInfo(account)
            
            // 3.2通知外界是否授权成功
            finished(account: account, error: nil)
            
            }) { (task, error) -> Void in
                finished(account: nil, error: error)
        }
    }

    
    
    func loadUserInfo(account: UserAccount,finished: (account: UserAccount?,error: NSError?) -> ()){
        
        assert(account.access_token != nil, "必须授权之后才能调用")
        assert(account.uid != nil, "必须授权之后才能调用")
        
        let url = "2/users/show.json"
        
        let parameter = ["access_token": account.access_token!,"uid": account.uid!]
        
        NetWorkTool.shareInstance.GET(url, parameters: parameter, success: { (task:NSURLSessionDataTask, objc: AnyObject?) -> Void in
            
            FJLog(objc)
            
            let dict = objc as! [String : AnyObject]
            
            //保存用户信息
            account.screen_name = dict["screen_name"] as? String
            account.avatar_large = dict["avatar_large"] as? String
            
            finished(account: account, error: nil)
            
            }) { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                
                finished(account: nil, error: error)
        }
        
        
    }
    
    
}
