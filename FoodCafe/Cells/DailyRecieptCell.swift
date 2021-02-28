//
//  DailyRecieptCell.swift
//  FoodCafe
//
//  Created by Nishain on 2/28/21.
//  Copyright © 2021 Nishain. All rights reserved.
//

import UIKit

class DailyRecieptCell: UITableViewCell {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var itemList: UILabel!
    @IBOutlet weak var priceFrequencyList: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
