//
//  PopoverAnimator.swift
//  FJWeibo
//
//  Created by Francis on 3/1/16.
//  Copyright © 2016 FRAJ. All rights reserved.
//

import UIKit

//定义常量保存通知
let FJPopoverAnimatorWillShow = "FJPopoverAnimatorWillShow"
let FJPopoverAnimatorWillDismiss = "FJPopoverAnimatorWillDismiss"

class PopoverAnimator:NSObject,UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning{
    
    var isPresent:Bool = false
    
    var presentFrame = CGRectZero
    
    
    //实现代理方法,告诉系统谁来执行转场动画
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController?{
        
        let p = PopoverPresentationController(presentedViewController: presented, presentingViewController: presenting)
        p.presentFrame = presentFrame
        
        return p
        
    }
    //MARK: - 重写modal方法,自定义modal效果
    /**
    告诉系统谁来负责modal的显示动画
    
    - parameter presented:  被展现的动画
    - parameter presenting: 发起的视图
    - returns: 谁来负责
    */
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresent = true
        //发送通知
        NSNotificationCenter.defaultCenter().postNotificationName(FJPopoverAnimatorWillShow, object: self)
        return self
    }
    /**
     告诉系统谁来负责modal的消失动画
     
     - parameter dismissed: 被消失的动画
     - returns: 谁来负责
     */
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        //发送通知
        NSNotificationCenter.defaultCenter().postNotificationName(FJPopoverAnimatorWillDismiss, object: self)
        return self
    }
    //MARK: - 动画
    /**
    返回动画时长
    */
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    /**
     告诉系统如何动画
     */
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if isPresent{
            //展开
            FJLog("展开")
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
            toView.transform = CGAffineTransformMakeScale(1.0, 0.0)
            
            //将试图添加到容器上
            transitionContext.containerView()?.addSubview(toView)
            
            //设置锚点
            toView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.0)
            
            //执行动画
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                //清空transform
                toView.transform = CGAffineTransformIdentity
                }, completion: { (_) -> Void in
                    //告诉系统动画执行完毕
                    transitionContext.completeTransition(true)
            })
            
        }else{
            //关闭
            FJLog("关闭")
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
            
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                //将view压扁
                fromView?.transform = CGAffineTransformMakeScale(1.0, 0.000001)
                }, completion: { (_) -> Void in
                    
                    transitionContext.completeTransition(true)
            })
        }
    }

    
}
