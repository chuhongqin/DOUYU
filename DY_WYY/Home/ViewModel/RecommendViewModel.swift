//
//  RecommendViewModel.swift
//  DY_WYY
//
//  Created by 褚红钦 on 2017/3/23.
//  Copyright © 2017年 褚红钦. All rights reserved.
//

import UIKit


class RecommendViewModel {
    //懒加载一个属性存放group数组
    lazy var anchorGroups : [AnchorGroup] = [AnchorGroup]()
    lazy var bigDataGroup : AnchorGroup = AnchorGroup()
    lazy var prettyGroup : AnchorGroup = AnchorGroup()
    lazy var cycleModels:[CycleModel] = [CycleModel]()
    
}

//发送网络请求
extension RecommendViewModel{
    //请求推荐数据
    func requestData(finishCallBack:@escaping ()->()){
        //0、定义参数
        let parameters = ["limit":"4","offset":"4","time":NSDate.getCurrentTime()]
        //0.1创建group
        let dGroup = DispatchGroup.init()
        // 1、请求第一部分推荐数据
        //进入组
        dGroup.enter()
        NetWorkTools.requestData(type: .GET, URLString: "http://capi.douyucdn.cn/api/v1/getbigDataRoom", parameters: ["time":NSDate.getCurrentTime()]) { (result) in
            //1、将result转成字典类型
            guard let resultDict = result as? [String : NSObject ] else{return}
            
            //2、根据data该key获取数组
            guard let dataArray = resultDict["data"] as? [[String:NSObject]] else {return}
            //3------
            //3.2设置组的属性
            self.bigDataGroup.tag_name = "热门"
            self.bigDataGroup.icon_name = "home_header_hot"
            //3.3获取主播数据
            for dict in dataArray{
                let anchor = AnchorModel(dict: dict)
                self.bigDataGroup.anchors.append(anchor)
            }
            //3.4离开组
            
            dGroup.leave()
            
        }
        
        
        // 2、请求第二部分颜值数据
        //进入组
        dGroup.enter()
        NetWorkTools.requestData(type: .GET, URLString: "http://capi.douyucdn.cn/api/v1/getVerticalRoom",parameters: parameters) { (result) in
            //1、将result转成字典类型
            guard let resultDict = result as? [String : NSObject ] else{return}
            
            //2、根据data该key获取数组
            guard let dataArray = resultDict["data"] as? [[String:NSObject]] else {return}
            
            //3、遍历字典并且转成模型对象
            
            //3.2设置组的属性
            self.prettyGroup.tag_name = "颜值"
             self.prettyGroup.icon_name = "home_header_phone"
            //3.3获取主播数据
            for dict in dataArray{
                let anchor = AnchorModel(dict: dict)
                 self.prettyGroup.anchors.append(anchor)
            }
            //4、离开组
            
            dGroup.leave()
        }
        
        // 3、请求 2-12 部分的游戏数据
        //进入组
        dGroup.enter()
        NetWorkTools.requestData(type: .GET, URLString: "http://capi.douyucdn.cn/api/v1/getHotCate", parameters: parameters) { (result) in
            //1、将result转成字典类型
            guard let resultDict = result as? [String : NSObject ] else{return}
            
            //2、根据data该key获取数组
            guard let dataArray = resultDict["data"] as? [[String:NSObject]] else {return}
            //3、遍历数组，获取字典，并将字典转成模型对象
            
            for dict in dataArray {
                let group = AnchorGroup(dict: dict)
                self.anchorGroups.append(group)
            }
            //离开组
            dGroup.leave()
            
        }
        
        //6、所有的数据都请求到之后进行排序
        dGroup.notify(queue:
            .main) { 
                //插入
                self.anchorGroups.insert(self.prettyGroup, at: 0)
                self.anchorGroups.insert(self.bigDataGroup, at: 0)
                finishCallBack()
        }
        
    }
    //请求无限轮播数据
    func requestCycleData(finishCallBack:@escaping ()->()){
        NetWorkTools.requestData(type: .GET, URLString: "http://www.douyutv.com/api/v1/slide/6", parameters: ["version":"2.300"]) { (result) in
            //首先检查result是否有值
            guard let resultDict = result as? [String:NSObject] else{return}
            guard let dataArray = resultDict["data"] as? [[String:NSObject]] else{return}
            for dict in dataArray{
                self.cycleModels.append(CycleModel(dict:dict))
            }
            finishCallBack()
        }
    }
}


