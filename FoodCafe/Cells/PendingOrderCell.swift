//
//  PendingOrder.swift
//  FoodCafe
//
//  Created by Nishain on 2/23/21.
//  Copyright © 2021 Nishain. All rights reserved.
//

import UIKit

class PendingOrderCell: UITableViewCell {

    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var qty: UILabel!
    var information:PendingOrder?
   
    var onQuantityChange : ((Int)->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func onBtnPress(_ sender: UIButton) {
        //2 - Plus
        //1 - Minus
        onQuantityChange?(sender.tag == 2 ? 1:-1)
    }
    

}
