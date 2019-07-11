//
//  Forecast.swift
//  weatherApp
//
//  Created by Dmytro Pogrebniak on 7/8/19.
//  Copyright © 2019 Dmytro Pogrebniak. All rights reserved.
//

import Foundation
import SwiftyJSON
import GRDB

class ForecastInfo : NSObject {
    
    private var cityWeather : (city : String, info : [CityInfo])
    
    init(info : JSON) {
        
        var dailyForecast : [CityInfo] = []
        
        for (id, dayForecast) in info["list"] {
            
            dailyForecast.append(CityInfo(info: dayForecast, id: Int(id)!))
        }
        
        let cityName = info["city"]["name"].stringValue
        
        cityWeather.city = cityName
        cityWeather.info = dailyForecast
    }
    
    init(city name : String, row : [Row]) {
        
        var cityForecast : [CityInfo] = []
        for info in row {
            
            cityForecast.append(CityInfo(row: info))
        }
        cityWeather.city = name
        cityWeather.info = cityForecast
    }
    
    func getCityInfo() -> (city : String, info : [CityInfo]) {
        
        return cityWeather
    }
}
