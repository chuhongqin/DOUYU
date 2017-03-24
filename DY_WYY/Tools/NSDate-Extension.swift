//
//  NSDate-Extension.swift
//  DY_WYY
//
//  Created by 褚红钦 on 2017/3/23.
//  Copyright © 2017年 褚红钦. All rights reserved.
//

import Foundation
extension NSDate{
    class func getCurrentTime()->String{
        let nowDate = NSDate()
        let interval = Int(nowDate.timeIntervalSince1970)
        return "\(interval)"
    }
}
