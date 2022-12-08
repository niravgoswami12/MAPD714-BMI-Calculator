//
//  TableViewCell.swift
//  BMICalculator
//
//  Created by Nirav Goswami on 2022-12-08.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet var weightLabel: UILabel!
    @IBOutlet var bmiLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
