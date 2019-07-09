//
//  DatesDatabase.swift
//  weatherApp
//
//  Created by Dmytro Pogrebniak on 7/8/19.
//  Copyright © 2019 Dmytro Pogrebniak. All rights reserved.
//

import Foundation
import GRDB

class DatesDatabase {
    
    func addInfo(with info : [CityInfo], and name : String) {
        
        for cityForecast in info {
            
            addOneDayInfo(info: cityForecast, city: name)
        }
    }
    
    private func addOneDayInfo(info : CityInfo, city : String) {
        
        do {
            
            let date = info.getCityDate()
            let temperature = info.getCityTemperature()
            let weather = info.getCityTemperature()
            
            try citiesDbQueue.write{ (db) in
                try db.execute(sql: "INSERT into \(city) (date, temperature, weather)", arguments: [date, temperature, weather])
            }
            
        } catch {
                
            print(error)
            return
        }
    }
    
    func getTodayWeather() {
        
    }
    
    func getWeather() {
        
    }
}

extension DatesDatabase {
    
    func createTable(with info : ForecastInfo) {
        
        let name = info.getCityInfo().city
        
        do {
            
            try citiesDbQueue.write { db in
                try db.execute(sql: """
                CREATE TABLE \(name) (
                    date TEXT NOT NULL,
                    temperature TEXT NOT NULL,
                    weather INT NOT NULL
                )
                """)
            }
        } catch {
            print(error)
            return
        }
        
        addInfo(with: info.getCityInfo().info, and : name)
    }
}
