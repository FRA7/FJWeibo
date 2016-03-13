//
//  MainViewController.swift
//  FJWeibo
//
//  Created by Francis on 16/2/26.
//  Copyright © 2016年 FRAJ. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    // MARK: - 内部控制方法
    override func viewDidLoad() {
        super.viewDidLoad()

        //设置tabBar字体颜色
        tabBar.tintColor = UIColor.orangeColor()

        //添加子控制器
        addChildViewControllers()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpComposedBtn()
    }
    
    // MARK: - 设置加号按钮
    private func setUpComposedBtn(){
        
        //1.添加加号按钮
        tabBar.addSubview(composedBtn)
        //2.调整加号按钮位置
        
        let width = UIScreen.mainScreen().bounds.size.width / CGFloat(viewControllers!.count)

        let rect = CGRect(x: 0, y: 0, width: width, height: 49)
        
        composedBtn.frame = CGRectOffset(rect, 2 * width, 0)
        
    }
    
    func composedBtnClick(){

        FJLog(__FUNCTION__)
    }
    
    //MARK: - 懒加载
    //懒加载加号按钮
    private lazy var composedBtn:UIButton = {
        let btn = UIButton()
       //设置前景图片
        btn.setImage(UIImage(named:"tabbar_compose_icon_add" ), forState: UIControlState.Normal)
        btn.setImage(UIImage(named:"tabbar_compose_icon_add_highlighted" ), forState: UIControlState.Highlighted)
        //设置背景图片
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        
        //添加点击事件
        btn.addTarget(self, action: "composedBtnClick", forControlEvents: UIControlEvents.TouchUpInside)
        
        return btn
    }()
   
    
    // MARK: - 添加子控制器
   private func addChildViewControllers(){
    
        //1.获取json文件路径
        guard let jsonPath = NSBundle.mainBundle().pathForResource("MainVCSettings.json", ofType: nil) else{
        print("没有获取到json数据")
            return
       }
    
        //2.通过文件路径创建NSData

        guard  let jsonData = NSData(contentsOfFile: jsonPath) else{
            return
        }

        //3.序列化json数据->array
        guard let result = try? NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) else{
            return
        }

         guard let dictArray = result as? [[String: AnyObject]] else{
            return
        }

        //4.遍历数组,动态创建控制器
        for dict in dictArray
        {
           
            guard let vcName = dict["vcName"] as? String else{
                continue
            }
            
            guard let title = dict["title"] as? String else{
                continue
            }
            
            guard let imageName = dict["imageName"] as? String else{
                continue
            }
            
            addChildViewController(vcName, title:title, imageName: imageName)

        }
    }
    /**
     初始化子控制器
     
     - parameter childVC:   要初始化的子控制器
     - parameter title:     子控制器标题栏
     - parameter imageName: 子控制器他图片名称
     */
    private func addChildViewController(childControllerName:String,title:String,imageName:String) {

        //0.动态获取命名空间
        guard let nameStr = NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as? String else{
            print("没有获取到命名空间")
            return
        }
        //1.将字符串转换为类
        //1.1默认情况下命名空间就是项目的名称,但是命名空间的名称是可以修改的
        guard let AnyClass = NSClassFromString(nameStr + "." + childControllerName) else{
            print("没有创建出来对应的类")
            return
        }
        //1.2通过类创建对象
        //1.2.1将AnyClass转换成指定类型
        guard let vcClass = AnyClass as? UIViewController.Type else{
            return
        }
        //1.2.2通过class创建对象
        let vc = vcClass.init()
        
        //2.设置子控制器对应的数据
        vc.title = title
        vc.tabBarItem.image = UIImage(named: imageName)
        vc.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        
        //3.设置导航控制器根控制器为当前控制器
        let navC = UINavigationController(rootViewController: vc)
        
        addChildViewController(navC)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
