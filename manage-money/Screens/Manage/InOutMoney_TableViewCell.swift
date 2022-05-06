//
//  InOutMoney_TableViewCell.swift
//  manage-money
//
//  Created by Thu Tinh on 01/05/2022.
//

import UIKit

class InOutMoney_TableViewCell: UITableViewCell {

    @IBOutlet weak var lbMoney: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbType: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbInOut: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
