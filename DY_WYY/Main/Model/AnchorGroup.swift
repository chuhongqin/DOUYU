//
//  AnchorGroup.swift
//  DY_WYY
//
//  Created by 褚红钦 on 2017/3/23.
//  Copyright © 2017年 褚红钦. All rights reserved.
//

import UIKit

class AnchorGroup: NSObject {
    //该组中对应的房间信息
    var room_list : [[String:NSObject]]?{
        didSet{
            guard let room_list = room_list else {return}
                for dict in room_list{
                    anchors.append(AnchorModel(dict: dict))
                }
        }
    }
    //组显示标题
    var tag_name:String = ""
    //该组显示的图标
    var icon_name :String = "home_header_normal"
    //定义主播模型对象数组
    lazy var anchors : [AnchorModel] = [AnchorModel]()
    
    //构造方法，传入一个字典 转成模型对象
    //这里可以根据字典自动初始化（KVC啥的）
    init(dict:[String:NSObject]) {
        super.init()
        setValuesForKeys(dict)
        
    }
    override init() {
        
    }
    
    //setValue:forUndefinedKey:这个方法是关键,只有存在这个方法后,才可以过滤掉不存在的键值对而防止崩溃,同时,setValue:forUndefinedKey:这个方法中还可以改变系统的敏感字,或者,你手动的映射key值不同的值,随你自己喜欢.
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    /*override func setValue(_ value: Any?, forKey key: String) {
        if key == "room_list" {
            if  let dataArray = value as? [[String:NSObject]]{
                for dict in dataArray{
                    anchors.append(AnchorModel(dict: dict))
                }
            }
        }
    }*/
}
