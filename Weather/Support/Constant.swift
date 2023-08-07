//
//  Constant.swift
//  Weather
//
//  Created by chawapon.kiatpravee on 1/8/2566 BE.
//

/// API KEY
let WEATHER_API_KEY = "bce03f443d0312fc672563c668617c19"

enum WeatherApi {
    case weather
    case forecast
    case icon
    
    var getUrl: String {
        switch self {
        case .weather:
            return "https://api.openweathermap.org/data/2.5/weather?id=%@&appid=\(WEATHER_API_KEY)&units=metric"
        case .forecast:
            return "https://api.openweathermap.org/data/2.5/forecast?id=%@&appid=\(WEATHER_API_KEY)&units=metric"
        case .icon:
            return "https://openweathermap.org/img/wn/%@@2x.png"
        }
    }
}

/// Tempurature unit
enum TemperatureUnit: String {
    case celcius = "Celcius"
    case fahrenheit = "Fahrenheit"
    
    var getPrefix: String {
        switch self {
        case .celcius:
            return "C° %@"
        case .fahrenheit:
            return "F° %@"
        }
    }
    
    var getButtonTitle: String {
        switch self {
        case .celcius:
            return TemperatureUnit.fahrenheit.rawValue
        case .fahrenheit:
            return TemperatureUnit.celcius.rawValue
        }
    }
}
