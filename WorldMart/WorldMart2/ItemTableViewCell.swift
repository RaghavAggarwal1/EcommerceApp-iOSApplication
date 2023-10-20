//
//  ItemTableViewCell.swift
//  WorldMart2
//
//  Created by Raghav Aggarwal on 4/16/21.
//

import UIKit
import Firebase

class ItemTableViewCell: UITableViewCell {

    
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemShipping: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
