//
//  ListModels.swift
//  Weather
//
//  Created by chawapon.kiatpravee on 1/8/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

struct List {
    // MARK: Use cases
    
    struct Forecast {
        struct Request {
        }
        struct Response {
            let result: [ResponseResult]
            
            struct ResponseResult {
                let dateTime: String?
                let weatherInfo: Home.RequestWeather.Response
            }
        }
        struct ViewModel {
            let result: [ViewModelResult]
            
            struct ViewModelResult {
                let date: String
                var weatherTime: [WeatherByTime]
                
                struct WeatherByTime {
                    let time: String
                    let info: Home.RequestWeather.ViewModel
                }
            }
        }
    }
}

struct List5Days: Codable {
    let list: [ForecastList]?
    
    struct ForecastList: Codable {
        let dateTime: String?
        let main: Weather.WeatherMain?
        let weather: [Weather.WeatherSummary]?
        let wind: Weather.WeatherWind?
        let visibility: Int?
        enum CodingKeys: String, CodingKey {
            case dateTime = "dt_txt"
            case main, weather, wind, visibility
        }
    }
}