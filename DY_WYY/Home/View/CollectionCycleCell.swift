//
//  CollectionCycleCell.swift
//  DY_WYY
//
//  Created by 褚红钦 on 2017/3/24.
//  Copyright © 2017年 褚红钦. All rights reserved.
//

import UIKit

class CollectionCycleCell: UICollectionViewCell {
    
    //控件属性
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    //定义模型属性
    var cycleModel:CycleModel?{
        didSet{
            titleLabel.text  = cycleModel?.title
            let iconURL =  URL.init(string: cycleModel?.pic_url ?? "")
            iconImageView.kf.setImage(with: iconURL, placeholder: UIImage(named: "Img_default"))
        }
    }
    

}
