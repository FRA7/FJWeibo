//
//  MainViewController.swift
//  FJWeibo
//
//  Created by Francis on 16/2/26.
//  Copyright © 2016年 FRAJ. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    //MARK: - 懒加载
    
    private lazy var imageNames : [String] = ["tabbar_home", "tabbar_message_center", "", "tabbar_discover", "tabbar_profile"]
    private lazy var composeBtn : UIButton = UIButton(imageName: "tabbar_compose_icon_add", bgImageName: "tabbar_compose_button")
   
    
    // MARK: - 内部控制方法
    override func viewDidLoad() {
        super.viewDidLoad()

        setupComposeBtn()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        adjustItems()
    }
    
}
// MARK:- 设置UI
extension MainViewController {
    /// 调整的tabbar
    private func adjustItems() {
        for i in 0..<tabBar.items!.count {
            // 1.取出item
            let item = tabBar.items![i]
            
            // 2.判断如果是下标值为2,那么不可以和用户交互
            if i == 2 {
                item.enabled = false
                continue
            }
            
            // 3.设置item的选中图片
            item.selectedImage = UIImage(named: imageNames[i] + "_highlighted")
        }
    }

    
    /// 添加发布按钮
    private func setupComposeBtn() {
        // 1.将按钮添加到tabbar中
        tabBar.addSubview(composeBtn)
        
        // 2.设置发布按钮的位置
        composeBtn.center = CGPoint(x: tabBar.bounds.width * 0.5, y: tabBar.bounds.height * 0.5)
        
        // 3.监听按钮的点击
        composeBtn.addTarget(self, action: #selector(MainViewController.composeBtnClick), forControlEvents: .TouchUpInside)
    }

}

extension MainViewController {
    @objc private func composeBtnClick() {
        
       //1.创建发布控制器
        let composeVC = ComposeViewController()
        //2.给发布控制器添加导航栏
        let compNav = UINavigationController(rootViewController: composeVC)
        //3.跳转控制器
        presentViewController(compNav, animated: true, completion: nil)
        
    }
}
