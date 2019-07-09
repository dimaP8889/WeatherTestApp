//
//  ViewController.swift
//  weatherApp
//
//  Created by Dmytro Pogrebniak on 7/8/19.
//  Copyright © 2019 Dmytro Pogrebniak. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/forecast/daily"
    let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    
    let citiesDb = CitiesDatabase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !citiesDb.checkTableExist() {
            
            citiesDb.createTable(with: "cities")
            requestCityInfo(for: "Kiev")
            requestCityInfo(for: "Lviv")
        } else {
            
            updateCitiesInfo()
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func resfreshInfo(_ sender: Any) {
        
        updateCitiesInfo()
    }
    
    @IBAction func addCity(_ sender: Any) {
        
        requestCityInfo(for: "London")
    }
    
    private func requestCityInfo(for city : String) { // request city info from api
        
        let params : [String : String] = ["q" : city, "appid" : APP_ID, "units" : "metric", "cnt" : "7"]
        
        Service.sharedInstances.getWeatherData(url: WEATHER_URL, parameters: params, completion: { (info) in
            
            self.citiesDb.addCity(info: info)
            print(self.citiesDb.getNamesOfCities())
        }) { (error) in
            
            print(error as Any)
        }
    }
    
    private func updateCitiesInfo() {
        
        let cities = citiesDb.getNamesOfCities() // get list of cities
        
        cities.enumerated().forEach { citiesDb.deleteCity(with: $0.element) } // delete city info
        cities.enumerated().forEach { requestCityInfo(for: $0.element) } // add city info
    }
}

