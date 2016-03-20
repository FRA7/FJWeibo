//
//  UIButton-Extension.swift
//  FJWeibo
//
//  Created by Francis on 2/29/16.
//  Copyright © 2016 FRAJ. All rights reserved.
//

import UIKit


extension UIButton {
    // swift中如果在extension中扩展构造函数,必须在构造函数前convenience(便利)
    // 便利构造函数中,必须明确调用self.init()
    convenience init(imageName : String, bgImageName : String) {
        self.init()
        
        setImage(UIImage(named: imageName), forState: .Normal)
        setImage(UIImage(named: imageName + "_highlighted"), forState: .Highlighted)
        setBackgroundImage(UIImage(named: bgImageName), forState: .Normal)
        setBackgroundImage(UIImage(named: bgImageName + "_highlighted"), forState: .Highlighted)
        sizeToFit()
    }
    
    // 在swift中类方法只需要以class开头即可:类似于OC中+开头的方法
    class func createBtn(imageName : String, bgImageName : String) -> UIButton {
        // 1.创建btn
        let btn = UIButton(type: .Custom)
        
        // 2.设置图片
        btn.setImage(UIImage(named: imageName), forState: .Normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), forState: .Highlighted)
        btn.setBackgroundImage(UIImage(named: bgImageName), forState: .Normal)
        btn.setBackgroundImage(UIImage(named: bgImageName + "_highlighted"), forState: .Highlighted)
        btn.sizeToFit()
        
        return btn
    }
}