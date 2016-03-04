//
//  TitleButton.swift
//  FJWeibo
//
//  Created by Francis on 2/29/16.
//  Copyright © 2016 FRAJ. All rights reserved.
//

import UIKit
class TitleButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        setImage(UIImage(named: "navigationbar_arrow_down"), forState: UIControlState.Normal)
        setImage(UIImage(named: "navigationbar_arrow_up"), forState: UIControlState.Selected)
        self.sizeToFit()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
      super.layoutSubviews()
        
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = titleLabel!.frame.size.width
        
    }
}
