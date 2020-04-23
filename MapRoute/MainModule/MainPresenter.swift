//
//  MainPresenter.swift
//  MapRoute
//
//  Created by Dmitriy Zakharov on 21.04.2020.
//  Copyright © 2020 Dmitriy Zakharov. All rights reserved.
//

import Foundation
import CoreLocation


class MainPresenter : MainPresenterProtocol {
    var count: Int = 0
    unowned var view: MainViewProtocol!
    var mapService: MapServiceProtocol!
    var dataService: DataServiceProtocol!
    var router: AppRouterProtocol!
    var routeData: MapRouteResponse?
    var currentLocation: CLLocation?
    var pointA: CLLocation?
    var pointB: CLLocation?
    
    required init(view: MainViewProtocol) {
        self.view = view
    }
    
    
    
    // MARK: - MainPresenterProtocol methods
    
    func loadRoute(route: Route) {
        dataService.getCoordinateList(routeId: route.id) { [weak self] (result) in
            self?.clearRouteTap()
            
            let from = CLLocation(latitude: route.latitudeA, longitude: route.longitudeA)
            let to = CLLocation(latitude: route.latitudeB, longitude: route.longitudeB)
            self?.view.addAnnotation(coordinate: from.coordinate , isStartPoint: true)
            self?.view.addAnnotation(coordinate: to.coordinate , isStartPoint: false)
            pointA = from
            pointB = to
            
            self?.createPolylineRoute(from: from.coordinate, to: to.coordinate, coordinates: result, state: .YourRoute)
        }
    }
    
    func getRoute(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D, complition: @escaping (MapRouteResponse?) -> ()) {
        mapService.getRouteByCoordinate(start: start, end: end) { (response) in
            complition(response)
        }
    }
    
    func configureView() {
        self.view.initMap(source: self.mapService.mapUrl)
        self.view.clearAllRoutes()
        self.view.initTap()
        self.view.initBarItem()
        
        self.view.showClearRouteButton(false)
        self.view.showCreateRouteButton(false)
        self.view.showSaveRouteButton(false)
        self.view.showListRouteButton(true)
        
        self.view.changeRouteBuildState(.ChoosePointA)
        
        self.view.initLocationManager()
        currentLocationTap()
    }
    
    func longTap(coordinate: CLLocationCoordinate2D) {
        let loc = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        if pointA == nil {
            pointA = loc
            self.view.addAnnotation(coordinate: loc.coordinate , isStartPoint: true)
            self.view.showClearRouteButton(true)
            self.view.changeRouteBuildState(.ChoosePointB)
            return
        }
        
       if pointB == nil  {
            pointB = loc
            self.view.addAnnotation(coordinate: loc.coordinate , isStartPoint: false)
            self.view.showClearRouteButton(true)
            self.view.showCreateRouteButton(true)
            self.view.changeRouteBuildState(.BuildRoute)
            return
        }
    }
    
    func saveRouteTap() {
        if let routeData = routeData {
            self.view.showLouderSpinner(true)
            dataService.saveRoute(route: routeData) { [weak self] (isSuccess) in
                self?.view.showLouderSpinner(false)
                self?.view.showSuccessSave(isSuccess: isSuccess)
                if isSuccess {
                    self?.view.showSaveRouteButton(false)
                }
            }
        }
    }
    
    func clearRouteTap() {
        pointA = nil
        pointB = nil
        self.view.clearAllRoutes()
        self.view.showClearRouteButton(false)
        self.view.showCreateRouteButton(false)
        self.view.showSaveRouteButton(false)
        self.view.showListRouteButton(true)
        self.view.changeRouteBuildState(.ChoosePointA)
    }
    
    func createRouteTap() {
        self.view.showLouderSpinner(true)
        if let from = pointA, let to = pointB {
            self.getRoute(start: from.coordinate, end: to.coordinate) { [weak self] (response) in
                self?.view.showLouderSpinner(false)
                guard let response = response  else {return}
                if let error = response.error  {
                    self?.view.showError(error)
                } else {
                    self?.createPolylineRoute(from: from.coordinate, to: to.coordinate, coordinates: response.coordinates, state: .SaveRoute)
                    self?.routeData = response
                }
            }
        }
    }
    
    func showRouteHistoryTap() {
        router.showRouteScreen(mainPresenter: self)
    }
    
    func currentLocationTap() {
        guard let location = self.view.getCurrentLocation() else { return }
        self.view.setCurrentRegion(location.coordinate)
    }
    
    private func createPolylineRoute(from: CLLocationCoordinate2D,
                                       to: CLLocationCoordinate2D,
                                       coordinates:[CLLocationCoordinate2D],
                                       state: RouteBuildState) {
          
          self.view.showListRouteButton(false)
          self.view.showCreateRouteButton(false)
          self.view.showSaveRouteButton(state == .SaveRoute ? true : false)
          self.view.showClearRouteButton(true)
          
          self.view.addRoutePolyline(coordinates: coordinates)
          self.view.changeRouteBuildState(.YourRoute)
          self.view.zoomRegion(start: from, end: to)
    }
    
}



