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
    
    override init(with path : String) {
        
        super.init(with : path)
        database = datesDbPool
    }
    
    func addInfo() {
        
    }
    
    func getTodayWeather() {
        
    }
    
    func getWeather() {
        
    }
}

extension DatesDatabase : TableProtocol {
    
    func createTable(with name : String) {
        do {
            try database?.write { db in
                try db.execute(sql: """
            CREATE TABLE \(name) (
                number INT NOT NULL,
                name TEXT NOT NULL,
                temperature TEXT NOT NULL,
                weather INT NOT NULL
            )
            """)
            }
        } catch {
            return
        }
    }
}
