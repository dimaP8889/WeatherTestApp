//
//  DatabaseProtocol.swift
//  weatherApp
//
//  Created by Dmytro Pogrebniak on 7/8/19.
//  Copyright © 2019 Dmytro Pogrebniak. All rights reserved.
//

import Foundation
import GRDB

protocol TableProtocol {
    
    func dropTable(with name: String) // delete table
    func createTable(with name: String) // create table
    func checkTableExist(with name : String) -> Bool // check if table exist
}

class Database {
    
    internal var path: String
    
    var database : DatabasePool?
    
    init (with path : String) {
        
        self.path = path
        initDatabase()
    }
    
    internal func initDatabase() {
        
        var config = Configuration()
        config.readonly = false
        
        do {
            database = try DatabasePool(path: path, configuration: config)
            
        } catch {
            return
        }
    }
    
    internal func checkTableExist(with name : String) -> Bool {
        
        var exist = false
        
        do {
            exist = try database?.read { db in
                
                try db.tableExists(name)
                } ?? false
        } catch {
            
            return false
        }
        
        return exist
    }
    
    internal func dropTable(with name : String) {
        
        do {
            try database?.write { db in
                try db.drop(table: name)
            }
        } catch {
            
            return
        }
    }
}
