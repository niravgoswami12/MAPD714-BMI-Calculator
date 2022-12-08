//
//  HistoryTableViewCell.swift
//  BMICalculator
//
//  Created by Nirav Goswami on 2022-12-07.
//  Nirav Goswami (Student ID: 301252385)

import UIKit

class HistoryTableViewCell: UITableViewCell {
    var weightLabel: UILabel!
    var bmiLabel: UILabel!
    var categoryLabel: UILabel!
    var dateLabel: UILabel!
    var cellView: UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
                
        let weightValueRect = CGRect(x:20, y:0, width: 200, height: 40)
        weightLabel = UILabel(frame: weightValueRect)
        weightLabel.textColor = UIColor.white
        weightLabel.font = UIFont(name: weightLabel.font.fontName, size: 15)
        contentView.addSubview(weightLabel)
        
        let bmiValueRect = CGRect(x:20, y:16, width: 100, height: 40)
        bmiLabel = UILabel(frame: bmiValueRect)
        bmiLabel.textColor = UIColor.white
        bmiLabel.font = UIFont(name: bmiLabel.font.fontName, size: 15)
        contentView.addSubview(bmiLabel)
        
        let bmiCategoryRect = CGRect(x:120, y:16, width: 200, height: 40)
        categoryLabel = UILabel(frame: bmiCategoryRect)
        categoryLabel.textColor = UIColor.white
        categoryLabel.font = UIFont(name: categoryLabel.font.fontName, size: 15)
        contentView.addSubview(categoryLabel)
        
        let dateValueRect = CGRect(x:20, y:48, width: 200, height: 40)
        dateLabel = UILabel(frame: dateValueRect)
        dateLabel.textColor = UIColor.white
        dateLabel.font = UIFont(name: dateLabel.font.fontName, size: 12)
        contentView.addSubview(dateLabel)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }

}


