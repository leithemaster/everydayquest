//
//  CustomCell.swift
//  Everyday_Quest
//
//  Created by Liem Nguyen on 3/13/18.
//  Copyright © 2018 Liem Nguyen. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var listName: UILabel!
    @IBOutlet weak var itemCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
