//
//  TimeStampExtension.swift
//  weatherApp
//
//  Created by Dmytro Pogrebniak on 7/11/19.
//  Copyright © 2019 Dmytro Pogrebniak. All rights reserved.
//

import Foundation

extension Double {
    
    func convertTimeStampToDate() -> String {
        
        let date = Date(timeIntervalSince1970: self)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        
        return strDate
    }
}
