//
//  DatabaseProtocol.swift
//  weatherApp
//
//  Created by Dmytro Pogrebniak on 7/8/19.
//  Copyright © 2019 Dmytro Pogrebniak. All rights reserved.
//

import Foundation
import GRDB


class Database : NSObject {
    
    internal var path = Bundle.main.path(forResource: "CitiesDatabase", ofType: "sqlite")!
    
    override init() {
        
        super.init() 
        initDatabase()
    }
    
    internal func initDatabase() {
        
        var config = Configuration()
        config.readonly = false
        
        do {
            citiesDbQueue = try DatabaseQueue(path: path, configuration: config)
            
        } catch {
            
            print(error)
            return
        }
    }
    
    internal func dropTable(with name : String) {
        
        do {
            try citiesDbQueue.write { db in
                try db.drop(table: name.removeWhitespace())
            }
        } catch {
            
            print(error)
            return
        }
    }
}


