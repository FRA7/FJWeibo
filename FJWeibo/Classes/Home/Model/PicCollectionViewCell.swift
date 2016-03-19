//
//  PicCollectionViewCell.swift
//  FJWeibo
//
//  Created by Francis on 16/3/19.
//  Copyright © 2016年 FRAJ. All rights reserved.
//

import UIKit

class PicCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var picImageView: UIImageView!

    var picURL:NSURL?{
        didSet{
            picImageView?.sd_setImageWithURL(picURL, placeholderImage: UIImage(named: "empty_picture"))
        }
    }
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
       
 
            
            
        }


}
