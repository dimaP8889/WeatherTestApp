//
//  WeatherTableViewCell.swift
//  weatherApp
//
//  Created by Dmytro Pogrebniak on 7/9/19.
//  Copyright © 2019 Dmytro Pogrebniak. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var degreeLabel: UILabel! {
        
        didSet {
            
            degreeLabel.font = UIFont(name: "Helvetica", size: 14)
            degreeLabel.textColor = UIColor.white
            degreeLabel.shadowColor = UIColor.black
        }
    }
    
    @IBOutlet weak var cityLabel: UILabel! {
        
        didSet {
            cityLabel.font = UIFont(name: "Helvetica", size: 14)
            cityLabel.textColor = UIColor.white
            cityLabel.shadowColor = UIColor.black
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 8
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.3
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
        self.layer.shouldRasterize = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
