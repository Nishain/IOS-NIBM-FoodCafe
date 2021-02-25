//
//  FoodSmallDetailCell.swift
//  FoodCafe
//
//  Created by Nishain on 2/25/21.
//  Copyright © 2021 Nishain. All rights reserved.
//

import UIKit

class FoodSmallDetailCell: UITableViewCell {

    @IBOutlet weak var promotion: UIPaddingLabel!
    @IBOutlet weak var foodDescription: UILabel!
    @IBOutlet weak var cost: UILabel!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
