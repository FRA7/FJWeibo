//
//  String+Extension.swift
//  FJWeibo
//
//  Created by Francis on 3/13/16.
//  Copyright © 2016 FRAJ. All rights reserved.
//

import UIKit

extension String{
    /**
     快速拼接缓存路径
     - returns: 拼接好的路径
     */
    func cacheDir() ->String{
        //1.获取系统路径
        let path = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).last!
        //2.拼接路径
        let filePath = (path as NSString).stringByAppendingPathComponent(self)
        //3.返回文件路径
        return filePath
    }
    
    /**
     快速拼接文档路径
     - returns: 拼接好的路径
     */
    func documentDir() ->String{
        //1.获取系统路径
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last!
        //2.拼接路径
        let filePath = (path as NSString).stringByAppendingPathComponent(self)
        //3.返回文件路径
        return filePath
    }
    
    /**
     快速拼接临时路径
     - returns: 拼接好的路径
     */
    func tempDir() ->String{
        //1.获取系统路径
        let path = NSTemporaryDirectory()
        //2.拼接路径
        let filePath = (path as NSString).stringByAppendingPathComponent(self)
        //3.返回文件路径
        return filePath
    }
}
