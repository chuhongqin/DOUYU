//
//  CollectionBaseCell.swift
//  DY_WYY
//
//  Created by 褚红钦 on 2017/3/23.
//  Copyright © 2017年 褚红钦. All rights reserved.
//

import UIKit

class CollectionBaseCell: UICollectionViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var onLineBtn: UIButton!
    @IBOutlet weak var nikNameLabel: UILabel!
    
    var anchor :AnchorModel?{
        didSet{
            // 0.校验anchor有没有值
            guard let anchor = anchor else {return}
            //1. 取出在线人数显示的数字
            var onLinStr :String = ""
            if anchor.online >= 10000{
                onLinStr = "\(anchor.online/10000)万在线"
            }else{
                onLinStr = "\(anchor.online)在线"
            }
            onLineBtn.setTitle(onLinStr, for: .normal)
            //设置昵称
            nikNameLabel.text  =  anchor.nickname
            //显示封面图片
            guard  let iconURL = URL.init(string: anchor.vertical_src)else{return}
            iconImageView.kf.setImage(with: iconURL)
            
            
        }
    }

}
