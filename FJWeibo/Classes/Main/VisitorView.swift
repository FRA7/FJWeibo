//
//  VisitorView.swift
//  FJWeibo
//
//  Created by Francis on 16/2/26.
//  Copyright © 2016年 FRAJ. All rights reserved.
//

import UIKit


protocol VisitorViewDelegate:NSObjectProtocol{
    
    //登陆回调
    func loginBtnWillClick()
    //注册回调
    func registerBtnWillClick()
    
}

class VisitorView: UIView {

    //定义一个属性保存代理属性.一定要加上weak进行弱引用
    weak var delegate:VisitorViewDelegate?
    
    
    
    //设置未登录界面
    
    func setUpVisitorInfo(isHome:Bool, imageName:String, message:String){
        
        //如果不是首页,隐藏转盘
        iconView.hidden = !isHome
        //修改中间图标
        homeIcon.image = UIImage(named: imageName)
        //修改文本
        messageLabel.text = message
        
        //判断是否是home界面,如果是,开启转盘旋转动画
        if isHome{
            startAnimation()
        }
        
    }
    
    func loginBtnClick(){
        delegate?.loginBtnWillClick()
    }
    func registerBtnClick(){
        delegate?.registerBtnWillClick()
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //1.添加子控件
        addSubview(iconView)
        addSubview(homeIcon)
        addSubview(messageLabel)
        addSubview(maskBGView)
        addSubview(loginButton)
        addSubview(registButton)
        //2.布局子控件
        //2.1设置背景
        iconView.fj_AlignInner(type: FJ_AlignType.Center, referView: self, size: nil)
        //2.2设置homeIcon
        homeIcon.fj_AlignInner(type: FJ_AlignType.Center, referView: self, size: nil)
        //2.3设置文本
        messageLabel.fj_AlignVertical(type: FJ_AlignType.BottomCenter, referView: iconView, size: nil)
        //设置文本宽度
        let widthCons = NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 224)
        addConstraint(widthCons)
        
        //2.4设置注册按钮
        registButton.fj_AlignVertical(type: FJ_AlignType.BottomLeft, referView: messageLabel, size: CGSize(width: 100, height: 30) ,offset:CGPoint(x: 0, y: 20))
        //2.5设置登陆按钮
        loginButton.fj_AlignVertical(type: FJ_AlignType.BottomRight, referView: messageLabel, size: CGSize(width: 100, height: 30) ,offset:CGPoint(x: 0, y: 20))
        
        //设置蒙版
        maskBGView.fj_Fill(self)
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - 内部控制方法
    private func startAnimation(){
        
        //1.创建动画
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        //2.设置动画属性
        anim.toValue = 2 * M_PI
        anim.duration = 20
        anim.repeatCount = MAXFLOAT
        
        //此属性默认为true ,动画执行完移除动画
        anim.removedOnCompletion = false
        //3.将动画添加到图层上
        iconView.layer.addAnimation(anim, forKey: nil)
        
    }
    
    
    
    
    //MARK: - 懒加载控件
    //转盘
    private lazy var iconView:UIImageView = {
        let iv = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
        return iv
    }()
    //图标
    private lazy var homeIcon:UIImageView = {
       let iv = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
        return iv
    }()
    //文本
    private lazy var messageLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor.darkGrayColor()
        label.text = "关注一些人，回这里看看有什么惊喜"
        label.font = UIFont.systemFontOfSize(14)
        
        return label
    }()
    //登陆按钮
    private lazy var loginButton:UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        btn.setTitle("登陆", forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        
        //给按钮添加事件
        btn.addTarget(self, action: "loginBtnClick", forControlEvents: UIControlEvents.TouchUpInside)
        
        return btn
    }()
    //注册按钮
    private lazy var registButton:UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        btn.setTitle("注册", forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        
        //给按钮添加事件
        btn.addTarget(self, action: "registerBtnClick", forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    //遮盖view
    private lazy var maskBGView:UIImageView = {
        let iv = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
        return iv
    }()


}
