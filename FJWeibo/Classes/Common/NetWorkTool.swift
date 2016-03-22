//
//  NetWorkTool.swift
//  FJWeibo
//
//  Created by Francis on 3/12/16.
//  Copyright © 2016 FRAJ. All rights reserved.
//

import UIKit
import AFNetworking

enum MethodType : String {
    case GET = "GET"
    case POST = "POST"
}

class NetWorkTool: AFHTTPSessionManager {

    
    // 给闭包起别名
    typealias Finished = (result : [String : AnyObject]?, error : NSError?) -> ()
    
    // 将工具类设计成单例对象
    static let shareInstance : NetWorkTool = {
        let tools = NetWorkTool()
        tools.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
        return tools
    }()
}

// MARK:- 封装网络请求
extension NetWorkTool {
    func request(methodType : MethodType, urlString : String, parameters : [String : AnyObject], finished : (result : AnyObject?, error : NSError?) -> ()) {
        
        // 1.定义成功的回调
        let successCallBack = { (task : NSURLSessionDataTask, result : AnyObject?) -> Void in
            finished(result: result, error: nil)
        }
        
        // 2.定义失败的回调
        let failureCallBack = { (task : NSURLSessionDataTask?, error : NSError) -> Void in
            finished(result: nil, error: error)
        }
        
        // 3.根据请求方式发送请求
        if methodType == .GET {
            GET(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
        } else {
            POST(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
        }
    }
}


// MARK:- 请求AccessToken
extension NetWorkTool {
    func loadAccessToken(codeString : String, finished : Finished) {
        // 1.获取请求的URLString
        let urlString = "https://api.weibo.com/oauth2/access_token"
        
        // 2.获取请求参数
        let parameters = ["client_id" : FJ_App_Key, "client_secret" : FJ_App_Secret, "grant_type" : "authorization_code", "code" : codeString, "redirect_uri" : FJ_Redirect_uri]
        
        // 3.发送网络请求
        request(.POST, urlString: urlString, parameters: parameters) { (result, error) -> () in
            finished(result: result as? [String : AnyObject], error: error)
        }
    }
}


// MARK:- 请求用户信息
extension NetWorkTool {
    func loadUserInfo(accessToken : String, uid : String, finished : Finished) {
        // 1.获取请求的URLString
        let urlString = "https://api.weibo.com/2/users/show.json"
        
        // 2.获取请求的参数
        let parameters = ["access_token" : accessToken, "uid" : uid]
        
        // 3.发送完了请求
        request(.GET, urlString: urlString, parameters: parameters) { (result, error) -> () in
            finished(result: result as? [String : AnyObject], error: error)
        }
    }
}


// MARK:- 请求微博的首页数据
extension NetWorkTool {
    func loadStatuses(since_id: Int,max_id: Int, finished : (result : [[String : AnyObject]]?, error : NSError?) -> ()) {
        // 1.获取请求的URLString
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        // 2.获取请求的参数
        guard let accessToken = UserAccountViewModel.shareInstance.account?.access_token else {
            return
        }
        let parameters: [String: AnyObject] = ["access_token" : accessToken,"since_id" : since_id,"max_id": max_id]
        
        // 3.发送请求
        request(.GET, urlString: urlString, parameters: parameters) { (result, error) -> () in
            // 3.1.将AnyObject的结果转成字典
            guard let resultDict = result as? [String : AnyObject] else {
                finished(result: nil, error: error)
                return
            }
            
            // 3.2.从字典中取出数据,并且进行回调
            finished(result: resultDict["statuses"] as? [[String : AnyObject]], error: error)
        }
    }
}
