//
//  ForecastTests.swift
//  WeatherTests
//
//  Created by chawapon.kiatpravee on 7/8/2566 BE.
//

import XCTest
@testable import Weather

final class ForecastTests: XCTestCase {
    let interactor = ListInteractor()
    let sut = ListPresenter()
    let vc = ListViewControllerSpy()
    
    override func setUp() {
        interactor.worker = ListWorkerSpy()
        interactor.presenter = sut
        sut.viewController = vc
        interactor.cityId = 1609350
    }

    func testPresentForecast() {
        interactor.requestForecast()
        
        XCTAssertTrue(vc.displayForecastCalled)
        XCTAssertGreaterThan(vc.forecastData!.count, 5)
        XCTAssertGreaterThan(vc.forecastData![0].weatherTime.count, 0)
        XCTAssertGreaterThan(vc.forecastData![1].weatherTime.count, 0)
        XCTAssertGreaterThan(vc.forecastData![2].weatherTime.count, 0)
        XCTAssertGreaterThan(vc.forecastData![3].weatherTime.count, 0)
        XCTAssertGreaterThan(vc.forecastData![4].weatherTime.count, 0)
    }
    
}

class ListViewControllerSpy: ListDisplayLogic {
    var displayForecastCalled = false
    var forecastData: [List.Forecast.ViewModel.ViewModelResult]?
    func displayForecast(viewModel: List.Forecast.ViewModel) {
        displayForecastCalled = true
        forecastData = viewModel.result
    }
    
    func displayAlert(viewModel: Home.Error.ViewModel) {}
}

class ListWorkerSpy: ListWorkerProtocol {
    func request5DaysForecast(cityId: Int, completion: @escaping ForecastResponseHandler) {
        guard let data = result.data(using: .utf8),
              let json = try? JSONDecoder().decode(List5Days.self, from: data) else {
            return
        }
        completion(.success(forecast: json))
    }
    
    func requestWeatherImage(iconCode: String, completion: @escaping WeatherIconResponseHandler) {}
    
