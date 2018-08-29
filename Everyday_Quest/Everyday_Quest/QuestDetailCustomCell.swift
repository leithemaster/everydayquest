//
//  QuestDetailCustomCell
//  Everyday_Quest
//
//  Created by Liem Nguyen on 3/13/18.
//  Copyright © 2018 Liem Nguyen. All rights reserved.
//

import UIKit

class QuestDetailCustomCell: UITableViewCell {

    @IBOutlet weak var displayItem: UILabel!
    @IBOutlet weak var checkMark: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
