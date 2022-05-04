//
//  WalletCell_TableViewCell.swift
//  manage-money
//
//  Created by Thu Tinh on 30/04/2022.
//

import UIKit

class WalletCell_TableViewCell: UITableViewCell {

    @IBOutlet weak var lbWalletType: UILabel!
    @IBOutlet weak var lbAmount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
