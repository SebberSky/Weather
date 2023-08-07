//
//  ApiManager.swift
//  Weather
//
//  Created by chawapon.kiatpravee on 6/8/2566 BE.
//

import Foundation

enum WeatherResponse {
    case success(weather: Weather)
    case failed(error: String)
}

enum ForecastResponse {
    case success(forecast: List5Days)
    case failed(error: String)
}

typealias WeatherResponseHandler = (WeatherResponse)-> Void
typealias ForecastResponseHandler = (ForecastResponse)-> Void
typealias WeatherIconResponseHandler = (Data?)-> Void

class ApiManager: NSObject {
    var session: URLSession?
    init(session: URLSession? = nil) {
        super.init()
        self.session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
    }
    
    func getWeather(cityId: Int, completion: @escaping WeatherResponseHandler) {
        guard let url = URL(string: String(format: WeatherApi.weather.getUrl, "\(cityId)")) else {
            completion(.failed(error: "WEATHER Api preparation failed!"))
            return
        }
        let request = URLRequest(url: url)
        let task = session?.dataTask(with: request) {(data, _, error) in
            guard let data = data,
                  let json = try? JSONDecoder().decode(Weather.self, from: data) else {
                completion(.failed(error: error?.localizedDescription ?? "WEATHER Api response failed!"))
                return
            }
            
            completion(.success(weather: json))
        }
        task?.resume()
    }
    
    func get5DaysForecast(cityId: Int, completion: @escaping ForecastResponseHandler) {
        guard let url = URL(string: String(format: WeatherApi.forecast.getUrl, "\(cityId)")) else {
            completion(.failed(error: "FORECAST Api preparation failed!"))
            return
        }
        let request = URLRequest(url: url)
        let task = session?.dataTask(with: request) {(data, _, error) in
            guard let data = data,
                  let json = try? JSONDecoder().decode(List5Days.self, from: data) else {
                completion(.failed(error: error?.localizedDescription ?? "FORECAST Api response failed!"))
                return
            }
            
            completion(.success(forecast: json))
        }
        task?.resume()
    }
    
    func getCityList() -> [City]? {
        guard let path = Bundle.main.path(forResource: "city.list", ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe),
              let jsonResult = try? JSONDecoder().decode([City].self, from: data) else {
            return nil
          }
        return jsonResult
    }
    
    func getWeatherIcon(iconCode: String, completion: @escaping WeatherIconResponseHandler) {
        guard let url = URL(string: String(format: WeatherApi.icon.getUrl, iconCode)) else {
            completion(nil)
            return
        }
        session?.dataTask(with: url, completionHandler: { data, _, _ in
            completion(data)
        }).resume()
    }
}

extension ApiManager: URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
}
