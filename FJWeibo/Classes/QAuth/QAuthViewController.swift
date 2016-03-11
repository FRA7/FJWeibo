//
//  QAuthViewController.swift
//  FJWeibo
//
//  Created by Francis on 16/3/11.
//  Copyright © 2016年 FRAJ. All rights reserved.
//

//URL https://api.weibo.com/oauth2/authorize
//App Key：325322411
//App Secret：ffa181fb13a654b035341703e51ff35f
//redirect_uri	http://www.520it.com
//access token 3a44a4c49e9338e30133a5da8887ad7d

import UIKit

class QAuthViewController: UIViewController {

    override func loadView() {
        //将控制器的view替换为webView
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("closeBtnClick"))
        
        //发送请求
        let str = "https://api.weibo.com/oauth2/authorize?client_id=\(FJ_App_Key)&redirect_uri=\(FJ_Redirect_uri)"
        let url = NSURL(string: str)!
        let request = NSURLRequest(URL: url)
        webView.loadRequest(request)
    }
    
    //MARK: - 懒加载
    private lazy var webView = UIWebView()

    //MARK: - 内部调用方法
    @objc private func closeBtnClick(){
        dismissViewControllerAnimated(true, completion: nil)
    }
}
