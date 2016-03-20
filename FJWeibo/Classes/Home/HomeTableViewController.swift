//
//  HomeTableViewController.swift
//  FJWeibo
//
//  Created by Francis on 16/2/26.
//  Copyright © 2016年 FRAJ. All rights reserved.
//

import UIKit
import SDWebImage

class HomeTableViewController: BaseTableViewController {

    // MARK:- 懒加载属性
    private lazy var titleBtn : TitleButton = TitleButton(type: .Custom)
    private lazy var popoverAnimator : PopoverAnimator = PopoverAnimator() // 动画管理的对象
    private lazy var statusViewModels : [StatusViewModel] = [StatusViewModel]()
    private lazy var cellHeightCache : [String : CGFloat] = [String : CGFloat]()
    
    //记录菜单是否展开
    var isPresent :Bool = false
    
    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.判断用户是否登录
        if !isLogin {
            visitorView.addRotationAnimate()
            return
        }
        
        // 2.初始化导航栏
        setupNavigationBar()
        
        //4.注册通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "change", name: FJPopoverAnimatorWillShow, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "change", name: FJPopoverAnimatorWillDismiss, object: nil)
        
        // 3.请求数据
        loadStatuses()
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
}


// MARK:- 设置导航栏的内容
extension HomeTableViewController {
    private func setupNavigationBar() {
        // 1.设置左侧的Item
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention", target: self, action: "leftItemClick")
        
        // 2.设置右侧的Item
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop", target: self, action: "rightItemClick")
        
        // 3.设置标题按钮
        
        let name = UserAccountViewModel.shareInstance.account?.screen_name
        titleBtn.setTitle(name, forState: .Normal)
        titleBtn.addTarget(self, action: "titleBtnClick:", forControlEvents: .TouchUpInside)
        navigationItem.titleView = titleBtn
    }
}


// MARK:- 事件监听函数
extension HomeTableViewController {
    @objc private func leftItemClick() {
        FJLog("leftItemClick")
    }
    
    @objc private func rightItemClick() {
//        FJLog("rightItemClick")
        
        let sb = UIStoryboard(name: "QRCodeViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        
        presentViewController(vc!, animated: true, completion: nil)
    }
    
    @objc private func titleBtnClick(titleBtn : TitleButton) {
        //1.弹出菜单
        let sb = UIStoryboard(name: "PopoverViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        //2.1设置转场代理
        popoverAnimator.presentFrame = CGRect(x: (UIScreen.mainScreen().bounds.width - 200)*0.5, y: 56, width: 200, height: 300)
        vc?.transitioningDelegate = popoverAnimator
        //2.2设置转场样式
        vc?.modalPresentationStyle = UIModalPresentationStyle.Custom
        
        presentViewController(vc!, animated: true, completion: nil)    }
}


// MARK:- tableView的数据源方法和代理方法
extension HomeTableViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusViewModels.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 1.创建cell
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeCell") as! HomeViewCell
        
        // 2.给cell设置数据
        cell.statusViewModel = statusViewModels[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        // 0.取出模型对象
        let statusViewModel = statusViewModels[indexPath.row]
        
        // 1.先从缓存池中取出高度
        var cellHeight : CGFloat? = cellHeightCache["\(statusViewModel.status!.id)"]
        if cellHeight != nil {
            return cellHeight!
        }
        
        // 2.取出indexPath对应的cell
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeCell") as! HomeViewCell
        
        // 3.获取cell的高度
        cellHeight = cell.cellHeight(statusViewModel)
        
        // 4.缓存高度
        cellHeightCache["\(statusViewModel.status!.id)"] = cellHeight!
        
        return cellHeight!
    }
}


// MARK:- 网络请求
extension HomeTableViewController {
    /// 请求首页数据
    private func loadStatuses() {
        NetWorkTool.shareInstance.loadStatuses { (result, error) -> () in
            // 1.错误校验
            if error != nil {
                FJLog(error)
                return
            }
            
            // 2.判断数组是否有值
            guard let resultArray = result else {
                return
            }
            
            // 3.遍历数组,将数组中的字典转成模型对象
            for resultDict in resultArray {
                let status = Status(dict: resultDict)
                let statusViewModel = StatusViewModel(status: status)
                self.statusViewModels.append(statusViewModel)
            }
            
            // 4.缓存图片
            self.cacheImages()
        }
    }
    
    /// 缓存图片
    private func cacheImages() {
        //0.创建group
        let group = dispatch_group_create()
        
        // 1.缓存图片
        // 1.1.遍历所有的微博
        for status in statusViewModels {
            // 1.2.遍历所有的微博中url
            for url in status.picURLs {
                
                // 1.3.将一部请求加载group中
                dispatch_group_enter(group)
                
                // 1.4.缓存图片
                SDWebImageManager.sharedManager().downloadImageWithURL(url, options: [], progress: nil, completed: { (_, _, _, _, _) -> Void in
                    FJLog("下载了一张图片")
                    
                    // 1.5.将异步处理从group中移除掉
                    dispatch_group_leave(group)
                })
            }
        }
        
        // 2.刷新表格
        dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
            FJLog("刷新表格")
            self.tableView.reloadData()
        }
    }

}
