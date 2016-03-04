//
//  BaseTableViewController.swift
//  FJWeibo
//
//  Created by Francis on 16/2/26.
//  Copyright © 2016年 FRAJ. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController,VisitorViewDelegate {  //遵循代理协议
    //定义一个变量保存用户是否登陆
    var userLogin = true
    //定义属性保存未登录界面
    var visitorView:VisitorView?
    
    
    
    override func loadView() {
        userLogin ? super.loadView() :setUpVisterView()
    }
    
    
    
    //MARK: - 创建未登录界面
    private func setUpVisterView(){
        
        //1.初始化未登录界面
        let costomView = VisitorView()
        //1.1设置当期view成为访客界面的代理
        costomView.delegate = self
        
        
        view = costomView
        visitorView = costomView
        
        //2.设置导航条按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: "registerBtnWillClick")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登陆", style: UIBarButtonItemStyle.Plain, target: self, action: "loginBtnWillClick")
    }
    
    func registerBtnWillClick(){
        print(__FUNCTION__)
    }
    
    func loginBtnWillClick(){
        print(__FUNCTION__)
    }
    


   
}
