//
//  PopoverPresentationController.swift
//  FJWeibo
//
//  Created by Francis on 3/1/16.
//  Copyright © 2016 FRAJ. All rights reserved.
//

import UIKit

class PopoverPresentationController:UIPresentationController {
    
    var presentFrame = CGRectZero
    
    override init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
    }
    
    override func containerViewWillLayoutSubviews() {
        
        if presentFrame == CGRectZero{
            //1.设置弹出视图的大小
//            let preX = UIScreen.mainScreen().bounds.size.width / 2 - 100
            //        print(preX)
            presentedView()?.frame = CGRect(x: 100, y: 56, width: 200, height: 200)
        }else{
            presentedView()?.frame = presentFrame
            
        }
        
   
        //2.增加蒙版
        containerView?.insertSubview(coverView, atIndex: 0)
        
    }
    //MARK: - 懒加载
    private lazy var coverView:UIView = {
        //1.创建view
        let v = UIView()
        
        v.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        v.frame = UIScreen.mainScreen().bounds
        //2.添加监听
        let tap = UITapGestureRecognizer(target: self, action: #selector(PopoverPresentationController.close))
        v.addGestureRecognizer(tap)
        return v
    }()
    
     func close(){
        
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
