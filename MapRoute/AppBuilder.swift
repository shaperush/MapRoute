//
//  AppBuilder.swift
//  MapRoute
//
//  Created by Dmitriy Zakharov on 21.04.2020.
//  Copyright © 2020 Dmitriy Zakharov. All rights reserved.
//

import UIKit

protocol AppBuilderProtocol {
    
     func createMainModule(router: AppRouterProtocol) -> UIViewController
     func createRouteListModule(router: AppRouterProtocol,  mainPresenter: MainPresenterProtocol) -> UIViewController
}

class AppBuilder: AppBuilderProtocol {
    
    func createMainModule(router: AppRouterProtocol) -> UIViewController {
        let view = MainViewController()
        let networkService = NetworkService()
        let mapService = MapService(network: networkService)
        let dataService = DataService()
        let presenter = MainPresenter(view: view)
        presenter.dataService = dataService
        presenter.mapService = mapService
        presenter.router = router
        view.presenter = presenter 
        return view
    }
    
    func createRouteListModule(router: AppRouterProtocol, mainPresenter: MainPresenterProtocol) -> UIViewController {
        let view = RouteListViewController()
        let dataService = DataService()
        let presenter = RouteListPresenter(view: view, mainPresenter: mainPresenter)
        presenter.dataService = dataService
        presenter.router = router
        view.presenter = presenter
        return view
    }
    
    
    
}



