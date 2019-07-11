//
//  CityViewController.swift
//  weatherApp
//
//  Created by Dmytro Pogrebniak on 7/11/19.
//  Copyright © 2019 Dmytro Pogrebniak. All rights reserved.
//

import UIKit

class CityViewController: UIViewController {

    @IBOutlet weak var backButtonView: UIView! {
        
        didSet {
            
            backButtonView.isUserInteractionEnabled = true
            backButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(getBackToMainView)))

        }
    }
    
    @IBOutlet weak var cityNameLabel: UILabel! {
        
        didSet {
            
            cityNameLabel.textAlignment = .center
            cityNameLabel.font = UIFont(name: "Helvetica", size: 30)
            cityNameLabel.textColor = UIColor.white
        }
    }
    
    @IBOutlet weak var cityTemperatureLabel: UILabel! {
        
        didSet {
            
            cityTemperatureLabel.textAlignment = .center
            cityTemperatureLabel.font = UIFont(name: "Helvetica", size: 25)
            cityTemperatureLabel.textColor = UIColor.white
        }
    }
    
    @IBOutlet weak var forecastTableView: UITableView! {
        
        didSet {
            
            forecastTableView.delegate = self
            forecastTableView.dataSource = self
        }
    }
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    var forecastInfo : [CityInfo] = []
    
    var cityName : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        forecastTableView.register(UINib(nibName: "CityPageTableViewCell", bundle: nil), forCellReuseIdentifier: "DayForecast")
        setCurrentDayWeather()
    }
    
    // back button pressed
    @objc private func getBackToMainView() {
        
        self.navigationController?.popToRootViewController(animated: true)
    }

    // set labels for current day
    private func setCurrentDayWeather() {
        
        guard let currentDayInfo = forecastInfo.first else { return }
        
        cityNameLabel.text = cityName
        cityTemperatureLabel.text = currentDayInfo.getCityTemperature()
        backgroundImage.image = UIImage(named: currentDayInfo.setWeatherImage())
    }
    
}

// MARK: - TableView extension
extension CityViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return forecastInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DayForecast", for: indexPath) as? CityPageTableViewCell {
            
            let dayForecast = forecastInfo[indexPath.row]
            cell.dateLabel.text = dayForecast.getCityDate()
            cell.temperatureLabel.text = dayForecast.getCityTemperature()
            cell.weatherIcon.image = UIImage(named: dayForecast.setWeatherIcon())
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
