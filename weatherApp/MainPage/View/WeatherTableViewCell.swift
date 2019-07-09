//
//  WeatherTableViewCell.swift
//  weatherApp
//
//  Created by Dmytro Pogrebniak on 7/9/19.
//  Copyright © 2019 Dmytro Pogrebniak. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var degreeLabel: UILabel! {
        
        didSet {
            
            degreeLabel.font = UIFont(name: "Helvetica", size: 18)
            degreeLabel.textColor = UIColor.white
            degreeLabel.shadowColor = UIColor.black
        }
    }
    
    @IBOutlet weak var cityLabel: UILabel! {
        
        didSet {
            cityLabel.font = UIFont(name: "Helvetica", size: 18)
            cityLabel.textColor = UIColor.white
            cityLabel.shadowColor = UIColor.black
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.mainView.layer.cornerRadius = 8
        self.mainView.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
