//
//  CollectionNormalCell.swift
//  DY_WYY
//
//  Created by 褚红钦 on 2017/3/22.
//  Copyright © 2017年 褚红钦. All rights reserved.
//

import UIKit

class CollectionNormalCell:CollectionBaseCell {

   
    @IBOutlet weak var roomNameLabel: UILabel!
    //定义模型属性
    
    override var anchor :AnchorModel?{
        
        didSet{
            super.anchor = anchor
            //房间名
            roomNameLabel.text = anchor?.room_name
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImageView.layer.masksToBounds = true
        iconImageView.layer.cornerRadius = 5
        
    }

  
}
