//
//  DataService.swift
//  MapRoute
//
//  Created by Dmitriy Zakharov on 21.04.2020.
//  Copyright © 2020 Dmitriy Zakharov. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation

protocol DataServiceProtocol {
    func saveRoute(route: MapRouteResponse, isSuccess:(Bool) -> ())
    func getRouteList(complition: ([Route]?) -> ())
    func getCoordinateList(routeId: String, complition: ([CLLocationCoordinate2D]) -> ())
}

class DataService: DataServiceProtocol {
    
    
    // MARK: - DataServiceProtocol methods
    
    func getCoordinateList(routeId: String, complition: ([CLLocationCoordinate2D]) -> ()) {
        let configuration = Realm.Configuration(schemaVersion:2)
        let realm = try! Realm(configuration: configuration)
        let list =  realm.objects(RouteCoordinate.self).filter("route_id = '\(routeId)'")
        var coordinateList:[CLLocationCoordinate2D] = []
        list.forEach { (body) in
            let coord = CLLocationCoordinate2D(latitude: body.latitude, longitude: body.longitude)
            coordinateList.append(coord)
        }
        complition(coordinateList)
    }
    
    func getRouteList(complition: ([Route]?) -> ()) {
        var routes:[Route] = []
        let configuration = Realm.Configuration(schemaVersion:2)
        let realm = try! Realm(configuration: configuration)
        let list =  realm.objects(Route.self).sorted(byKeyPath: "created", ascending: false)
        list.forEach { (body) in
            routes.append(body)
        }
        complition(routes)
    }
    
    func saveRoute(route: MapRouteResponse, isSuccess:(Bool) -> ()) {
        let configuration = Realm.Configuration(schemaVersion:2)
        print(configuration.fileURL!)
        let realm = try! Realm(configuration: configuration)
        try! realm.write() {
            if let b = route.coordinates.last ,let a = route.coordinates.first {
                let model = Route()
                model.duration = route.duration
                model.distance = route.distance
                model.latitudeA = Double(a.latitude)
                model.latitudeB = Double(b.latitude)
                model.longitudeA = Double(a.longitude)
                model.longitudeB = Double(b.longitude)
                realm.add(model)
                
                route.coordinates.forEach { (body) in
                    let cord = RouteCoordinate()
                    cord.route_id = model.id
                    cord.longitude = Double(body.longitude)
                    cord.latitude = Double(body.latitude)
                    realm.add(cord)
                }
                isSuccess(true)
            }
        }
    }
}



