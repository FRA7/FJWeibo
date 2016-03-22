//
//  ComposeViewController.swift
//  FJWeibo
//
//  Created by Francis on 16/3/22.
//  Copyright © 2016年 FRAJ. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    //MARK: - 懒加载
    @IBOutlet weak var customTextView: ComposeTextView!
    private lazy var titleView : ComposeTitleView = ComposeTitleView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNav()

    }
}
 // MARK:- 设置UI相关
extension ComposeViewController{

    private func setupNav(){
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: .Plain, target: self, action: "cancelBtnClick")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发布", style: .Plain, target: self, action: "sendBtnClick")
        navigationItem.rightBarButtonItem?.enabled = false
        
        //设置标题栏
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 36)
        navigationItem.titleView = titleView
    }
    

}

// MARK:- 事件监听函数
extension ComposeViewController{
    
    @objc private func cancelBtnClick(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func sendBtnClick(){
        FJLog("sendBtnClick")
    }
}

//MARK: - UITextViewDelegate
extension ComposeViewController:UITextViewDelegate{
    
    func textViewDidChange(textView: UITextView) {
        customTextView.placeHolderLabel.hidden = textView.hasText()
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()
    }
}