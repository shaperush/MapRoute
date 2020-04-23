//
//  RouteProtocol.swift
//  MapRoute
//
//  Created by Dmitriy Zakharov on 21.04.2020.
//  Copyright © 2020 Dmitriy Zakharov. All rights reserved.
//

import Foundation

protocol RouteListProtocol: class {
    func updateTableView()
    func initNavigationBar()
    
}

protocol RouteListPresenterProtocol: class {
    init(view: RouteListProtocol, mainPresenter: MainPresenterProtocol)
   
    func getRouteList() -> [Route]
    func configureView()
    func selectRouteTap(route: Route)
    func backTap()
    func getDateFormat(_ date: Date) -> String 
}


