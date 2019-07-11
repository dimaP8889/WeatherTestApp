//
//  CitiesDatabase.swift
//  weatherApp
//
//  Created by Dmytro Pogrebniak on 7/8/19.
//  Copyright © 2019 Dmytro Pogrebniak. All rights reserved.
//

import Foundation
import GRDB
import SwiftyJSON

protocol CitiesDatabaseInterface {
    
    func createTable(with name : String) // create table
    func checkTableExist() -> Bool // check if table exist
    
    func addCity(info : ForecastInfo) // add new city
    func deleteCity(with name : String) // delete city from table
    
    func updateCityWeather(for city : String, with cityInfo : ForecastInfo) // update weather for city
    
    func getCityWeather(for city : String) -> CityInfo? // get city weather for one day
    func getCityFullWeather(for city : String) -> ForecastInfo? // get city weather for a week
    
    func getNamesOfCities() -> [String] // get names of cities in table
}

class CitiesDatabase : Database, CitiesDatabaseInterface {
    
    private var forecastDb = DatesDatabase()
    
    // MARK: - fetch table
    func checkTableExist() -> Bool {
        
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
    
    // MARK: - Change city data
    func addCity(info : ForecastInfo) {
        
        let city = info.getCityInfo().city
        
        do {
            
            try forecastDb.createTable(with: info)
            try citiesDbQueue.write { db in
                
                try db.execute(sql: "INSERT INTO cities (city) VALUES (?)", arguments: ["\(city)"])
            }
        } catch {
            
            print(error)
            return
        }
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
    
    func updateCityWeather(for city : String, with cityInfo : ForecastInfo) {
        
        forecastDb.updateCityInfo(with: cityInfo.getCityInfo().info, and: city)
    }
    
    // MARK: - get cities name
    func getNamesOfCities() -> [String] {
        
        do {
            return try citiesDbQueue.read { db in
                let row = try Row.fetchAll(db, sql: "SELECT * FROM cities ORDER BY city ASC")
                
                return row.map({ (row) -> String in
                    return row["city"]
                })
            }
        } catch {
            
            print(error)
            return []
        }
    }
    
    // MARK: - get weather info
    func getCityWeather(for city : String) -> CityInfo? {
        
        return forecastDb.getTodayWeather(for: city)
    }
    
    func getCityFullWeather(for city : String) -> ForecastInfo? {
        
        return forecastDb.getWholeWeather(for: city)
    }
}
