//
//  RubyTableViewCell.swift
//  ruby_sample
//
//  Created by 根岸裕太 on 2018/12/08.
//  Copyright © 2018年 根岸裕太. All rights reserved.
//

import UIKit

class RubyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var rubyLabel: RubyLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
