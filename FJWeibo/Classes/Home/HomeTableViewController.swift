//
//  HomeTableViewController.swift
//  FJWeibo
//
//  Created by Francis on 16/2/26.
//  Copyright © 2016年 FRAJ. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseTableViewController {

  
    override func viewDidLoad() {
        super.viewDidLoad()

        //1.如果没有登录就设置登录界面
        if !userLogin{
            
            visitorView?.setUpVisitorInfo(true,imageName:"visitordiscover_feed_image_house",message:"关注一些人，回这里看看有什么惊喜")
            return
        }
        
        //2.初始化导航条
        setUpNav()
        
        //3.注册通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "change", name: FJPopoverAnimatorWillShow, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "change", name: FJPopoverAnimatorWillDismiss, object: nil)
        
        
        //4.发送网络请求
        loadStatus()
        
        
        
    }

    deinit {
        //移除通知
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    /**
     设置标题按钮状态
     */
    func change(){
        
        let titleB = navigationItem.titleView as! TitleButton
        titleB.selected = !titleB.selected
    }
    
    
    private func setUpNav(){
        
        //1.初始化导航条按钮
        //设置左边按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem.creatBarButtonItem("navigationbar_friendattention", target: self, action: "leftItemClick")
        //设置右边按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem.creatBarButtonItem("navigationbar_pop", target: self, action: "rightItemClick")
        
        //2.初始化标题按钮
        let titleBtn = TitleButton()
        let name = UserAccountViewModel.shareInstance.screen_name
        FJLog("name = \(name)")
        titleBtn.setTitle(name, forState: UIControlState.Normal)
        titleBtn.addTarget(self, action: "titleButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        navigationItem.titleView = titleBtn
        
    }
    
    func titleButtonClick(btn:TitleButton){

        //1.弹出菜单
        let sb = UIStoryboard(name: "PopoverViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        //2.1设置转场代理
        popoverAnimator.presentFrame = CGRect(x: (UIScreen.mainScreen().bounds.width - 200)*0.5, y: 56, width: 200, height: 300)
        vc?.transitioningDelegate = popoverAnimator
        //2.2设置转场样式
        vc?.modalPresentationStyle = UIModalPresentationStyle.Custom
        
        presentViewController(vc!, animated: true, completion: nil)
        
        
    }
    
     func leftItemClick(){
        FJLog(__FUNCTION__)
       
    }
     func rightItemClick(){

        
        let sb = UIStoryboard(name: "QRCodeViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        
        presentViewController(vc!, animated: true, completion: nil)
    }
    
    //记录菜单是否展开
    var isPresent :Bool = false
    
    
    //定义一个对象保存自定义转场动画
    //MARK: - 懒加载
    private lazy var popoverAnimator:PopoverAnimator = {
        
        let p = PopoverAnimator()
        p.presentFrame = CGRect(x: 100, y: 56, width: 200, height: 350)
        return p
    }()
    private lazy var statusViewModels: [StatusViewModel] = [StatusViewModel]()
    
    
   }
//MARK: - 加载网络请求
extension HomeTableViewController{
    
    private func loadStatus(){
        NetWorkTool.shareInstance.loadStatus { (result, error) -> () in
            //1.错误校验
            if error != nil{
                FJLog(error)
                return
            }
            //2.判断数组是否有值
            guard let resultArray = result else{
                return
            }
            
            //3.边里字典转成模型
            for resultDict in resultArray{
                let status = Status(dict: resultDict)
                let statusViewModel = StatusViewModel(status: status)
                self.statusViewModels.append(statusViewModel)
            }
            
            //4.刷新表格
            self.tableView.reloadData()
            
        }
    }
    
}

//MARK: - tableVeiwDelegete
extension HomeTableViewController{
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return statusViewModels.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let HomeID = "homeID"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(HomeID)
        
        if cell == nil{
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: HomeID)
        }
        
        //给cell设置数据
        let statusViewModel = statusViewModels[indexPath.row]
        cell?.textLabel?.text = statusViewModel.creatAtTimeString
        cell?.detailTextLabel?.text = statusViewModel.status?.user?.screen_name
        
        return cell!
    }
    
}
