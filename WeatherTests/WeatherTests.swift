//
//  WeatherTests.swift
//  WeatherTests
//
//  Created by chawapon.kiatpravee on 7/8/2566 BE.
//

import XCTest
@testable import Weather

final class WeatherTests: XCTestCase {
    let sut = HomeInteractor()
    let presenterSpy = HomePresenterSpy()
    
    override func setUp() {
        sut.presenter = presenterSpy
    }
    
    override func tearDown() {
        presenterSpy.resetFlag()
    }
    
    func testGetCityWithEmptySearchText() throws {
        let request = Home.RequestCity.Request(searchText: "")
        sut.requestCity(request: request)
        XCTAssertTrue(presenterSpy.presentCitiesCalled)
        XCTAssertNotNil(presenterSpy.citiesResponse)
        XCTAssertEqual(presenterSpy.citiesResponse!.count, 0)
    }
    
    func testGetCityWithNonEmptySearchText() throws {
        let request = Home.RequestCity.Request(searchText: "a")
        sut.requestCity(request: request)
        XCTAssertTrue(presenterSpy.presentCitiesCalled)
        XCTAssertNotNil(presenterSpy.citiesResponse)
        XCTAssertGreaterThanOrEqual(presenterSpy.citiesResponse!.count, 0)
    }
    
    func testGetWeatherSuccess() {
        sut.worker = HomeWorkerSpy()
        let request = Home.RequestWeather.Request(cityId: 1609350)
        sut.requestWeather(request: request)
        
        XCTAssertTrue(presenterSpy.presentWeatherCalled)
        XCTAssertNotNil(presenterSpy.weatherResponse)
        XCTAssertNotNil(presenterSpy.weatherResponse?.main)
        XCTAssertNotNil(presenterSpy.weatherResponse?.visibility)
        XCTAssertNotNil(presenterSpy.weatherResponse?.weatherSummary)
        XCTAssertNotNil(presenterSpy.weatherResponse?.wind)
    }
    
    func testGetWeatherFailed() {
        sut.worker = HomeWorkerSpy()
        let request = Home.RequestWeather.Request(cityId: 0)
        sut.requestWeather(request: request)
        
        XCTAssertTrue(presenterSpy.presentAlertCalled)
        XCTAssertNotNil(presenterSpy.errorMessage)
    }
    
    func testConvertTemp() {
        let request = Home.RequestConvertTemp.Request(maxTemp: "C° 15",
                                                      minTemp: nil,
                                                      temp: "C° 17.4",
                                                      feelLike: "C° 18.99",
                                                      tempUnit: .celcius)
        sut.requestConvertTemp(request: request)
        
        XCTAssertTrue(presenterSpy.presentConvertTempCalled)
        XCTAssertNotNil(presenterSpy.convertTempResponse?.maxTemp)
        XCTAssertNil(presenterSpy.convertTempResponse?.minTemp)
        XCTAssertNotNil(presenterSpy.convertTempResponse?.temp)
        XCTAssertNotNil(presenterSpy.convertTempResponse?.feelLike)
    }
}

class HomePresenterSpy: HomePresentationLogic {
    var presentCitiesCalled = false
    var presentWeatherCalled = false
    var presentAlertCalled = false
    var presentConvertTempCalled = false
    var citiesResponse: [City]?
    var weatherResponse: Home.RequestWeather.Response?
    var errorMessage: String?
    var convertTempResponse: Home.RequestConvertTemp.Response?
    
    func presentCities(response: Home.RequestCity.Response) {
        presentCitiesCalled = true
        citiesResponse = response.cities
    }
    
    func presentWeather(response: Home.RequestWeather.Response) {
        presentWeatherCalled = true
        weatherResponse = response
    }
    
    func presentWeatherIcon(response: Home.RequestWeatherIcon.Response) {}
    
    func presentConvertTemp(response: Home.RequestConvertTemp.Response) {
        presentConvertTempCalled = true
        convertTempResponse = response
    }
    
    func presentAlert(response: Home.Error.Response) {
        presentAlertCalled = true
        errorMessage = response.message
    }
    
    func resetFlag() {
        presentCitiesCalled = false
        presentWeatherCalled = false
        presentAlertCalled = false
        presentConvertTempCalled = false
    }
}

class HomeWorkerSpy: HomeWorkerProtocol {
    func requestCity(input: String) -> [City]? { return nil }
    
    func requestWeather(cityId: Int, completion: @escaping WeatherResponseHandler) {
        if cityId == 1609350 {
            let result = """
            {
                "coord": {
                    "lon": 100.5167,
                    "lat": 13.75
                },
                "weather": [
                    {
                        "id": 804,
                        "main": "Clouds",
                        "description": "overcast clouds",
                        "icon": "04n"
                    }
                ],
                "base": "stations",
                "main": {
                    "temp": 30.64,
                    "feels_like": 30.88,
                    "temp_min": 28.84,
                    "temp_max": 31.64,
                    "pressure": 1008,
                    "humidity": 43,
                    "sea_level": 1008,
                    "grnd_level": 1006
                },
                "visibility": 10000,
                "wind": {
                    "speed": 4.9,
                    "deg": 243,
                    "gust": 9.25
                },
                "clouds": {
                    "all": 100
                },
                "dt": 1691417190,
                "sys": {
                    "type": 2,
                    "id": 2081950,
                    "country": "TH",
                    "sunrise": 1691363010,
                    "sunset": 1691408646
                },
                "timezone": 25200,
                "id": 1609350,
                "name": "Bangkok",
                "cod": 200
            }
            """
            guard let data = result.data(using: .utf8),
                  let json = try? JSONDecoder().decode(Weather.self, from: data) else {
                return
            }
            
            completion(.success(weather: json))
        } else {
            completion(.failed(error: "Invalid ID"))
        }
    }
    
    func requestWeatherImage(iconCode: String, completion: @escaping WeatherIconResponseHandler) {}
}
