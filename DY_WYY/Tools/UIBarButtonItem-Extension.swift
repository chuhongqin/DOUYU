//
//  UIBarButtonItem-Extension.swift
//  DY_WYY
//
//  Created by 褚红钦 on 2017/3/21.
//  Copyright © 2017年 褚红钦. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    class func creatItem(image : UIImage,hightImage : UIImage,size:CGSize)->UIBarButtonItem{
        let btn = UIButton()
        btn.setImage(image, for: .normal)
        btn.setImage(hightImage, for: .highlighted)
        btn.frame = CGRect(origin: .zero, size: size)
        return UIBarButtonItem(customView: btn)
    }
}
