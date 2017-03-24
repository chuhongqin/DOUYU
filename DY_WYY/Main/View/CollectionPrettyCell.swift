//
//  CollectionPrettyCell.swift
//  DY_WYY
//
//  Created by 褚红钦 on 2017/3/22.
//  Copyright © 2017年 褚红钦. All rights reserved.
//

import UIKit
import Kingfisher

class CollectionPrettyCell: CollectionBaseCell {
 
    @IBOutlet weak var cityBtn: UIButton!
    //定义模型属性
    override var anchor :AnchorModel? {
        didSet{
            super.anchor = anchor
            //所在的城市
            cityBtn.setTitle(anchor?.anchor_city, for: .normal)
        }
    }
   
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImageView.layer.cornerRadius = 5
        iconImageView.layer.masksToBounds = true
        onLineBtn.layer.cornerRadius = 3
        onLineBtn.layer.masksToBounds = true
    }

}
