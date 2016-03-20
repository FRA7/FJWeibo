//
//  WelcomeViewController.swift
//  FJWeibo
//
//  Created by Francis on 3/14/16.
//  Copyright © 2016 FRAJ. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {

    //MARK: - 控件属性
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var iconImageViewTopCons: NSLayoutConstraint!
    
    //MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.redColor()
        
        // 2.如果前面的可选类型有一个没有值,那么直接取??后面的值
        let url = NSURL(string: UserAccountViewModel.shareInstance.account?.avatar_large ?? "")!
        iconImageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "avatar_default_big"))
        screenNameLabel.text = UserAccountViewModel.shareInstance.account?.screen_name ?? "欢迎回来"
        
        // 2.执行动画(UIDynamic -> snapB(捕捉仿真))
        // Damping : 阻力系数,取值范围:0~1
        // initialSpringVelocity : 初始化速度
        iconImageViewTopCons.constant = 100
        UIView.animateWithDuration(1.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 5.0, options: [], animations: { () -> Void in
            self.view.layoutIfNeeded()
            }) { (_) -> Void in
                                UIApplication.sharedApplication().keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
        }
        
        
    }

}
