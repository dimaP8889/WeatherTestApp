//
//  ViewController.swift
//  weatherApp
//
//  Created by Dmytro Pogrebniak on 7/8/19.
//  Copyright © 2019 Dmytro Pogrebniak. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {
    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/forecast/daily"
    let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    
    let citiesDb = CitiesDatabase()
    private var selectedCityInfo : ForecastInfo?
    
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
        
        if !citiesDb.checkTableExist() { // check if table exist
            
            citiesDb.createTable(with: "cities")
            
            // add cities and reload tableview
            requestCityInfo(for: "Kiev") { (kievInfo) in
                
                self.citiesDb.addCity(info: kievInfo)
                self.requestCityInfo(for: "Lviv") { (lvivInfo) in
                    
                    self.citiesDb.addCity(info: lvivInfo)
                    self.citiesTableView.reloadData()
                }
            }
        } else {
            updateCitiesInfo() // update info for cities
        }
        // Do any additional setup after loading the view.
    }

    // MARK:- update info about cities
    @IBAction func resfreshInfo(_ sender: Any) {
        
        updateCitiesInfo()
    }
    
    private func updateCitiesInfo() {
        
        let cities = citiesDb.getNamesOfCities() // get list of cities
        let myGroup = DispatchGroup()
        
        cities.enumerated().forEach { // for each city update info
            
            let city = $0.element
            
            myGroup.enter()
            requestCityInfo(for: city) { (forecast) in
                self.citiesDb.updateCityWeather(for: city, with: forecast)
                myGroup.leave()
            }
        }
        
        myGroup.notify(queue: DispatchQueue.main) { // reload table

            self.citiesTableView.reloadData()
        }
    }
    
    // MARK:- add new city
    @IBAction func addCity(_ sender: Any) {
        
        let alert = SearchAlert(vc: self) { (city) in
            
            self.requestCityInfo(for: city ?? "") { (cityInfo) in
                
                self.citiesDb.addCity(info: cityInfo)
                self.citiesTableView.reloadData()
            }
        }
        
        alert.presentAlert() // present Alert
    }
    
    private func requestCityInfo(for city : String, completion : ((ForecastInfo) -> ())?) { // request city info from api
        
        let params : [String : String] = ["q" : city, "appid" : APP_ID, "units" : "metric", "cnt" : "7"]
        
        Service.sharedInstances.getWeatherData(url: WEATHER_URL, parameters: params, completion: { (info) in
            
            completion?(info)
        }) { (error) in
            
            print(error as Any)
            return
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destVC = segue.destination as? CityViewController {
            
            guard let forecast = selectedCityInfo?.getCityInfo() else { return }
            destVC.cityName = forecast.city
            destVC.forecastInfo = forecast.info
        }
    }
}

// MARK:- add new city
extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        let cities = citiesDb.getNamesOfCities()
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell") as? WeatherTableViewCell {
            
            let cities = citiesDb.getNamesOfCities()
            let cityWheather = citiesDb.getCityWeather(for: cities[indexPath.section]) // get city info
            let cityName = cities[indexPath.section]
            
            cell.didSelectCellAction = { [weak self] in // action for selecting cell
                
                self?.selectedCityInfo = self?.citiesDb.getCityFullWeather(for: cityName)
                self?.performSegue(withIdentifier: "WeatherSegue", sender: self)
            }
            
            cell.cityLabel.text = cityName
            cell.degreeLabel.text = cityWheather?.getCityTemperature()
            cell.backgroundImage.image = UIImage(named: (cityWheather?.setWeatherImage())!)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // view for header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }
    
    // make indent for cells
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 10
    }
    
    // add deleting on swipe
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            
            let cities = citiesDb.getNamesOfCities()
            
            citiesDb.deleteCity(with: cities[indexPath.section])
            citiesTableView.reloadData()
        }
    }
    
}

