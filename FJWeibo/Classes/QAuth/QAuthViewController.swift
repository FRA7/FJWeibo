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

//        let (data, enc) = UTF8ToGB2312("abcd1234")
//        let gbkStr = NSString(data: data!, encoding: enc)!
//        
//        print("GBK string is: \(gbkStr)")
        
        
        
        
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
        
        let jsStr = "document.getElementById('userId').value='1606020376@qq.com';" + "document.getElementById('passwd').value='haomage';"
        
        webView.stringByEvaluatingJavaScriptFromString(jsStr)
    }
}

extension QAuthViewController:UIWebViewDelegate{
    //判断是否允许继续访问
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        //1.取出当前请求URL
        guard let urlStr = request.URL?.absoluteString else{
            closeBtnClick()
            return false
        }
        //1.2判断是否是授权回调页
        if !urlStr.hasPrefix(FJ_Redirect_uri){
            return true
        }
        //2.判断
        if !urlStr.containsString("error_uri="){
            //2.1获取code=所在位置
            guard let range = urlStr.rangeOfString("code=") else{
                closeBtnClick()
                return false
            }
            //2.2截取字符串
            let code = urlStr.substringFromIndex(range.endIndex)
            FJLog(code)
            loadAccessTaken(code)
        }
        
        //3.关闭页面
        closeBtnClick()
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
    
    //通过request token换取access token
    private func loadAccessTaken(code:String){
        
//        let url = "oauth2/access_token"
//        let parameter = ["client_id":FJ_App_Key,"client_secret":FJ_App_Secret,"grant_type":"authorization_code","code":code,"redirect_uri":FJ_Redirect_uri]
//        
//        //发送请求
//        NetWorkTool.shareInstance.POST(url, parameters: parameter, success: { (task:NSURLSessionDataTask, objc: AnyObject?) -> Void in
//            
//            let account = UserAccount(dict: objc as! [String : AnyObject])
//            account.saveUserAccount()
//            
//            FJLog(objc)
//            }) { (task:NSURLSessionDataTask?, error:NSError) -> Void in
//                FJLog(error)
//        }
        
        NetWorkTool.shareInstance.loadAccessToken(code) { (account, error) -> () in
            if error != nil || account == nil{
                SVProgressHUD.showErrorWithStatus("获取用户信息失败" ,maskType: .Black)
                return
            }
            
//            let s = (NSString)account?.screen_name
            
            FJLog(account)
            
//                    let (data, enc) = self.UTF8ToGB2312((account?.screen_name)!)
//                    let gbkStr = NSString(data: data!, encoding: enc)!
//            
//                    print("GBK string is: \(gbkStr)")
            
            
            
            //授权成功
            self.loadUserInfo(account!)
        }
    }
    //MARK: - UTF8转码
    func UTF8ToGB2312(str: String) -> (NSData?, UInt) {
        let enc = CFStringConvertEncodingToNSStringEncoding(UInt32(CFStringEncodings.GB_18030_2000.rawValue))
        
        var data = str.dataUsingEncoding(enc, allowLossyConversion: false)
        
        return (data, enc)
    }
    
    private func loadUserInfo(account: UserAccount){
        
        NetWorkTool.shareInstance.loadUserInfo(account) { (account, error) -> () in
            if error != nil || account == nil{
                SVProgressHUD.showErrorWithStatus("获取用户信息失败" ,maskType: .Black)
                return
            }
            
            //保存用户授权信息
            account!.saveUserAccount()
            
        }
        
    }
}