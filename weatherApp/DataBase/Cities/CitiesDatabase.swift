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
            try citiesDbQueue.write { db in
                
                try db.execute(sql: "INSERT INTO cities (city) VALUES (?)", arguments: ["\(info.getCityInfo().city)"])
                forecastDb.createTable(with: info)
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
                let row = try Row.fetchAll(db, sql: "SELECT * FROM cities ORDER BY datetime(id) DESC")
                
                return row.map({ (row) -> String in
                    return row["city"]
                })
            }
        } catch {
            
            print(error)
            return []
        }
    }
    
    func getCityWeather() {
        
    }
    
    func deleteCity() {
        
        self.dropTable(with: "cities")
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
