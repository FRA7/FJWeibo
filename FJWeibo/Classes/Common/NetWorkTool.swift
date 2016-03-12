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
