//
//  SubTableViewCell.swift
//  WBProfileDemo
//
//  Created by 唐标 on 2017/6/22.
//  Copyright © 2017年 jackTang. All rights reserved.
//

import UIKit

class SubTableViewCell: UITableViewCell {

    
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
