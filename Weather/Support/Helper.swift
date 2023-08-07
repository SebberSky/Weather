//
//  Helper.swift
//  Weather
//
//  Created by chawapon.kiatpravee on 6/8/2566 BE.
//

import Foundation
import UIKit

func addTempUnit(_ tempUnit: TemperatureUnit, numberString: String) -> String {
    return numberString == "-" ? numberString : String(format: tempUnit.getPrefix, numberString)
}

func concatCityCountry(city: String?, state: String?, country: String?) -> String {
    var result = "\(city ?? ""),"
    if let stateString = state, stateString != "" {
        result = result + "\(stateString) ,"
    }
    return "\(result) \(country ?? "")"
}

func convertWeatherResponseToViewModel(response: Home.RequestWeather.Response) -> Home.RequestWeather.ViewModel {
    var tempString = "-"
    if let temp = response.main?.temp {
        tempString = "\(temp)"
    }
    
    var feelLikeString = "-"
    if let feelLike = response.main?.feelLike {
        feelLikeString = "\(feelLike)"
    }
    
    var minTempString = "-"
    if let minTemp = response.main?.tempMin {
        minTempString = "\(minTemp)"
    }
    
    var maxTempString = "-"
    if let maxTemp = response.main?.tempMax {
        maxTempString = "\(maxTemp)"
    }
    
    var pressureString = "-"
    if let pressure = response.main?.pressure {
        pressureString = "\(pressure)"
    }
    
    var humidityString = "-"
    if let humidity = response.main?.humidity {
        humidityString = "\(humidity)"
    }
    
    var visibilityString = "-"
    if let visibility = response.visibility {
        visibilityString = "\(visibility)"
    }
    
    var speedString = "-"
    if let speed = response.wind?.speed {
        speedString = "\(speed)"
    }
    
    var degString = "-"
    if let deg = response.wind?.deg {
        degString = getDirectionFromDegrees(degree: deg)
    }
    
    let viewModel = Home.RequestWeather.ViewModel(weatherMain: response.weatherSummary?.main ?? "-",
                                                  description: response.weatherSummary?.description ?? "-",
                                                  icon: response.weatherSummary?.icon ?? "",
                                                  temp: tempString,
                                                  feelLike: feelLikeString,
                                                  minTemp: minTempString,
                                                  maxTemp: maxTempString,
                                                  pressure: pressureString,
                                                  humidity: humidityString,
                                                  visibility: visibilityString,
                                                  speed: "\(speedString) km/h",
                                                  deg: degString)
    return viewModel
}

func getDirectionFromDegrees(degree: Int) -> String {
    let result = (degree / 45) % 8
    switch Directions(rawValue: result) {
    case .North:
        return "N"
    case .NorthEast:
        return "NE"
    case .East:
        return "E"
    case .SouthEast:
        return "SE"
    case .South:
        return "S"
    case .SouthWest:
        return "SW"
    case .West:
        return "W"
    case .NorthWest:
        return "NW"
    default:
        return ""
    }
}

extension String {
    /// reference : http://www.phrenopolis.com/colorclock/
    /// color reference :  https://encycolorpedia.com/
    var getColorForTime: UIColor? {
        let getHour = self.components(separatedBy: ":").first
        switch getHour {
        case "00": // midnight
            return .red
        case "03":
            return UIColor(red: 0.95, green: 0.52, blue: 0, alpha: 1) // tangerine
        case "06":
            return UIColor(red: 0.85, green: 0.87, blue: 0.67, alpha: 1) // pear
        case "09":
            return UIColor(red: 0.62, green: 0.99, blue: 0.22, alpha: 1) // lime
        case "12":
            return .gray
        case "15":
            return UIColor(red: 0.26, green: 0.38, blue: 0.54, alpha: 1) // denim
        case "18":
            return .systemIndigo
        case "21":
            return UIColor(red: 0.68, green: 0.26, blue: 0.48, alpha: 1) // maroon
        default: return nil
        }
    }
}

func showAlert(message: String, viewController: UIViewController?) {
    // show alert and close app to start over again
    let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alert.addAction(okAction)
    viewController?.present(alert, animated: true)
}
