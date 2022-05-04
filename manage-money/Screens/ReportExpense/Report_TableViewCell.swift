//
//  Report_TableViewCell.swift
//  manage-money
//
//  Created by Thu Tinh on 03/05/2022.
//

import UIKit

class Report_TableViewCell: UITableViewCell {

    @IBOutlet weak var lbContent: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbMustHave: UILabel!
    @IBOutlet weak var lbNiceToHave: UILabel!
    @IBOutlet weak var lbWasted: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
