//
//  UIColor-Extension.swift
//  DY_WYY
//
//  Created by 褚红钦 on 2017/3/21.
//  Copyright © 2017年 褚红钦. All rights reserved.



//给uicolor扩展方法

import UIKit

extension UIColor{
    convenience init(r:CGFloat,g:CGFloat,b:CGFloat) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
}
