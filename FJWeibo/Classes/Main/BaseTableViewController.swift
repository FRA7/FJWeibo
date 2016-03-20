//
//  BaseTableViewController.swift
//  FJWeibo
//
//  Created by Francis on 16/2/26.
//  Copyright © 2016年 FRAJ. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {  
    // MARK:- 懒加载
    lazy var visitorView : VisitorView = VisitorView.visitorView()
    
    // MARK:- 属性
    var isLogin : Bool = UserAccountViewModel.shareInstance.isLogin
    
    // MARK:- 系统回调函数
    override func loadView() {
        isLogin ? super.loadView() : setupVisitorView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


extension BaseTableViewController {
    /// 加载访客视图
    private func setupVisitorView() {
        // 1.访客视图
        view = visitorView
        
        // 2.添加导航栏左右的item
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .Plain, target: self, action: "registerBtnClick")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .Plain, target: self, action: "loginBtnClick")
        
        // 3.监听访客视图中注册和登录按钮的点击
        visitorView.registerBtn.addTarget(self, action: "test:name:", forControlEvents: .TouchUpInside)
        visitorView.loginBtn.addTarget(self, action: "loginBtnClick", forControlEvents: .TouchUpInside)
    }
}


extension BaseTableViewController {
    @objc private func registerBtnClick() {
        FJLog("registerBtnClick")
    }
    @objc private func loginBtnClick() {
        // 1.创建授权页面
        let oauthVc = QAuthViewController()
        
        // 2.包装导航控制器
        let oauthNav = UINavigationController(rootViewController: oauthVc)
        
        // 3.弹出授权页面
        presentViewController(oauthNav, animated: true, completion: nil)
    }
}