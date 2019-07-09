//
//  AppDelegate.swift
//  weatherApp
//
//  Created by Dmytro Pogrebniak on 7/8/19.
//  Copyright © 2019 Dmytro Pogrebniak. All rights reserved.
//

import UIKit
import GRDB

var citiesDbQueue : DatabaseQueue!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        try! setupCitiesDatabase(application, databaseName: "DatesDatabase.sqlite")
        
        // Override point for customization after application launch.
        return true
    }
    
    private func setupCitiesDatabase(_ application: UIApplication, databaseName : String) throws {
        let databaseURL = try FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent(databaseName)
        citiesDbQueue = try DatabaseQueue(path: databaseURL.path)
        
        // Be a nice iOS citizen, and don't consume too much memory
        // See https://github.com/groue/GRDB.swift/blob/master/README.md#memory-management
        citiesDbQueue.setupMemoryManagement(in: application)
    }
}

