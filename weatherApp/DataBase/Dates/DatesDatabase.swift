//
//  DatesDatabase.swift
//  weatherApp
//
//  Created by Dmytro Pogrebniak on 7/8/19.
//  Copyright © 2019 Dmytro Pogrebniak. All rights reserved.
//

import Foundation
import GRDB

class DatesDatabase : Database {
    
    private func addInfo(with info : [CityInfo], and name : String) {
        
        for cityForecast in info {
            
            addOneDayInfo(info: cityForecast, city: name)
        }
    }
    
    private func addOneDayInfo(info : CityInfo, city : String) {
        
        do {
            
            let date = info.getCityDate()
            let temperature = info.getCityTemperature()
            let weather = info.getCityWeather()
            let id = info.getId()
            
            try citiesDbQueue.write{ (db) in
                try db.execute(sql: "INSERT into \(city.removeWhitespace()) (date, temperature, weather, id) VALUES (?, ?, ?, ?)", arguments: [date, temperature, weather, id])
            }
            
        } catch {
                
            print(error)
            return
        }
    }
    
    func getWholeWeather(for city : String) -> ForecastInfo? {
        
        do {
            
            return try citiesDbQueue.read { db in
                let row = try Row.fetchAll(db, sql: "SELECT * FROM \(city.removeWhitespace()) ORDER BY datetime(date) ASC")
                let cityInfo = ForecastInfo(city: city, row: row)

                return cityInfo
            }
            
        } catch {
            
            print(error)
            return nil
        }
    }
    
    func getTodayWeather(for city : String) -> CityInfo? {
        
        do {
            
            return try citiesDbQueue.read { db -> CityInfo? in
                
                let row = try Row.fetchOne(db, sql: "SELECT * FROM \(city.removeWhitespace()) ORDER BY datetime(date) DESC LIMIT 1")
                
                guard row != nil else { return nil }
                return CityInfo(row: row!)
            }
            
        } catch {
            
            print(error)
            return nil
        }
    }
    
    func updateCityInfo(with info : [CityInfo], and name : String) {
        
        for oneCityInfo in info {
            
            updateOneDay(with: oneCityInfo, and: name)
        }
    }
    
    private func updateOneDay(with info : CityInfo, and name : String) {
        
        let date = info.getCityDate()
        let temperature = info.getCityTemperature()
        let weather = info.getCityWeather()
        let id = info.getId()
        
        do {
            try citiesDbQueue.write { db in
                try db.execute(sql: "UPDATE \(name.removeWhitespace()) SET date = ?, temperature = ?, weather = ?  WHERE id = ?", arguments: [date, temperature, weather, id])
            }
        } catch {
            
            print(error)
            return
        }
    }
    
    func createTable(with info : ForecastInfo) throws {
        
        let name = info.getCityInfo().city.removeWhitespace()
        
        do {
            
            try citiesDbQueue.write { db in
                try db.execute(sql: """
                CREATE TABLE \(name) (
                    date TEXT NOT NULL,
                    temperature TEXT NOT NULL,
                    weather INT NOT NULL,
                    id INT NOT NULL
                )
                """)
            }
        } catch {
            print(error)
            throw error
        }
        
        addInfo(with: info.getCityInfo().info, and : name)
    }
}
