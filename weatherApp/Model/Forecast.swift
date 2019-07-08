//
//  Forecast.swift
//  weatherApp
//
//  Created by Dmytro Pogrebniak on 7/8/19.
//  Copyright © 2019 Dmytro Pogrebniak. All rights reserved.
//

import Foundation
import SwiftyJSON

class ForecastInfo : NSObject {
    
    private var cityWeather : [String : [CityInfo]] = [:]
    
    init(info : JSON) {
        
        var dailyForecast : [CityInfo] = []
        
        for (_, dayForecast) in info["list"] {
            
            dailyForecast.append(CityInfo(info: dayForecast))
        }
        
        let cityName = info["city"]["name"].stringValue
        
        cityWeather[cityName] = dailyForecast
    }
    
    func addCity(with name : String) {
        
        
    }
    
    func getCityInfo() -> [String : [CityInfo]] {
        
        return cityWeather
    }
}

extension Double {
    
    func convertTimeStampToDate() -> String {
        
        let date = Date(timeIntervalSince1970: self)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        
        return strDate
    }
}
