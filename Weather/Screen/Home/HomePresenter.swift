//
//  HomePresenter.swift
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

protocol HomePresentationLogic {
    func presentCities(response: Home.RequestCity.Response)
    func presentWeather(response: Home.RequestWeather.Response)
    func presentWeatherIcon(response: Home.RequestWeatherIcon.Response)
    func presentConvertTemp(response: Home.RequestConvertTemp.Response)
    func presentAlert(response: Home.Error.Response)
}

class HomePresenter: HomePresentationLogic {
    var viewController: HomeDisplayLogic?
    
    // MARK: Do something
    
    func presentCities(response: Home.RequestCity.Response) {
        let displayData: [City.CityDisplay] = response.cities.compactMap { city -> City.CityDisplay? in
            guard let cityId = city.id else {
                return nil
            }
            let displayName = concatCityCountry(city: city.name, state: city.state, country: city.country)
            return City.CityDisplay(id: cityId, displayName: displayName)
        }
        let viewModel = Home.RequestCity.ViewModel(cities: displayData)
        viewController?.displayCities(viewModel: viewModel)
    }
    
    func presentWeather(response: Home.RequestWeather.Response) {
        let viewModel = convertWeatherResponseToViewModel(response: response)
        viewController?.displayWeather(viewModel: viewModel)
    }
    
    func presentWeatherIcon(response: Home.RequestWeatherIcon.Response) {
        var icon: UIImage?
        if let data = response.imageData {
            icon = UIImage(data: data)
        }
        
        let viewModel = Home.RequestWeatherIcon.ViewModel(weatherIcon: icon)
        viewController?.displayWeatherIcon(viewModel: viewModel)
    }
    
    func presentConvertTemp(response: Home.RequestConvertTemp.Response) {
        var tempString = "-"
        if let temp = response.temp {
            tempString = String(format: "%.2f", temp)
        }
        
        var maxTempString = "-"
        if let maxTemp = response.maxTemp {
            maxTempString = String(format: "%.2f", maxTemp)
        }
        
        var minTempString = "-"
        if let minTemp = response.minTemp {
            minTempString = String(format: "%.2f", minTemp)
        }
        
        var feelLikeString = "-"
        if let feelLike = response.feelLike {
            feelLikeString = String(format: "%.2f", feelLike)
        }
        
        let viewModel = Home.RequestConvertTemp.ViewModel(maxTemp: maxTempString,
                                                          minTemp: minTempString,
                                                          temp: tempString,
                                                          feelLike: feelLikeString)
        viewController?.displayConvertTemp(viewModel: viewModel)
    }
    
    func presentAlert(response: Home.Error.Response) {
        let viewModel = Home.Error.ViewModel(message: response.message)
        viewController?.displayAlert(viewModel: viewModel)
    }
}
