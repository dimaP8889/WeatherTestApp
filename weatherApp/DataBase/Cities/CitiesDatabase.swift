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
    
    let datesDb = DatesDatabase(with: Bundle.main.path(forResource: "DatesDatabase", ofType: "sqlite")!)
    
    override init(with path : String) {
        
        super.init(with: path)
        database = citiesDbPool
    }
    
    func addCity(info : ForecastInfo) {
        
    }
    
    func getCityWeather() {
        
    }
    
    func getNamesOfCities() -> [String] {
        
        return []
    }
    
    func deleteCity(with name : String) {
        
        datesDb.dropTable(with: name)
        self.dropTable(with: name)
    }
}

extension CitiesDatabase : TableProtocol {
    
    func createTable(with name : String) {
        do {
            try database?.write { db in
                try db.execute(sql: """
            CREATE TABLE \(name)) (
                city TEXT NOT NULL,
            )
            """)
            }
        } catch {
            return
        }
    }
}
