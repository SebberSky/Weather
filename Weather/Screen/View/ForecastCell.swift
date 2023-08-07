//
//  ForecastCell.swift
//  Weather
//
//  Created by chawapon.kiatpravee on 6/8/2566 BE.
//

import UIKit

class ForecastCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var feelLikeLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    let apiManager = ApiManager()
    
    func setUpUI(time: String, weatherInfo: Home.RequestWeather.ViewModel, tempUnit: TemperatureUnit) {
        DispatchQueue.global(qos: .background).async {
            self.apiManager.getWeatherIcon(iconCode: weatherInfo.icon) { data in
                guard let data = data, let icon = UIImage(data: data) else {
                    return
                }
                self.weatherIconImageView.image = icon
            }
        }
        
        timeLabel.text = time
        descriptionLabel.text = "\(weatherInfo.weatherMain) - \(weatherInfo.description)"
        tempLabel.text = addTempUnit(tempUnit, numberString: weatherInfo.temp)
        maxTempLabel.text = addTempUnit(tempUnit, numberString: weatherInfo.maxTemp)
        minTempLabel.text = addTempUnit(tempUnit, numberString: weatherInfo.minTemp)
        feelLikeLabel.text = addTempUnit(tempUnit, numberString: weatherInfo.feelLike)
        pressureLabel.text = weatherInfo.pressure
        humidityLabel.text = weatherInfo.humidity
        windSpeedLabel.text = weatherInfo.speed
        windDirectionLabel.text = weatherInfo.deg
        
        let color = time.getColorForTime
        self.backgroundColor = color
    }
}
