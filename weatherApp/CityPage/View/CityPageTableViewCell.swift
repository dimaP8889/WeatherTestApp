//
//  CityPageTableViewCell.swift
//  weatherApp
//
//  Created by Dmytro Pogrebniak on 7/11/19.
//  Copyright © 2019 Dmytro Pogrebniak. All rights reserved.
//

import UIKit

class CityPageTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel! {
        
        didSet {
            dateLabel.textAlignment = .center
            dateLabel.font = UIFont(name: "Helvetica", size: 18)
            dateLabel.textColor = UIColor.white
        }
    }
    @IBOutlet weak var temperatureLabel: UILabel! {
        
        didSet {
            temperatureLabel.textAlignment = .center
            temperatureLabel.font = UIFont(name: "Helvetica", size: 18)
            temperatureLabel.textColor = UIColor.white
        }
    }
    @IBOutlet weak var weatherIcon: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
