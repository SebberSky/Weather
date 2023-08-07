//
//  ListViewController.swift
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

protocol ListDisplayLogic: AnyObject {
    func displayForecast(viewModel: List.Forecast.ViewModel)
    func displayAlert(viewModel: Home.Error.ViewModel)
}

class ListViewController: UIViewController, ListDisplayLogic {
    var interactor: ListBusinessLogic?
    var router: (NSObjectProtocol & ListRoutingLogic & ListDataPassing)?
    
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
        let interactor = ListInteractor()
        let presenter = ListPresenter()
        let router = ListRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.sectionHeaderTopPadding = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.requestForecast()
    }
    
    // MARK: Do something
    
    @IBOutlet weak var tableView: UITableView!
    
    var forecastList: [List.Forecast.ViewModel.ViewModelResult] = []
    
    func displayForecast(viewModel: List.Forecast.ViewModel) {
        forecastList = viewModel.result
        tableView.reloadData()
    }
    
    func displayAlert(viewModel: Home.Error.ViewModel) {
        router?.routeToAlert(message: viewModel.message)
    }
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "forecastCell") as? ForecastCell else { return UITableViewCell() }
        let forecast = forecastList[indexPath.section].weatherTime[indexPath.row]
        cell.setUpUI(time: forecast.time,
                     weatherInfo: forecast.info,
                     tempUnit: router?.dataStore?.tempUnit ?? .celcius)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return forecastList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastList[section].weatherTime.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = Bundle.main.loadNibNamed("ForecastHeaderView", owner: self, options: nil)?.last as? ForecastHeaderView else { return nil }
        header.titleLabel.text = forecastList[section].date
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 46
    }
}
 
