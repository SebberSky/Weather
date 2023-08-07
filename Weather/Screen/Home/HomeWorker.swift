//
//  HomeWorker.swift
//  Weather
//
//  Created by chawapon.kiatpravee on 1/8/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import Foundation

protocol HomeWorkerProtocol {
    func requestCity(input: String) -> [City]?
    func requestWeather(cityId: Int, completion: @escaping WeatherResponseHandler)
    func requestWeatherImage(iconCode: String, completion: @escaping WeatherIconResponseHandler)
}

class HomeWorker: HomeWorkerProtocol {
    var cityList: [City]?
    var manager: ApiManager?
    
    init(manager: ApiManager? = nil) {
        self.manager = manager ?? ApiManager()
    }
    
    func requestCity(input: String) -> [City]? {
        if input == "" {
            if cityList == nil {
                cityList = manager?.getCityList()
            }
            return nil
        }
        let result = cityList?.filter { ($0.name?.lowercased().contains(input.lowercased()) ?? false) ||
                                        ($0.state?.lowercased().contains(input.lowercased()) ?? false) }
        return result
    }
    
    func requestWeather(cityId: Int, completion: @escaping WeatherResponseHandler) {
        manager?.getWeather(cityId: cityId, completion: completion)
    }
    
    func requestWeatherImage(iconCode: String, completion: @escaping WeatherIconResponseHandler) {
        manager?.getWeatherIcon(iconCode: iconCode, completion: completion)
    }
}