//
//  CitiesDatabase.swift
//  weatherApp
//
//  Created by Dmytro Pogrebniak on 7/8/19.
//  Copyright © 2019 Dmytro Pogrebniak. All rights reserved.
//

import Foundation
import GRDB

class CitiesDatabase : Database {
    
    private var forecastDb = DatesDatabase()
    
    func addCity(info : ForecastInfo) {

        do {
            
            try forecastDb.createTable(with: info)
            try citiesDbQueue.write { db in
                
                try db.execute(sql: "INSERT INTO cities (city) VALUES (?)", arguments: ["\(info.getCityInfo().city)"])
            }
        } catch {
            
            print(error)
            return
        }
    }
    
    internal func checkTableExist() -> Bool {
        
        var exist = true
        
        do {
            exist = try citiesDbQueue.read { db in
                
                return try db.tableExists("cities")
            }
        } catch {
            
            print(error)
            return false
        }
        
        return exist
    }
    
    func getNamesOfCities() -> [String] {
        
        do {
            return try citiesDbQueue.read { db in
                let row = try Row.fetchAll(db, sql: "SELECT * FROM cities ORDER BY city DESC")
                
                return row.map({ (row) -> String in
                    return row["city"]
                })
            }
        } catch {
            
            print(error)
            return []
        }
    }
    
    func getCityWeather(for city : String) -> CityInfo? {
        
        return forecastDb.getTodayWeather(for: city)
    }
    
    func getCityFullWeather(for city : String) -> CityInfo? {
        
        return forecastDb.getTodayWeather(for: city)
    }
    
    func deleteCity(with name : String) {
        
        forecastDb.dropTable(with: name)
        
        do {
            try citiesDbQueue.write { db in
                try db.execute(sql: "DELETE FROM cities WHERE city = ?", arguments: [name])
            }
        } catch {
            
            print(error)
            return
        }
    }
    
    func createTable(with name : String) {
        do {
            try citiesDbQueue.write { db in
                try db.execute(sql: """
                CREATE TABLE cities (
                city TEXT NOT NULL)
                """)
            }
        } catch {
            
            print(error)
            return
        }
    }
}
