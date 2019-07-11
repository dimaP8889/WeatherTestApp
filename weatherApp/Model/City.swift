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

protocol CityInfoInterface {
    
    func setWeatherIcon() -> String // set little weather icons
    func setWeatherImage() -> String // set background weather images
    
    func getCityDate() -> String
    func getCityWeather() -> Int
    func getCityTemperature() -> String
    func getId() -> Int
}

class CityInfo : NSObject, CityInfoInterface {
    
    private var date : String!
    private var weather : Int!
    private var temperature : String!
    private var id : Int!
    
    init(info : JSON, id : Int) {
        
        super.init()
        
        let date = info["dt"].doubleValue
        let temperature = info["temp"]["day"].floatValue
        
        self.temperature = String(format: "%.0f", temperature) + "°"
        self.date = date.convertTimeStampToDate()
        self.weather = info["weather"][0]["id"].intValue
        self.id = id
    
    }
    
    init(row : Row) {
        
        date = row["date"]
        weather = row["weather"]
        temperature = row["temperature"]
        id = row["id"]
    }
    
    // MARK: - set images
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
    
    // MARK: - Getters
    func getCityDate() -> String {
        
        return date
    }
    
    func getCityWeather() -> Int {
        
        return weather
    }
    
    func getCityTemperature() -> String {
        
        return temperature
    }
    
    func getId() -> Int {
        
        return id
    }
}
