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
    
    var cities : [ForecastInfo] = []
    let citiesDb = CitiesDatabase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !citiesDb.checkTableExist(with: "cities") {
            
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
        
        
    }
    
    func requestCityInfo(for city : String) { // request city info from api
        
        let params : [String : String] = ["q" : city, "appid" : APP_ID, "units" : "metric", "cnt" : "7"]
        
        Service.sharedInstances.getWeatherData(url: WEATHER_URL, parameters: params, completion: { (info) in
            
            print(info.getCityInfo().city)
            self.citiesDb.addCity(info: info)
            self.cities.append(info)
        }) { (error) in
            
            print(error as Any)
        }
    }
    
    func updateCitiesInfo() {
        
        let cities = citiesDb.getNamesOfCities(with: "cities")

        print(cities)
        citiesDb.dropTable(with: "cities")
        citiesDb.createTable(with: "cities")
        self.cities.removeAll()
        
        cities.forEach { (city) in
            
            requestCityInfo(for: city)
        }
    }
}

