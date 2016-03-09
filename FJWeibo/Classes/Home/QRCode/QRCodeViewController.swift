//
//  QRCodeViewController.swift
//  FJWeibo
//
//  Created by Francis on 16/3/9.
//  Copyright © 2016年 FRAJ. All rights reserved.
//

import UIKit

class QRCodeViewController: UIViewController {
    //底部tabBar
    @IBOutlet weak var customTabBar: UITabBar!
    @IBAction func closeBtnClick(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customTabBar.selectedItem = customTabBar.items![0]
    }


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
