//
//  HomeViewController.swift
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

protocol HomeDisplayLogic: AnyObject {
    func displayCities(viewModel: Home.RequestCity.ViewModel)
    func displayWeather(viewModel: Home.RequestWeather.ViewModel)
    func displayWeatherIcon(viewModel: Home.RequestWeatherIcon.ViewModel)
    func displayConvertTemp(viewModel: Home.RequestConvertTemp.ViewModel)
    func displayAlert(viewModel: Home.Error.ViewModel)
}

class HomeViewController: UIViewController, HomeDisplayLogic {
    var interactor: HomeBusinessLogic?
    var router: (NSObjectProtocol & HomeRoutingLogic & HomeDataPassing)?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        let router = HomeRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isFirstTimeLoaded {
            cityId = 1609350
            let requestWeather = Home.RequestWeather.Request(cityId: cityId ?? 0)
            interactor?.requestWeather(request: requestWeather)
            
            let requestCity = Home.RequestCity.Request(searchText: "")
            interactor?.requestCity(request: requestCity)
        }
    }
    
    // MARK: Do something
    
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var feelLikeLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    @IBOutlet weak var unitConvertBarButton: UIBarButtonItem!
    @IBOutlet weak var tempListBarButton: UIBarButtonItem!
    @IBOutlet weak var searchResultTableView: UITableView!
    @IBOutlet weak var searchResultTableViewHeight: NSLayoutConstraint!
    
    var typingTimer: Timer?
    var cities: [City.CityDisplay] = []
    var isFirstTimeLoaded = true
    var tempUnit: TemperatureUnit = .celcius
    var cityId: Int?
    
    func setupUI() {
        inputTextField.addTarget(self, action: #selector(inputTextFieldValueChanged), for: .editingChanged)
        inputTextField.delegate = self
        unitConvertBarButton.title = tempUnit.getButtonTitle
        
        let tapView = UITapGestureRecognizer(target: self, action: #selector(hideTableWhenTappedAround))
        self.view.addGestureRecognizer(tapView)
    }
    
    @objc func inputTextFieldValueChanged() {
        let request = Home.RequestCity.Request(searchText: inputTextField.text ?? "")
        interactor?.requestCity(request: request)
    }
    
    @objc func hideTableWhenTappedAround() {
        self.view.endEditing(true)
        searchResultTableViewHeight.constant = 0
    }
    
    func displayCities(viewModel: Home.RequestCity.ViewModel) {
        cities = viewModel.cities
        DispatchQueue.main.async {
            self.searchResultTableView.reloadData()
            let maxAppear = self.cities.count > 5 ? 5 : self.cities.count
            self.searchResultTableViewHeight.constant = CGFloat(maxAppear) * 51.3
        }
    }
    
    func displayWeather(viewModel: Home.RequestWeather.ViewModel) {
        isFirstTimeLoaded = false
        
        tempLabel.text = addTempUnit(tempUnit, numberString: viewModel.temp)
        descriptionLabel.text = "\(viewModel.weatherMain) - \(viewModel.description)"
        
        let request = Home.RequestWeatherIcon.Request(iconCode: viewModel.icon)
        interactor?.requestWeatherIcon(request: request)
        
        maxTempLabel.text = addTempUnit(tempUnit, numberString: viewModel.maxTemp)
        minTempLabel.text = addTempUnit(tempUnit, numberString: viewModel.minTemp)
        feelLikeLabel.text = addTempUnit(tempUnit, numberString: viewModel.feelLike)
        pressureLabel.text = viewModel.pressure
        humidityLabel.text = viewModel.humidity
        windSpeedLabel.text = viewModel.speed
        windDirectionLabel.text = viewModel.deg
    }
    
    func displayWeatherIcon(viewModel: Home.RequestWeatherIcon.ViewModel) {
        if let icon = viewModel.weatherIcon {
            DispatchQueue.main.async {
                self.weatherIcon.image = icon
            }
        }
    }
    
    func displayConvertTemp(viewModel: Home.RequestConvertTemp.ViewModel) {
        tempLabel.text = addTempUnit(tempUnit, numberString: viewModel.temp)
        maxTempLabel.text = addTempUnit(tempUnit, numberString: viewModel.maxTemp)
        minTempLabel.text = addTempUnit(tempUnit, numberString: viewModel.minTemp)
        feelLikeLabel.text = addTempUnit(tempUnit, numberString: viewModel.feelLike)
    }
    
    func displayAlert(viewModel: Home.Error.ViewModel) {
        router?.routeToAlert(message: viewModel.message)
    }
    
    @IBAction func temperatureTapped(_ sender: Any) {
        hideTableWhenTappedAround()
        let request = Home.RequestConvertTemp.Request(maxTemp: maxTempLabel.text,
                                                      minTemp: minTempLabel.text,
                                                      temp: tempLabel.text,
                                                      feelLike: feelLikeLabel.text,
                                                      tempUnit: tempUnit)
        switch tempUnit {
        case .celcius:
            tempUnit = .fahrenheit
        case .fahrenheit:
            tempUnit = .celcius
        }
        unitConvertBarButton.title = tempUnit.getButtonTitle
        interactor?.requestConvertTemp(request: request)
    }
    
    @IBAction func forecastButtonTapped(_ sender: Any) {
        guard let cityId = cityId else { return }
        router?.routeTo5DaysForecast(cityId: cityId, tempUnit: tempUnit)
    }
}

extension HomeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return string.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell") as? CityCell else { return UITableViewCell() }
        let city = cities[indexPath.row]
        cell.titleLabel.text = city.displayName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchResultTableViewHeight.constant = 0
        let city = cities[indexPath.row]
        inputTextField.text = city.displayName
        cityId = city.id
        let request = Home.RequestWeather.Request(cityId: city.id)
        interactor?.requestWeather(request: request)
    }
}