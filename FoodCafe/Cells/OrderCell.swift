//
//  OrderCell.swift
//  FoodCafe
//
//  Created by Nishain on 2/28/21.
//  Copyright © 2021 Nishain. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var orderStatus: UILabel!
    @IBOutlet weak var orderID: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
