//
//  CollectionHeaderView.swift
//  DY_WYY
//
//  Created by 褚红钦 on 2017/3/22.
//  Copyright © 2017年 褚红钦. All rights reserved.
//

import UIKit

class CollectionHeaderView: UICollectionReusableView {
    //控件属性
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageview: UIImageView!
    
    //定义一个模型属性
    var group :AnchorGroup? {
        didSet{
            titleLabel.text = group?.tag_name
            iconImageview.image = UIImage(named: group?.icon_name ?? "home_header_normal")
        }
    }
}
