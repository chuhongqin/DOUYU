//
//  NetWorkTools.swift
//  DY_WYY
//
//  Created by 褚红钦 on 2017/3/23.
//  Copyright © 2017年 褚红钦. All rights reserved.
//

import UIKit
import Alamofire
enum MethodType{
    case GET
    case POST
}
class NetWorkTools{
    class func requestData(type:MethodType,URLString:String,parameters:[String:String]?=nil,finishCallback:@escaping (_ result:AnyObject)->()){
        //1、获取类型
        let method = type == .GET ? HTTPMethod.get : HTTPMethod.post
        
        //2、发送请求
        Alamofire.request(URLString, method: method, parameters: parameters).responseJSON { (response) in
            //3、获取结果
            guard let result = response.result.value else{
                print(response.error ?? "出错啦哈哈哈😄")
                return
            }
            //4、将结果回调出去
            finishCallback(result as AnyObject)//相当于给闭包方法finishCallback给一个参数位上面计算得出的result之后直接在闭包中用这个result就可以了（方法将计算结果result传给调用者去使用）--（个人理解）
        }
    }
}
