//
//  RoutePresenter.swift
//  MapRoute
//
//  Created by Dmitriy Zakharov on 21.04.2020.
//  Copyright © 2020 Dmitriy Zakharov. All rights reserved.
//

import Foundation

class RouteListPresenter: RouteListPresenterProtocol {
    
    weak var view: RouteListProtocol!
    weak var mainPresenter: MainPresenterProtocol!
    var dataService: DataServiceProtocol!
    var router: AppRouterProtocol!
    var routeList: [Route]?
    
    required init (view: RouteListProtocol, mainPresenter: MainPresenterProtocol) {
        self.view = view
        self.mainPresenter = mainPresenter
    }
    
    
    
    
    func getRouteList() -> [Route] {
        if let res = routeList {
            return res
        }
        return []
    }
    
    
    func configureView() {
        getRoutes()
        self.view.initNavigationBar()
    }
    
    func selectRouteTap(route: Route) {
        self.mainPresenter.loadRoute(route: route)
        self.router.popToRoot()
    }
    
    func backTap() {
        self.router.popToRoot()
    }
    
    func getDateFormat(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss dd.MM"
        return formatter.string(from: date)

    }
    
    
    private func getRoutes() {
        dataService.getRouteList { (result) in
            routeList = result
            self.view.updateTableView()
        }
    }
    
    
}
