//
//  QRCodeViewController.swift
//  FJWeibo
//
//  Created by Francis on 16/3/9.
//  Copyright © 2016年 FRAJ. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeViewController: UIViewController {
    
    //扫描结果
    @IBOutlet weak var resultLabel: UILabel!
    //扫描视图view
    @IBOutlet weak var scanLineView: UIImageView!
    //扫描框高度约束
    @IBOutlet weak var containerHeightCons: NSLayoutConstraint!
    //扫描视图顶部约束
    @IBOutlet weak var scanLineCons: NSLayoutConstraint!
    //容器视图
    @IBOutlet var containerView: UIView!
    //底部tabBar
    @IBOutlet weak var customTabBar: UITabBar!
    
    
    @IBAction func photoBtnClick(sender: AnyObject) {
        
        print(__FUNCTION__)
    }

    
    //关闭按钮点击
    @IBAction func closeBtnClick(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customTabBar.selectedItem = customTabBar.items![0]
        customTabBar.delegate = self
        
        //初始化二维码扫描
        setUpScanQRCode()
        
    }

    
    private func startAnimation(){
        //停止之前的动画
        scanLineView.layer.removeAllAnimations()
        
        //设置约束开始位置
        scanLineCons.constant = -containerHeightCons.constant
        view.layoutIfNeeded()
        
        
        //执行扫描动画
        
        UIView.animateWithDuration(2.0, animations: { () -> Void in
            //1.修改约束
            self.scanLineCons.constant = self.containerHeightCons.constant
            //设置动画执行次数
            UIView.setAnimationRepeatCount(MAXFLOAT)
            //2.刷新界面
            self.view.layoutIfNeeded()
            }, completion: nil)
         
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        startAnimation()

    }
    

    
    
    //MARK: - 懒加载
    //输入设备
    private lazy var inputDevice:AVCaptureDeviceInput? = {
        
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        return try? AVCaptureDeviceInput(device: device)
    }()
    //输出对象
    private lazy var output: AVCaptureMetadataOutput = {
        //1.创建输出对象
        let metadataOutput = AVCaptureMetadataOutput()
        //2.获取容器视图的frame
        let containerFrame = self.containerView.frame
        let screenFrame = UIScreen.mainScreen().bounds
        //3.计算frame参数比例
        let x = containerFrame.origin.y / screenFrame.size.height
        let y = containerFrame.origin.x / screenFrame.size.width
        let width  = containerFrame.size.height / screenFrame.size.height
        let height = containerFrame.size.width / screenFrame.size.width
        //4.设置解析数据感应区域
        metadataOutput.rectOfInterest = CGRect(x: x, y: y, width: width, height: height)
        //5.返回输出对象
        return metadataOutput
        
        }()
    //会话
    private lazy var session = AVCaptureSession()
    
    //预览图层
    private lazy var previewLayer:AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: self.session)
        
        return layer
    }()
    
    //用于保存描边的图层
    private lazy var containerLayer = CALayer()
    
  
    
}

   //MARK: - 二维码相关
extension QRCodeViewController:AVCaptureMetadataOutputObjectsDelegate{
    
    
    private func setUpScanQRCode(){
        
        //1.判断输入对象是否可以添加到会话中
        if !session.canAddInput(inputDevice) {return}
        //2.判断输出对象是否可以添加到会话中
        if !session.canAddOutput(output) {return}
        
        //3.将输入输出对象添加到会话中
        session.addInput(inputDevice)
        session.addOutput(output)
        
        //4.设置输出对象能够解析的数据类型
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        
        //5.设置代理监听解析扫描之后的数据
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        
        //6.设置预览界面
        previewLayer.frame = view.bounds
        view.layer.insertSublayer(previewLayer, atIndex: 0)
        
        //7.设置描边图层
        containerLayer.frame = view.frame
        containerLayer.backgroundColor = UIColor.clearColor().CGColor
        view.layer.addSublayer(containerLayer)
        
        //8.开始扫描二维码
        session.startRunning()
        
    }
    
    //MARK: - AVCaptureMetadataOutputObjectsDelegate
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        //清空之前的线段
        if let sublayers = containerLayer.sublayers{
            for layer in sublayers{
                layer.removeFromSuperlayer()
            }
        }
        
        
        
        for objc in metadataObjects{
            let temp = objc as! AVMetadataMachineReadableCodeObject
            
            print(temp.stringValue)
            resultLabel.text = temp.stringValue
            
            
            //1.利用预览图层将corners转换为我们可识别的类型
            let metadataObject = previewLayer.transformedMetadataObjectForMetadataObject(objc as! AVMetadataObject)
            
            //2.取出转换之后的corners
            let corners = (metadataObject as! AVMetadataMachineReadableCodeObject).corners
            
            //3.遍历字典数组, 将字典数组中的字典转换为CGPoint
            var index = 0
            var point = CGPointZero
            
            CGPointMakeWithDictionaryRepresentation((corners[index] as! CFDictionary), &point)
            index++
            
            let path = UIBezierPath()
            path.moveToPoint(point)
            
            while index < corners.count{
                CGPointMakeWithDictionaryRepresentation((corners[index] as! CFDictionary), &point)
                path.addLineToPoint(point)
                index++
                
            }
            
            path.closePath()
            
            //4.绘图
            let shapeLayer = CAShapeLayer()
            shapeLayer.lineWidth = 5
            shapeLayer.strokeColor = UIColor.redColor().CGColor
            shapeLayer.fillColor = UIColor.clearColor().CGColor
            shapeLayer.path = path.CGPath
            
            containerLayer.addSublayer(shapeLayer)    
            
        }
        
    }
   
}

//MARK: - UITabBarDelegate
extension QRCodeViewController: UITabBarDelegate{
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem){
        //1.修改扫描视图高度
        if item.tag == 0{
            print("二维码")
            self.containerHeightCons.constant = 300
        }else{
            print("条形码")
            self.containerHeightCons.constant = 150
        }
        
        //2.重新开始动画
        startAnimation()
        
    }
    
}






