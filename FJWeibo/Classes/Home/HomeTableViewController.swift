//
//  HomeTableViewController.swift
//  FJWeibo
//
//  Created by Francis on 16/2/26.
//  Copyright © 2016年 FRAJ. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseTableViewController {

  
    override func viewDidLoad() {
        super.viewDidLoad()

        //1.如果没有登录就设置登录界面
        if !userLogin{
            
            visitorView?.setUpVisitorInfo(true,imageName:"visitordiscover_feed_image_house",message:"关注一些人，回这里看看有什么惊喜")
            return
        }
        
        //2.初始化导航条
        setUpNav()
        
        //3.注册通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "change", name: FJPopoverAnimatorWillShow, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "change", name: FJPopoverAnimatorWillDismiss, object: nil)
    }

    deinit {
        //移除通知
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    /**
     设置标题按钮状态
     */
    func change(){
        
        let titleB = navigationItem.titleView as! TitleButton
        titleB.selected = !titleB.selected
    }
    
    
    private func setUpNav(){
        
        //1.初始化导航条按钮
        //设置左边按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem.creatBarButtonItem("navigationbar_friendattention", target: self, action: "leftItemClick")
        //设置右边按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem.creatBarButtonItem("navigationbar_pop", target: self, action: "rightItemClick")
        
        //2.初始化标题按钮
        let titleBtn = TitleButton()
        titleBtn.setTitle("FRAJ ", forState: UIControlState.Normal)
        titleBtn.addTarget(self, action: "titleButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        navigationItem.titleView = titleBtn
        
    }
    
    func titleButtonClick(btn:TitleButton){

        //1.设置按钮状态
//        btn.selected = !btn.selected
        //2.弹出菜单
        let sb = UIStoryboard(name: "PopoverViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        //2.1设置转场代理
        popoverAnimator.presentFrame = CGRect(x: (UIScreen.mainScreen().bounds.width - 200)*0.5, y: 56, width: 200, height: 300)
        vc?.transitioningDelegate = popoverAnimator
        //2.2设置转场样式
        vc?.modalPresentationStyle = UIModalPresentationStyle.Custom
        
        presentViewController(vc!, animated: true, completion: nil)
        
        
    }
    
     func leftItemClick(){
        FJLog(__FUNCTION__)
       
    }
     func rightItemClick(){

        
        let sb = UIStoryboard(name: "QRCodeViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        
        presentViewController(vc!, animated: true, completion: nil)
    }
    
    //记录菜单是否展开
    var isPresent :Bool = false
    
    
    //定义一个对象保存自定义转场动画
    //MARK: - 懒加载
    private lazy var popoverAnimator:PopoverAnimator = {
        
        let p = PopoverAnimator()
        p.presentFrame = CGRect(x: 100, y: 56, width: 200, height: 350)
        return p
    }()
    
   }



