//
//  VisitorView.swift
//  FJWeibo
//
//  Created by Francis on 16/2/26.
//  Copyright © 2016年 FRAJ. All rights reserved.
//

import UIKit


class VisitorView: UIView {

    // MARK:- 快速通过xib创建View方法
    class func visitorView() -> VisitorView {
        return NSBundle.mainBundle().loadNibNamed("VisitorView", owner: nil, options: nil).first as! VisitorView
    }
    
    // MARK:- 控件属性
    @IBOutlet weak var rotationView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    // MARK:- 设置控件内容的函数
    func setupVisitorViewInfo(iconName : String, tipString : String) {
        iconView.image = UIImage(named: iconName)
        tipLabel.text = tipString
        rotationView.hidden = true
    }
    
    // MARK:- 给转盘添加基本动画
    func addRotationAnimate() {
        // 1.创建动画
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        
        // 2.设置动画属性
        rotationAnim.fromValue = 0
        rotationAnim.toValue = M_PI * 2
        rotationAnim.duration = 10
        rotationAnim.repeatCount = MAXFLOAT
        // 将该属性设置成false,那么view消失时,动画不会被移除
        rotationAnim.removedOnCompletion = false
        
        // 3.将动画添加到图层上
        rotationView.layer.addAnimation(rotationAnim, forKey: nil)
    }
}
