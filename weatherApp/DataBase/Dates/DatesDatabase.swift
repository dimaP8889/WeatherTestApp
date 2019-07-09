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
            
            try citiesDbQueue.write{ (db) in
                try db.execute(sql: "INSERT into \(city) (date, temperature, weather) VALUES (?, ?, ?)", arguments: [date, temperature, weather])
            }
            
        } catch {
                
            print(error)
            return
        }
    }
    
    func getWholeWeather(for city : String) -> [CityInfo] {
        
        do {
            
            return try citiesDbQueue.read { db in
                let row = try Row.fetchAll(db, sql: "SELECT * FROM \(city) ORDER BY datetime(date) DESC")
                
                print(row)
                return []
            }
            
        } catch {
            
            print(error)
            return []
        }
    }
    
    func getTodayWeather(for city : String) -> CityInfo? {
        
        do {
            
            return try citiesDbQueue.read { db -> CityInfo? in
                
                let row = try Row.fetchOne(db, sql: "SELECT * FROM \(city) ORDER BY datetime(date) DESC LIMIT 1")
                
                guard row != nil else { return nil }
                return CityInfo(row: row!)
            }
            
        } catch {
            
            print(error)
            return nil
        }
    }
    
    func createTable(with info : ForecastInfo) throws {
        
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
            throw error
        }
        
        addInfo(with: info.getCityInfo().info, and : name)
    }
}
