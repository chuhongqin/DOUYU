//
//  CycleModel.swift
//  DY_WYY
//
//  Created by 褚红钦 on 2017/3/24.
//  Copyright © 2017年 褚红钦. All rights reserved.
//

import UIKit

class CycleModel: NSObject {
    //先定义一些属性
    //标题
    var title :String = ""
    //图片
    var pic_url:String = ""
    //主播信息对应的字典
    var room :[String:NSObject]?{
        didSet{
            guard let room = room else {
                return
            }
            anchor = AnchorModel(dict: room)
        }
    }
    //主播信息对应的模型对象
    var anchor:AnchorModel?
    
    //自定义构造函数
    init(dict:[String:NSObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
