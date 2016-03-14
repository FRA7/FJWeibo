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

    override func loadView() {
        //将控制器的view替换为webView
        view = webView
        webView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        //左侧导航条按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("closeBtnClick"))
        //右侧导航条按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("autoAccess"))
        
        
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
    
    @objc private func autoAccess(){
        
//        let jsStr = "document.getElementById('userId').value='1606020376@qq.com';" + "document.getElementById('passwd').value='haomage';"
        let jsStr = "document.getElementById('userId').value='458734857@qq.com';" + "document.getElementById('passwd').value='446126902';"
        
        webView.stringByEvaluatingJavaScriptFromString(jsStr)
    }
}

//MARK: - WebView代理方法
extension QAuthViewController:UIWebViewDelegate{
    //判断是否允许继续访问
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        //1.获取URL对应的字符串
        guard let urlStr = request.URL?.absoluteString else{
//            closeBtnClick()
            return true
        }

        //2.判断字符串中是否有code
        if !urlStr.containsString("code="){
            return true
        }

        //3取出code
        guard let code = urlStr.componentsSeparatedByString("code=").last else{
            return true
        }
        
        //换取accessToken
        UserAccountViewModel.shareInstance.loadAccessToken(code) { (isSuccess) -> () in
            if !isSuccess {
                return
            }
            
            self.dismissViewControllerAnimated(false, completion: { () -> Void in
                //显示欢迎界面
                UIApplication.sharedApplication().keyWindow?.rootViewController = WelcomeViewController()
            })
        }
 
        return false
        
    }
    
    ///每次请求前调用
    func webViewDidStartLoad(webView: UIWebView) {
        FJLog("正在加载")

        SVProgressHUD.showInfoWithStatus("正在加载", maskType: .Black)
    }
    ///每次请求完成调用
    func webViewDidFinishLoad(webView: UIWebView) {
        
        SVProgressHUD.dismiss()
    }
}
