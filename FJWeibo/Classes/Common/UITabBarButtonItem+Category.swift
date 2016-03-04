//
//  UITabBarButtonItem+Category.swift
//  FJWeibo
//
//  Created by Francis on 2/29/16.
//  Copyright © 2016 FRAJ. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
   //编写分类创建按钮
    class func creatBarButtonItem(imageName:String, target:AnyObject?, action:Selector) ->UIBarButtonItem{
        let btn = UIButton()
        
        btn.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: imageName + "_highlited"), forState: UIControlState.Highlighted)
        btn.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        
        btn.sizeToFit()
        return UIBarButtonItem(customView: btn)
    }
    
    
}


