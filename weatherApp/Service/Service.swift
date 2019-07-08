//
//  Service.swift
//  weatherApp
//
//  Created by Dmytro Pogrebniak on 7/8/19.
//  Copyright © 2019 Dmytro Pogrebniak. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Service : NSObject {
    
    static let sharedInstances = Service()
    
    func getWeatherData(url: String, parameters: [String : String], completion: @escaping (ForecastInfo)->(), error: @escaping (Error?) -> ()) {
        
        Alamofire.request(url, method : .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Succes! Got the weather data")
                
                let weatherJson : JSON = JSON(response.result.value!)
                
                completion(ForecastInfo(info: weatherJson))
            }
            else {
                print("Error \(String(describing: response.result.error))")
                error(response.result.error)
            }
        }
    }
}
