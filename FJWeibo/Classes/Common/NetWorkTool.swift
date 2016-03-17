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
    
    static let shareInstance: NetWorkTool = {

    let instance = NetWorkTool()
    
        instance.responseSerializer.acceptableContentTypes?.insert("text/plain")

    return instance
    }()
    
}

// MARK:- 封装网络请求
extension NetWorkTool{
    
    func request(methodType : MethodType,urlString: String,parameters: [String: AnyObject],finished: (result: AnyObject?,error: NSError?) -> ()){
        
        //1.定义成功的回调
        let successCallback = { (task : NSURLSessionDataTask, result : AnyObject?) -> Void in
            finished(result: result, error: nil)
        }
        
        //2.定义失败的回调
        let failureCallback = { (task: NSURLSessionDataTask?, error: NSError) -> Void in
            finished(result: nil, error: error)
        }
        
        //3.根据请求的方式发送请求
        if methodType == .GET{
            GET(urlString, parameters: parameters, progress: nil, success: successCallback,failure: failureCallback)
        }else{
            POST(urlString, parameters: parameters, progress: nil, success: successCallback,failure:failureCallback)
        }
        
    }
}


//MARK: - 请求accessToken
extension NetWorkTool{
   
    func loadAccessToken(code: String, finished: Finished) {
        // 1.准备路径
        let urlString = "https://api.weibo.com/oauth2/access_token"
        
        // 2.准备参数
        let parameters = ["client_id": FJ_App_Key, "client_secret": FJ_App_Secret, "grant_type": "authorization_code", "code": code, "redirect_uri": FJ_Redirect_uri]
        
        // 3.发送请求
        request(.POST, urlString: urlString, parameters: parameters) { (result, error) -> () in
            finished(result: result as? [String : AnyObject], error: error)
        }
    }
}

//MARK: - 请求用户信息
extension NetWorkTool{
   
    func loadUserInfo(accessToken: String,uid: String,finished:Finished){
        
        //1.获取请求的url
        let urlString = "https://api.weibo.com/2/users/show.json"
        //2.设置请求体
        let parameter = ["access_token":accessToken,"uid": uid]
        //3.发送网络请求
        request(.GET, urlString: urlString, parameters: parameter) { (result, error) -> () in
            finished(result: result as? [String : AnyObject], error: error)
        }

    }
    
}

extension NetWorkTool{
    
    func loadStatus(finished: (result: [[String: AnyObject]]?,error: NSError?) -> ()){
        
        //1.请求地址
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        //2.获取请求内容
        guard let accessToken = UserAccountViewModel.shareInstance.account?.access_token else{
            return
        }
        //access_token = 2.00_i9uOE0fNBB303fdecc6ccKQoiXC
        let parameters = ["access_token": accessToken]
        
//        FJLog(parameters)
        
        //3.发送请求
        request(.GET, urlString: urlString, parameters: parameters) { (result, error) -> () in
            
            //3.1解析数据,将anyObject转成字典
            guard let resultDict = result as? [String: AnyObject] else{
                finished(result: nil, error: error)
                return
            }
//            FJLog(resultDict)
            //3.2从字典中取出数据进行回调
            finished(result: resultDict["statuses"] as? [[String: AnyObject]], error: error)
        }
        
    }
}
