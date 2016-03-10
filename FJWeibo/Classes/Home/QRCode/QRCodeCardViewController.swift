//
//  QRCodeCardViewController.swift
//  FJWeibo
//
//  Created by Francis on 16/3/10.
//  Copyright © 2016年 FRAJ. All rights reserved.
//

import UIKit

class QRCodeCardViewController: UIViewController {

    @IBOutlet weak var customImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //1.创建滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        //2.还原滤镜
        filter?.setDefaults()
        //3.设置数据
        let data = "FRAJ".dataUsingEncoding(NSUTF8StringEncoding)
        filter?.setValue(data, forKey: "inputMessage")
        //4.从滤镜中取出数据
        guard var ciImage = filter?.outputImage else{
            return
        }
        //5.设置图片的清晰度
        let transform = CGAffineTransformMakeScale(10, 10)
        ciImage = ciImage.imageByApplyingTransform(transform)
        
        let image = UIImage(CIImage: ciImage)
        
        customImageView.image = image
        

    }
    
    private func createNonInterpolatedUIImageFromCIImage(image: CIImage,size: CGFloat) -> UIImage
    {
        let extent:CGRect = CGRectIntegral(image.extent)
        let scale:CGFloat = min(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent))
        
        
        let width = CGRectGetWidth(extent) * scale
        let height = CGRectGetHeight(extent) * scale

        let cs: CGColorSpaceRef =  CGColorSpaceCreateDeviceGray()!
        let bitmapRef = CGBitmapContextCreate(nil, Int(width), Int(height), 8, 0, cs, 0)
        
        let context = CIContext(options: nil)
        let bifmapImage:CGImageRef = context.createCGImage(image, fromRect: extent)
        
        CGContextSetInterpolationQuality(bitmapRef, CGInterpolationQuality.None)
        CGContextScaleCTM(bitmapRef, scale, scale)
        
        CGContextDrawImage(bitmapRef, extent, bifmapImage)
        
        //保存到图片
        let scaledImage:CGImageRef = CGBitmapContextCreateImage(bitmapRef)!
        
        return UIImage(CGImage: scaledImage)
        
    }


}
