//
//  City.swift
//  weatherApp
//
//  Created by Dmytro Pogrebniak on 7/8/19.
//  Copyright © 2019 Dmytro Pogrebniak. All rights reserved.
//

import Foundation
import SwiftyJSON
import GRDB

class CityInfo : NSObject {
    
    private var date : String!
    private var weather : Int!
    private var temperature : String!
    
    init(info : JSON) {
        
        super.init()
        
        let date = info["dt"].doubleValue
        let temperature = info["temp"]["day"].floatValue
        
        self.temperature = String(format: "%.0f", temperature) + "°"
        self.date = date.convertTimeStampToDate()
        self.weather = info["weather"][0]["id"].intValue
        
    
    }
    
    init(row : Row) {
        
        date = row["date"]
        weather = row["weather"]
        temperature = row["temperature"]
    }
    
    func setWeatherIcon() -> String {
    
        switch (weather!) {
        
        case 0...300 :
        return "tstorm1"
        
        case 301...500 :
        return "light_rain"
        
        case 501...600 :
        return "shower3"
        
        case 601...700 :
        return "snow4"
        
        case 701...771 :
        return "fog"
        
        case 772...799 :
        return "tstorm3"
        
        case 800 :
        return "sunny"
        
        case 801...804 :
        return "cloudy2"
        
        case 900...903, 905...1000  :
        return "tstorm3"
        
        case 903 :
        return "snow5"
        
        case 904 :
        return "sunny"
        
        default :
        return "dunno"
        }
    
    }
    
    func setWeatherImage() -> String {
        
        switch (weather!) {
            
        case 0...300 :
            return "storm"
            
        case 301...500 :
            return "lightrain"
            
        case 501...600 :
            return "shower"
            
        case 601...700 :
            return "snow"
            
        case 701...771 :
            return "fogImg"
            
        case 772...799 :
            return "storm"
            
        case 800 :
            return "sunnyImg"
            
        case 801...804 :
            return "clouds"
            
        case 900...903, 905...1000  :
            return "storm"
            
        case 903 :
            return "snow"
            
        case 904 :
            return "sunny"
            
        default :
            return "dunno"
        }
        
    }
    
    func getCityDate() -> String {
        
        return date
    }
    
    func getCityWeather() -> Int {
        
        return weather
    }
    
    func getCityTemperature() -> String {
        
        return temperature
    }
}
