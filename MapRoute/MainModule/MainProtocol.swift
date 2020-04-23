//
//  MainProtocol.swift
//  MapRoute
//
//  Created by Dmitriy Zakharov on 21.04.2020.
//  Copyright © 2020 Dmitriy Zakharov. All rights reserved.
//

import Foundation
import CoreLocation


protocol MainPresenterProtocol: class {
    init(view: MainViewProtocol)
    
    func loadRoute(route: Route)
    func getRoute(start:CLLocationCoordinate2D, end:CLLocationCoordinate2D, complition:@escaping (MapRouteResponse?) -> ())
    func configureView()
    
    func longTap(coordinate: CLLocationCoordinate2D)
    func saveRouteTap()
    func clearRouteTap()
    func createRouteTap()
    func showRouteHistoryTap()
    func currentLocationTap()
}


protocol MainViewProtocol: class {
    func initMap(source: String)
    func initTap()
    func clearAllRoutes()
    func initBarItem()
    
    func showCreateRouteButton(_ isShow: Bool)
    func showClearRouteButton(_ isShow: Bool)
    func showSaveRouteButton(_ isShow: Bool)
    func showListRouteButton(_ isShow: Bool)
    
    func zoomRegion(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D) 
    func addAnnotation(coordinate: CLLocationCoordinate2D, isStartPoint: Bool)
    func addRoutePolyline(coordinates: [CLLocationCoordinate2D])
    
    func changeRouteBuildState(_ state: RouteBuildState)
    func showError(_ error: String)
    func showSuccessSave(isSuccess: Bool)
    func showLouderSpinner(_ isShow: Bool)
    
    func initLocationManager()
    func getCurrentLocation() -> CLLocation? 
    func setCurrentRegion(_ center: CLLocationCoordinate2D) 
}

enum RouteBuildState {
    case ChoosePointA
    case ChoosePointB
    case BuildRoute
    case SaveRoute
    case YourRoute
}
