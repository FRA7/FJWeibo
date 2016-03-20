//
//  AppDelegate.swift
//  FJWeibo
//
//  Created by Francis on 16/2/26.
//  Copyright © 2016年 FRAJ. All rights reserved.
//

import UIKit
import AFNetworking

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    var defaultViewController: UIViewController{
        let isLogin = UserAccountViewModel.shareInstance.isLogin
        return isLogin ? WelcomeViewController() :UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

//        // 0.设置AFN属性
//        let cache = NSURLCache(memoryCapacity: 4 * 1024 * 1024, diskCapacity: 20 * 1024 * 1024, diskPath: nil)
//        NSURLCache.setSharedURLCache(cache)
//        AFNetworkActivityIndicatorManager.sharedManager().enabled = true

        
        
        
        //设置导航条和工具条全局属性
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        UITabBar.appearance().tintColor = UIColor.orangeColor()
        
        
        //1.创建窗口
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        //2.设置窗口根视图
//        window?.rootViewController = MainViewController()
        window?.rootViewController = defaultViewController
        
        //3.显示窗口
        window?.makeKeyAndVisible()
        
        
        return true
    }

    

}
//MARK: - 自定义Log
func FJLog<T>(message : T, file : String = __FILE__, lineNum : Int = __LINE__) {
    
    #if DEBUG
        
        let filePath = (file as NSString).lastPathComponent
        print("\(filePath)-[\(lineNum)]:\(message)")
        
    #endif
}