    let result = """
{
"cod": "200",
"message": 0,
"cnt": 40,
"list": [
    {
        "dt": 1691431200,
        "main": {
            "temp": 29.3,
            "feels_like": 29.12,
            "temp_min": 27.7,
            "temp_max": 29.3,
            "pressure": 1009,
            "sea_level": 1009,
            "grnd_level": 1006,
            "humidity": 42,
            "temp_kf": 1.6
        },
        "weather": [
            {
                "id": 804,
                "main": "Clouds",
                "description": "overcast clouds",
                "icon": "04n"
            }
        ],
        "clouds": {
            "all": 100
        },
        "wind": {
            "speed": 3.22,
            "deg": 232,
            "gust": 7.63
        },
        "visibility": 10000,
        "pop": 0.21,
        "sys": {
            "pod": "n"
        },
        "dt_txt": "2023-08-07 18:00:00"
    },
    {
        "dt": 1691442000,
        "main": {
            "temp": 28.13,
            "feels_like": 29.2,
            "temp_min": 27.14,
            "temp_max": 28.13,
            "pressure": 1008,
            "sea_level": 1008,
            "grnd_level": 1005,
            "humidity": 56,
            "temp_kf": 0.99
        },
        "weather": [
            {
                "id": 804,
                "main": "Clouds",
                "description": "overcast clouds",
                "icon": "04n"
            }
        ],
        "clouds": {
            "all": 100
        },
        "wind": {
            "speed": 3.01,
            "deg": 226,
            "gust": 7.06
        },
        "visibility": 10000,
        "pop": 0,
        "sys": {
            "pod": "n"
        },
        "dt_txt": "2023-08-07 21:00:00"
    },
    {
        "dt": 1691452800,
        "main": {
            "temp": 27.67,
            "feels_like": 29.93,
            "temp_min": 27.67,
            "temp_max": 27.67,
            "pressure": 1008,
            "sea_level": 1008,
            "grnd_level": 1007,
            "humidity": 69,
            "temp_kf": 0
        },
        "weather": [
            {
                "id": 804,
                "main": "Clouds",
                "description": "overcast clouds",
                "icon": "04d"
            }
        ],
        "clouds": {
            "all": 100
        },
        "wind": {
            "speed": 2.42,
            "deg": 231,
            "gust": 6.72
        },
        "visibility": 10000,
        "pop": 0,
        "sys": {
            "pod": "d"
        },
        "dt_txt": "2023-08-08 00:00:00"
    },
    {
        "dt": 1691463600,
        "main": {
            "temp": 30.63,
            "feels_like": 33.19,
            "temp_min": 30.63,
            "temp_max": 30.63,
            "pressure": 1009,
            "sea_level": 1009,
            "grnd_level": 1008,
            "humidity": 56,
            "temp_kf": 0
        },
        "weather": [
            {
                "id": 804,
                "main": "Clouds",
                "description": "overcast clouds",
                "icon": "04d"
            }
        ],
        "clouds": {
            "all": 100
        },
        "wind": {
            "speed": 4.17,
            "deg": 244,
            "gust": 6.42
        },
        "visibility": 10000,
        "pop": 0,
        "sys": {
            "pod": "d"
        },
        "dt_txt": "2023-08-08 03:00:00"
    },
    {
        "dt": 1691474400,
        "main": {
            "temp": 34.95,
            "feels_like": 37.74,
            "temp_min": 34.95,
            "temp_max": 34.95,
            "pressure": 1007,
            "sea_level": 1007,
            "grnd_level": 1006,
            "humidity": 42,
            "temp_kf": 0
        },
        "weather": [
            {
                "id": 804,
                "main": "Clouds",
                "description": "overcast clouds",
                "icon": "04d"
            }
        ],
        "clouds": {
            "all": 100
        },
        "wind": {
            "speed": 4.39,
            "deg": 222,
            "gust": 7.87
        },
        "visibility": 10000,
        "pop": 0,
        "sys": {
            "pod": "d"
        },
        "dt_txt": "2023-08-08 06:00:00"
    },
    {
        "dt": 1691485200,
        "main": {
            "temp": 31.88,
            "feels_like": 34.88,
            "temp_min": 31.88,
            "temp_max": 31.88,
            "pressure": 1006,
            "sea_level": 1006,
            "grnd_level": 1005,
            "humidity": 53,
            "temp_kf": 0
        },
        "weather": [
            {
                "id": 804,
                "main": "Clouds",
                "description": "overcast clouds",
                "icon": "04d"
            }
        ],
        "clouds": {
            "all": 100
        },
        "wind": {
            "speed": 5.09,
            "deg": 180,
            "gust": 6.05
        },
        "visibility": 10000,
        "pop": 0.04,
        "sys": {
            "pod": "d"
        },
        "dt_txt": "2023-08-08 09:00:00"
    },
    {
        "dt": 1691496000,
        "main": {
            "temp": 31.56,
            "feels_like": 34.03,
            "temp_min": 31.56,
            "temp_max": 31.56,
            "pressure": 1007,
            "sea_level": 1007,
            "grnd_level": 1006,
            "humidity": 52,
            "temp_kf": 0
        },
        "weather": [
            {
                "id": 804,
                "main": "Clouds",
                "description": "overcast clouds",
                "icon": "04n"
            }
        ],
        "clouds": {
            "all": 100
        },
        "wind": {
            "speed": 4.04,
            "deg": 249,
            "gust": 7.88
        },
        "visibility": 10000,
        "pop": 0.16,
        "sys": {
            "pod": "n"
        },
        "dt_txt": "2023-08-08 12:00:00"
    },
    {
        "dt": 1691506800,
        "main": {
            "temp": 29.07,
            "feels_like": 31.47,
            "temp_min": 29.07,
            "temp_max": 29.07,
            "pressure": 1010,
            "sea_level": 1010,
            "grnd_level": 1009,
            "humidity": 62,
            "temp_kf": 0
        },
        "weather": [
            {
                "id": 804,
                "main": "Clouds",
                "description": "overcast clouds",
                "icon": "04n"
            }
        ],
        "clouds": {
            "all": 100
        },
        "wind": {
            "speed": 4.35,
            "deg": 250,
            "gust": 9.22
        },
        "visibility": 10000,
        "pop": 0.32,
        "sys": {
            "pod": "n"
        },
        "dt_txt": "2023-08-08 15:00:00"
    },
    {
        "dt": 1691517600,
        "main": {
            "temp": 28.13,
            "feels_like": 30.51,
            "temp_min": 28.13,
            "temp_max": 28.13,
            "pressure": 1010,
            "sea_level": 1010,
            "grnd_level": 1008,
            "humidity": 67,
            "temp_kf": 0
        },
        "weather": [
            {
                "id": 804,
                "main": "Clouds",
                "description": "overcast clouds",
                "icon": "04n"
            }
        ],
        "clouds": {
            "all": 100
        },
        "wind": {
            "speed": 3.18,
            "deg": 242,
            "gust": 6.76
        },
        "visibility": 10000,
        "pop": 0.29,
        "sys": {
            "pod": "n"
        },
        "dt_txt": "2023-08-08 18:00:00"
    },
    {
        "dt": 1691528400,
        "main": {
            "temp": 27.49,
            "feels_like": 29.61,
            "temp_min": 27.49,
            "temp_max": 27.49,
            "pressure": 1008,
            "sea_level": 1008,
            "grnd_level": 1007,
            "humidity": 69,
            "temp_kf": 0
        },
        "weather": [
            {
                "id": 804,
                "main": "Clouds",
                "description": "overcast clouds",
                "icon": "04n"
            }
        ],
        "clouds": {
            "all": 100
        },
        "wind": {
            "speed": 2.69,
            "deg": 235,
            "gust": 5.6
        },
        "visibility": 10000,
        "pop": 0,
        "sys": {
            "pod": "n"
        },
        "dt_txt": "2023-08-08 21:00:00"
    },
    {
        "dt": 1691539200,
        "main": {
            "temp": 27.61,
            "feels_like": 29.82,
            "temp_min": 27.61,
            "temp_max": 27.61,
            "pressure": 1010,
            "sea_level": 1010,
            "grnd_level": 1009,
            "humidity": 69,
            "temp_kf": 0
        },
        "weather": [
            {
                "id": 804,
                "main": "Clouds",
                "description": "overcast clouds",
                "icon": "04d"
            }
        ],
        "clouds": {
            "all": 100
        },
        "wind": {
            "speed": 2.35,
            "deg": 224,
            "gust": 4.4
        },
        "visibility": 10000,
        "pop": 0,
        "sys": {
            "pod": "d"
        },
        "dt_txt": "2023-08-09 00:00:00"
    },
    {
        "dt": 1691550000,
        "main": {
            "temp": 31.87,
            "feels_like": 34.61,
            "temp_min": 31.87,
            "temp_max": 31.87,
            "pressure": 1011,
            "sea_level": 1011,
            "grnd_level": 1009,
            "humidity": 52,
            "temp_kf": 0
        },
        "weather": [
            {
                "id": 804,
                "main": "Clouds",
                "description": "overcast clouds",
                "icon": "04d"
            }
        ],
        "clouds": {
            "all": 100
        },
        "wind": {
            "speed": 3.76,
            "deg": 240,
            "gust": 5.32
        },
        "visibility": 10000,
        "pop": 0,
        "sys": {
            "pod": "d"
        },
        "dt_txt": "2023-08-09 03:00:00"
    },
    {
        "dt": 1691560800,
        "main": {
            "temp": 34.22,
            "feels_like": 36.94,
            "temp_min": 34.22,
            "temp_max": 34.22,
            "pressure": 1008,
            "sea_level": 1008,
            "grnd_level": 1007,
            "humidity": 44,
            "temp_kf": 0
        },
        "weather": [
            {
                "id": 804,
                "main": "Clouds",
                "description": "overcast clouds",
                "icon": "04d"
            }
        ],
        "clouds": {
            "all": 100
        },
        "wind": {
            "speed": 3.99,
            "deg": 213,
            "gust": 5.43
        },
        "visibility": 10000,
        "pop": 0,
        "sys": {
            "pod": "d"
        },
        "dt_txt": "2023-08-09 06:00:00"
    },
    {
        "dt": 1691571600,
        "main": {
            "temp": 32.12,
            "feels_like": 35.62,
            "temp_min": 32.12,
            "temp_max": 32.12,
            "pressure": 1007,
            "sea_level": 1007,
            "grnd_level": 1006,
            "humidity": 54,
            "temp_kf": 0
        },
        "weather": [
            {
                "id": 804,
                "main": "Clouds",
                "description": "overcast clouds",
                "icon": "04d"
            }
        ],
        "clouds": {
            "all": 100
        },
        "wind": {
            "speed": 4.6,
            "deg": 194,
            "gust": 4.2
        },
        "visibility": 10000,
        "pop": 0.23,
        "sys": {
            "pod": "d"
        },
        "dt_txt": "2023-08-09 09:00:00"
    },
    {
        "dt": 1691582400,
        "main": {
            "temp": 29.97,
            "feels_like": 33.6,
            "temp_min": 29.97,
            "temp_max": 29.97,
            "pressure": 1008,
            "sea_level": 1008,
            "grnd_level": 1007,
            "humidity": 64,
            "temp_kf": 0
        },
        "weather": [
            {
                "id": 500,
                "main": "Rain",
                "description": "light rain",
                "icon": "10n"
            }
        ],
        "clouds": {
            "all": 100
        },
        "wind": {
            "speed": 1.05,
            "deg": 210,
            "gust": 2.5
        },
        "visibility": 10000,
        "pop": 0.76,
        "rain": {
            "3h": 0.59
        },
        "sys": {
            "pod": "n"
        },
        "dt_txt": "2023-08-09 12:00:00"
    },
    {
        "dt": 1691593200,
        "main": {
            "temp": 28.99,
            "feels_like": 33.08,
            "temp_min": 28.99,
            "temp_max": 28.99,
            "pressure": 1010,
            "sea_level": 1010,
            "grnd_level": 1009,
            "humidity": 72,
            "temp_kf": 0
        },
        "weather": [
            {
                "id": 500,
                "main": "Rain",
                "description": "light rain",
                "icon": "10n"
            }
        ],
        "clouds": {
            "all": 100
        },
        "wind": {
            "speed": 0.82,
            "deg": 154,
            "gust": 2.62
        },
        "visibility": 10000,
        "pop": 0.81,
        "rain": {
            "3h": 0.76
        },
        "sys": {
            "pod": "n"
        },
        "dt_txt": "2023-08-09 15:00:00"
    },
    {
        "dt": 1691604000,
        "main": {
            "temp": 27.81,
            "feels_like": 30.68,
            "temp_min": 27.81,
            "temp_max": 27.81,
            "pressure": 1009,
            "sea_level": 1009,
            "grnd_level": 1007,
            "humidity": 73,
            "temp_kf": 0
        },
        "weather": [
            {
                "id": 804,
                "main": "Clouds",
                "description": "overcast clouds",
                "icon": "04n"
            }
        ],
        "clouds": {
            "all": 88
        },
        "wind": {
            "speed": 3.25,
            "deg": 259,
            "gust": 6.61
        },
        "visibility": 10000,
        "pop": 0.61,
        "sys": {
            "pod": "n"
        },
        "dt_txt": "2023-08-09 18:00:00"
    },
    {
        "dt": 1691614800,
        "main": {
            "temp": 26.72,
            "feels_like": 28.68,
            "temp_min": 26.72,
            "temp_max": 26.72,
            "pressure": 1008,
            "sea_level": 1008,
            "grnd_level": 1007,
            "humidity": 74,
            "temp_kf": 0
        },
        "weather": [
            {
                "id": 804,
                "main": "Clouds",
                "description": "overcast clouds",
                "icon": "04n"
            }
        ],
        "clouds": {
            "all": 100
        },
        "wind": {
            "speed": 2.61,
            "deg": 266,
            "gust": 5.96
        },
        "visibility": 10000,
        "pop": 0.08,
        "sys": {
            "pod": "n"
        },
        "dt_txt": "2023-08-09 21:00:00"
    },
    {
        "dt": 1691625600,
        "main": {
            "temp": 26.99,
            "feels_like": 29.01,
            "temp_min": 26.99,
            "temp_max": 26.99,
            "pressure": 1010,
            "sea_level": 1010,
            "grnd_level": 1008,
            "humidity": 72,
            "temp_kf": 0
        },
        "weather": [
            {
                "id": 804,
                "main": "Clouds",
                "description": "overcast clouds",
                "icon": "04d"
            }
        ],
        "clouds": {
            "all": 100
        },
        "wind": {
            "speed": 2.66,
            "deg": 250,
            "gust": 5.15
        },
        "visibility": 10000,
        "pop": 0.04,
        "sys": {
            "pod": "d"
        },
        "dt_txt": "2023-08-10 00:00:00"
    },
    {
        "dt": 1691636400,
        "main": {
            "temp": 32.01,
            "feels_like": 34.63,
            "temp_min": 32.01,
            "temp_max": 32.01,
            "pressure": 1010,
            "sea_level": 1010,
            "grnd_level": 1009,
            "humidity": 51,
            "temp_kf": 0
        },
        "weather": [
            {
                "id": 804,
                "main": "Clouds",
                "description": "overcast clouds",
                "icon": "04d"
            }
        ],
        "clouds": {
            "all": 97
        },
        "wind": {
            "speed": 3.29,
            "deg": 276,
            "gust": 4.7
        },
        "visibility": 10000,
        "pop": 0,
        "sys": {
            "pod": "d"
        },
        "dt_txt": "2023-08-10 03:00:00"
    },
    {
        "dt": 1691647200,
        "main": {
            "temp": 35.17,
            "feels_like": 38.5,
            "temp_min": 35.17,
            "temp_max": 35.17,
            "pressure": 1008,
            "sea_level": 1008,
            "grnd_level": 1006,
            "humidity": 43,
            "temp_kf": 0
        },
        "weather": [
            {
                "id": 500,
                "main": "Rain",
                "description": "light rain",
                "icon": "10d"
            }
        ],
        "clouds": {
            "all": 85
        },
        "wind": {
            "speed": 4.2,
            "deg": 284,
            "gust": 5.69
        },
        "visibility": 10000,
        "pop": 0.2,
        "rain": {
            "3h": 0.13
        },
        "sys": {
            "pod": "d"
        },
        "dt_txt": "2023-08-10 06:00:00"
    },
    {
        "dt": 1691658000,
        "main": {
            "temp": 34.55,
            "feels_like": 37.58,
            "temp_min": 34.55,
            "temp_max": 34.55,
            "pressure": 1006,
            "sea_level": 1006,
            "grnd_level": 1004,
            "humidity": 44,
            "temp_kf": 0
        },
        "weather": [
            {
                "id": 803,
                "main": "Clouds",
                "description": "broken clouds",
                "icon": "04d"
            }
        ],
        "clouds": {
            "all": 78
        },
        "wind": {
            "speed": 3.15,
            "deg": 262,
            "gust": 4.61
        },
        "visibility": 10000,
        "pop": 0,
        "sys": {
            "pod": "d"
        },
        "dt_txt": "2023-08-10 09:00:00"
    },
    {
        "dt": 1691668800,
        "main": {
            "temp": 30.83,
            "feels_like": 34.49,
            "temp_min": 30.83,
            "temp_max": 30.83,
            "pressure": 1007,
            "sea_level": 1007,
            "grnd_level": 1006,
            "humidity": 60,
            "temp_kf": 0
        },
        "weather": [
            {
                "id": 500,
                "main": "Rain",
                "description": "light rain",
                "icon": "10n"
            }
        ],
        "clouds": {
            "all": 89
        },
        "wind": {
            "speed": 5.12,
            "deg": 226,
            "gust": 6.71
        },
        "visibility": 10000,
        "pop": 0.28,
        "rain": {
            "3h": 0.25
        },
        "sys": {
            "pod": "n"
        },
        "dt_txt": "2023-08-10 12:00:00"
    },
    {
        "dt": 1691679600,
        "main": {
            "temp": 29.43,
            "feels_like": 31.96,
            "temp_min": 29.43,
            "temp_max": 29.43,
            "pressure": 1009,
            "sea_level": 1009,
            "grnd_level": 1007,
            "humidity": 61,
            "temp_kf": 0
        },
        "weather": [
            {
                "id": 804,
                "main": "Clouds",
                "description": "overcast clouds",
                "icon": "04n"
            }
        ],
        "clouds": {
            "all": 100
        },
        "wind": {
            "speed": 3.57,
            "deg": 257,
            "gust": 7.17
        },
        "visibility": 10000,
        "pop": 0.04,
        "sys": {
            "pod": "n"
        },
        "dt_txt": "2023-08-10 15:00:00"
    },
    {
        "dt": 1691690400,
        "main": {
            "temp": 28.45,
            "feels_like": 30.82,
            "temp_min": 28.45,
            "temp_max": 28.45,
            "pressure": 1008,
            "sea_level": 1008,
            "grnd_level": 1006,
            "humidity": 65,
            "temp_kf": 0
        },
        "weather": [
            {
                "id": 804,
                "main": "Clouds",
                "description": "overcast clouds",
                "icon": "04n"
            }
        ],
        "clouds": {
            "all": 100
        },
        "wind": {
            "speed": 3.26,
            "deg": 259,
            "gust": 7.64
        },
        "visibility": 10000,
        "pop": 0.12,
        "sys": {
            "pod": "n"
        },
        "dt_txt": "2023-08-10 18:00:00"
    },
    {
        "dt": 1691701200,
        "main": {
            "temp": 27.21,
            "feels_like": 28.94,
            "temp_min": 27.21,
            "temp_max": 27.21,
            "pressure": 1006,
            "sea_level": 1006,
            "grnd_level": 1005,
            "humidity": 67,
            "temp_kf": 0
        },
        "weather": [
            {
                "id": 804,
                "main": "Clouds",
                "description": "overcast clouds",
                "icon": "04n"
            }
        ],
        "clouds": {
            "all": 100
        },
        "wind": {
            "speed": 3.45,
            "deg": 257,
            "gust": 8.33
        },
        "visibility": 10000,
        "pop": 0,
        "sys": {
            "pod": "n"
        },
        "dt_txt": "2023-08-10 21:00:00"
    },
    {
        "dt": 1691712000,
        "main": {
            "temp": 27.04,
            "feels_like": 28.76,
            "temp_min": 27.04,
            "temp_max": 27.04,
            "pressure": 1008,
            "sea_level": 1008,
            "grnd_level": 1007,
            "humidity": 68,
            "temp_kf": 0
        },
        "weather": [
            {
                "id": 804,
                "main": "Clouds",
                "description": "overcast clouds",
                "icon": "04d"
            }
        ],
        "clouds": {
            "all": 100
        },
        "wind": {
            "speed": 3.32,
            "deg": 257,
            "gust": 7.13
        },
        "visibility": 10000,
        "pop": 0,
        "sys": {
            "pod": "d"
        },
        "dt_txt": "2023-08-11 00:00:00"
    },
    {
        "dt": 1691722800,
        "main": {
            "temp": 31.6,
            "feels_like": 33.64,
            "temp_min": 31.6,
            "temp_max": 31.6,
            "pressure": 1009,
            "sea_level": 1009,
            "grnd_level": 1008,
            "humidity": 50,
            "temp_kf": 0
        },
        "weather": [
            {
                "id": 804,
                "main": "Clouds",
                "description": "overcast clouds",
                "icon": "04d"
            }
        ],
        "clouds": {
            "all": 100
        },
        "wind": {
            "speed": 4.28,
            "deg": 267,
            "gust": 6.31
        },
        "visibility": 10000,
        "pop": 0,
        "sys": {
            "pod": "d"
        },
        "dt_txt": "2023-08-11 03:00:00"
    },
    {
        "dt": 1691733600,
        "main": {
            "temp": 35.18,
            "feels_like": 37.55,
            "temp_min": 35.18,
            "temp_max": 35.18,
            "pressure": 1006,
            "sea_level": 1006,
            "grnd_level": 1005,
            "humidity": 40,
            "temp_kf": 0
        },
        "weather": [
            {
                "id": 804,
                "main": "Clouds",
                "description": "overcast clouds",
                "icon": "04d"
            }
        ],
        "clouds": {
            "all": 100
        },
        "wind": {
            "speed": 4.34,
            "deg": 275,
            "gust": 6.31
        },
        "visibility": 10000,
        "pop": 0,
        "sys": {
            "pod": "d"
        },
        "dt_txt": "2023-08-11 06:00:00"
    },
    {
        "dt": 1691744400,
        "main": {
            "temp": 34.08,
            "feels_like": 36.96,
            "temp_min": 34.08,
            "temp_max": 34.08,
            "pressure": 1004,
            "sea_level": 1004,
            "grnd_level": 1003,
            "humidity": 45,
            "temp_kf": 0
        },
        "weather": [
            {
                "id": 804,
                "main": "Clouds",
                "description": "overcast clouds",
                "icon": "04d"
            }
        ],
        "clouds": {
            "all": 100
        },
        "wind": {
            "speed": 4.55,
            "deg": 212,
            "gust": 5.25
        },
        "visibility": 10000,
        "pop": 0,
        "sys": {
            "pod": "d"
        },
        "dt_txt": "2023-08-11 09:00:00"
    },
    {
        "dt": 1691755200,
        "main": {
            "temp": 30.73,
            "feels_like": 34.28,
            "temp_min": 30.73,
            "temp_max": 30.73,
            "pressure": 1006,
            "sea_level": 1006,
            "grnd_level": 1004,
            "humidity": 60,
            "temp_kf": 0
        },
        "weather": [
            {
                "id": 804,
                "main": "Clouds",
                "description": "overcast clouds",
                "icon": "04n"
            }
        ],
        "clouds": {
            "all": 98
        },
        "wind": {
            "speed": 4.55,
            "deg": 203,
            "gust": 7.24
        },
        "visibility": 10000,
        "pop": 0.08,
        "sys": {
            "pod": "n"
        },
        "dt_txt": "2023-08-11 12:00:00"
    },
    {
        "dt": 1691766000,
        "main": {
            "temp": 30.12,
            "feels_like": 32.86,
            "temp_min": 30.12,
            "temp_max": 30.12,
            "pressure": 1008,
            "sea_level": 1008,
            "grnd_level": 1006,
            "humidity": 59,
            "temp_kf": 0
        },
        "weather": [
            {
                "id": 804,
                "main": "Clouds",
                "description": "overcast clouds",
                "icon": "04n"
            }
        ],
        "clouds": {
            "all": 97
        },
        "wind": {
            "speed": 3.99,
            "deg": 239,
            "gust": 7.56
        },
        "visibility": 10000,
        "pop": 0.08,
        "sys": {
            "pod": "n"
        },
        "dt_txt": "2023-08-11 15:00:00"
    },
    {
        "dt": 1691776800,
        "main": {
            "temp": 28.62,
            "feels_like": 30.54,
            "temp_min": 28.62,
            "temp_max": 28.62,
            "pressure": 1007,
            "sea_level": 1007,
            "grnd_level": 1005,
            "humidity": 61,
            "temp_kf": 0
        },
        "weather": [
            {
                "id": 804,
                "main": "Clouds",
                "description": "overcast clouds",
                "icon": "04n"
            }
        ],
        "clouds": {
            "all": 94
        },
        "wind": {
            "speed": 3.75,
            "deg": 240,
            "gust": 9.14
        },
        "visibility": 10000,
        "pop": 0,
        "sys": {
            "pod": "n"
        },
        "dt_txt": "2023-08-11 18:00:00"
    },
    {
        "dt": 1691787600,
        "main": {
            "temp": 27.67,
            "feels_like": 29.38,
            "temp_min": 27.67,
            "temp_max": 27.67,
            "pressure": 1006,
            "sea_level": 1006,
            "grnd_level": 1004,
            "humidity": 64,
            "temp_kf": 0
        },
        "weather": [
            {
                "id": 804,
                "main": "Clouds",
                "description": "overcast clouds",
                "icon": "04n"
            }
        ],
        "clouds": {
            "all": 86
        },
        "wind": {
            "speed": 3.52,
            "deg": 251,
            "gust": 8.69
        },
        "visibility": 10000,
        "pop": 0,
        "sys": {
            "pod": "n"
        },
        "dt_txt": "2023-08-11 21:00:00"
    },
    {
        "dt": 1691798400,
        "main": {
            "temp": 27.61,
            "feels_like": 29.49,
            "temp_min": 27.61,
            "temp_max": 27.61,
            "pressure": 1007,
            "sea_level": 1007,
            "grnd_level": 1006,
            "humidity": 66,
            "temp_kf": 0
        },
        "weather": [
            {
                "id": 804,
                "main": "Clouds",
                "description": "overcast clouds",
                "icon": "04d"
            }
        ],
        "clouds": {
            "all": 90
        },
        "wind": {
            "speed": 3.04,
            "deg": 245,
            "gust": 6.74
        },
        "visibility": 10000,
        "pop": 0,
        "sys": {
            "pod": "d"
        },
        "dt_txt": "2023-08-12 00:00:00"
    },
    {
        "dt": 1691809200,
        "main": {
            "temp": 32.45,
            "feels_like": 34.7,
            "temp_min": 32.45,
            "temp_max": 32.45,
            "pressure": 1008,
            "sea_level": 1008,
            "grnd_level": 1006,
            "humidity": 48,
            "temp_kf": 0
        },
        "weather": [
            {
                "id": 804,
                "main": "Clouds",
                "description": "overcast clouds",
                "icon": "04d"
            }
        ],
        "clouds": {
            "all": 88
        },
        "wind": {
            "speed": 4.43,
            "deg": 260,
            "gust": 6.8
        },
        "visibility": 10000,
        "pop": 0,
        "sys": {
            "pod": "d"
        },
        "dt_txt": "2023-08-12 03:00:00"
    },
    {
        "dt": 1691820000,
        "main": {
            "temp": 35.4,
            "feels_like": 38.29,
            "temp_min": 35.4,
            "temp_max": 35.4,
            "pressure": 1005,
            "sea_level": 1005,
            "grnd_level": 1004,
            "humidity": 41,
            "temp_kf": 0
        },
        "weather": [
            {
                "id": 804,
                "main": "Clouds",
                "description": "overcast clouds",
                "icon": "04d"
            }
        ],
        "clouds": {
            "all": 92
        },
        "wind": {
            "speed": 4.48,
            "deg": 240,
            "gust": 6.34
        },
        "visibility": 10000,
        "pop": 0,
        "sys": {
            "pod": "d"
        },
        "dt_txt": "2023-08-12 06:00:00"
    },
    {
        "dt": 1691830800,
        "main": {
            "temp": 32.81,
            "feels_like": 35.64,
            "temp_min": 32.81,
            "temp_max": 32.81,
            "pressure": 1004,
            "sea_level": 1004,
            "grnd_level": 1003,
            "humidity": 49,
            "temp_kf": 0
        },
        "weather": [
            {
                "id": 500,
                "main": "Rain",
                "description": "light rain",
                "icon": "10d"
            }
        ],
        "clouds": {
            "all": 100
        },
        "wind": {
            "speed": 4.35,
            "deg": 207,
            "gust": 5.84
        },
        "visibility": 10000,
        "pop": 0.24,
        "rain": {
            "3h": 0.24
        },
        "sys": {
            "pod": "d"
        },
        "dt_txt": "2023-08-12 09:00:00"
    },
    {
        "dt": 1691841600,
        "main": {
            "temp": 31.02,
            "feels_like": 34.64,
            "temp_min": 31.02,
            "temp_max": 31.02,
            "pressure": 1005,
            "sea_level": 1005,
            "grnd_level": 1003,
            "humidity": 59,
            "temp_kf": 0
        },
        "weather": [
            {
                "id": 804,
                "main": "Clouds",
                "description": "overcast clouds",
                "icon": "04n"
            }
        ],
        "clouds": {
            "all": 99
        },
        "wind": {
            "speed": 4.02,
            "deg": 184,
            "gust": 6.68
        },
        "visibility": 10000,
        "pop": 0,
        "sys": {
            "pod": "n"
        },
        "dt_txt": "2023-08-12 12:00:00"
    },
    {
        "dt": 1691852400,
        "main": {
            "temp": 29.68,
            "feels_like": 31.87,
            "temp_min": 29.68,
            "temp_max": 29.68,
            "pressure": 1007,
            "sea_level": 1007,
            "grnd_level": 1006,
            "humidity": 58,
            "temp_kf": 0
        },
        "weather": [
            {
                "id": 804,
                "main": "Clouds",
                "description": "overcast clouds",
                "icon": "04n"
            }
        ],
        "clouds": {
            "all": 100
        },
        "wind": {
            "speed": 4.78,
            "deg": 252,
            "gust": 9.45
        },
        "visibility": 10000,
        "pop": 0.12,
        "sys": {
            "pod": "n"
        },
        "dt_txt": "2023-08-12 15:00:00"
    }
],
"city": {
    "id": 1609350,
    "name": "Bangkok",
    "coord": {
        "lat": 13.75,
        "lon": 100.5167
    },
    "country": "TH",
    "population": 0,
    "timezone": 25200,
    "sunrise": 1691363010,
    "sunset": 1691408646
}
}
"""
}
