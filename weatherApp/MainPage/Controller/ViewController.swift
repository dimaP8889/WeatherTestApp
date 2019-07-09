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
    
    @IBOutlet weak var citiesTableView: UITableView! {
        
        didSet {
            
            citiesTableView.delegate = self
            citiesTableView.dataSource = self
            citiesTableView.backgroundColor = UIColor(named: "#2e3131")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        citiesTableView.register(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "WeatherCell")
        
        if !citiesDb.checkTableExist() {
            
            citiesDb.createTable(with: "cities")
            requestCityInfo(for: "Kiev", completion: nil)
            requestCityInfo(for: "Lviv") {
                
                self.citiesTableView.reloadData()
            }
        } else {
//            citiesDb.deleteCity(with: "London")
//            citiesDb.dropTable(with: "cities")
            updateCitiesInfo()
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func resfreshInfo(_ sender: Any) {
        
        updateCitiesInfo()
    }
    
    @IBAction func addCity(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add city", message: "Type city to add it", preferredStyle: .alert) // create alert controller
        let action = UIAlertAction(title: "Add", style: .default) { (alertAction) in // add action
            
            let textField = alert.textFields![0] as UITextField // text from textField
            self.requestCityInfo(for: textField.text!) { // request city
                self.citiesTableView.reloadData()
            }
        }
        alert.addTextField { (textField) in // add placeholderß
            textField.placeholder = "Enter city"
        }
        
        alert.addAction(action) // add action
        self.present(alert, animated: true, completion: nil)
    }
    
    private func requestCityInfo(for city : String, completion : (() -> ())?) { // request city info from api
        
        let params : [String : String] = ["q" : city, "appid" : APP_ID, "units" : "metric", "cnt" : "7"]
        
        Service.sharedInstances.getWeatherData(url: WEATHER_URL, parameters: params, completion: { (info) in
            
            self.citiesDb.addCity(info: info)
            completion?()
        }) { (error) in
            
        }
    }
    
    private func updateCitiesInfo() {
        
        let cities = citiesDb.getNamesOfCities() // get list of cities
        let myGroup = DispatchGroup()
        
        cities.enumerated().forEach { citiesDb.deleteCity(with: $0.element) } // delete city info
        
        for city in cities { // add city info
            
            myGroup.enter()
            requestCityInfo(for: city) {
                myGroup.leave()
            }
        }
        
        myGroup.notify(queue: DispatchQueue.main) { // reload table
            
            self.citiesTableView.reloadData()
        }
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let cities = citiesDb.getNamesOfCities()
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell") as? WeatherTableViewCell {
            
            let cities = citiesDb.getNamesOfCities()
            let cityWheather = citiesDb.getCityWeather(for: cities[indexPath.row]) // get city info
            
            cell.cityLabel.text = cities[indexPath.row]
            cell.degreeLabel.text = cityWheather?.getCityTemperature()
            cell.backgroundImage.image = UIImage(named: (cityWheather?.setWeatherImage())!)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

