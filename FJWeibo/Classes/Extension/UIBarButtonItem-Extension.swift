//
//  UIBarButtonItem-Extension.swift
//  FJWeibo
//
//  Created by Francis on 2/29/16.
//  Copyright © 2016 FRAJ. All rights reserved.
//

import UIKit


extension UIBarButtonItem {
    convenience init(imageName : String, target : AnyObject?, action : Selector) {
        let btn = UIButton(type: .Custom)
        btn.setImage(UIImage(named: imageName), forState: .Normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), forState: .Highlighted)
        btn.sizeToFit()
        btn.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        
        self.init(customView : btn)
    }
}