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
import SVProgressHUD


class QAuthViewController: UIViewController {
    // MARK:- 控件属性
    @IBOutlet weak var webView: UIWebView!
    
    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.设置导航栏的内容
        setupNavigationBar()
        
        // 2.加载登录的页面
        loadPage()
    }
}

// MARK:- 设置界面的信息
extension QAuthViewController {
    private func setupNavigationBar() {
        // 1.设置左侧的Item
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .Plain, target: self, action: #selector(QAuthViewController.close))
        
        // 2.设置右侧的Item
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: .Plain, target: self, action: #selector(QAuthViewController.autoFill))
        
        // 3.设置标题
        title = "登录页面"
    }
    
    private func loadPage() {
        // 1.获取urlString
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(FJ_App_Key)&redirect_uri=\(FJ_Redirect_uri)"
        
        // 2.创建URL
        guard let url = NSURL(string: urlString) else {
            return
        }
        
        // 3.创建URLRequest对象
        let request = NSURLRequest(URL: url)
        
        // 4.加载request对象
        webView.loadRequest(request)
    }
    
    @objc private func close() {
        SVProgressHUD.dismiss()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func autoFill() {
        // 1.获取要执行的js(JavaScript)代码
        let jsCode = "document.getElementById('userId').value='18626350685';document.getElementById('passwd').value='j446126902';"
        
        // 2.webView执行js代码
        webView.stringByEvaluatingJavaScriptFromString(jsCode)
    }
}

// MARK:- UIWebViewDelegate
extension QAuthViewController : UIWebViewDelegate {
    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        SVProgressHUD.dismiss()
    }
    
    // 加载某一个页面时会执行该方法
    // 返回值 : true : 继续加载该页面 false : 不会加载该页面
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        // 1.获取URL对应的字符串
        guard let urlString = request.URL?.absoluteString else {
            return true
        }
        
        // 2.判断字符串中是否有code
        if !urlString.containsString("code=") {
            return true
        }
        
        // 3.取出code
        guard let codeString = urlString.componentsSeparatedByString("code=").last else {
            return true
        }
        
        // 4.换取AccessToken
        UserAccountViewModel.shareInstance
            .loadAccessToken(codeString) { (isSuccess) -> () in
            if !isSuccess {
                return
            }
            
            self.dismissViewControllerAnimated(false, completion: { () -> Void in
                // 显示欢迎界面
                UIApplication.sharedApplication().keyWindow?.rootViewController = WelcomeViewController()
            })
        }
        
        return false
    }

}
