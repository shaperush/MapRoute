//
//  MapService.swift
//  MapRoute
//
//  Created by Dmitriy Zakharov on 21.04.2020.
//  Copyright © 2020 Dmitriy Zakharov. All rights reserved.
//


import Foundation
import CoreLocation


protocol MapServiceProtocol {
    
    init(network: NetworkServiceProtocol)
    var mapUrl: String {get}
    
    // get route coordinates,distance and duration
    func getRouteByCoordinate(start:CLLocationCoordinate2D , end:CLLocationCoordinate2D, complition: @escaping (MapRouteResponse?) -> ())
}

class MapService : MapServiceProtocol {
    
    public var mapUrl: String {
        return "http://tile.openstreetmap.org/{z}/{x}/{y}.png"
    }
    
    private let networkService: NetworkServiceProtocol!
    private let apiToken = "5b3ce3597851110001cf6248d353d150805e49d48bea50044f1d58a6"
    private let apiURL = "https://api.openrouteservice.org/v2/directions/driving-car?api_key="
    
    required init(network: NetworkServiceProtocol) {
        self.networkService = network
    }
    
    // MARK: - MapServiceProtocol methods
    
    func getRouteByCoordinate(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D, complition:  @escaping (MapRouteResponse?) -> ())  {
        let urlString = uriBuilder(start: start, end: end)
        networkService.getRoute(urlString: urlString) {[weak self] (dict, error) in
            guard let dict = dict else {
               DispatchQueue.main.async {
                    complition(MapRouteResponse(error: "fail query"))
                }
                return
            }
            print(dict)
            DispatchQueue.main.async {
                complition(self?.parseData(dict))
            }
        }
    }
    
    // MARK: - Private methods
    
    private func uriBuilder(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D) -> String {
        
       
//http://maps.openrouteservice.org/directions?n1=25.347206&n2=51.503949&n3=14&a=25.353199,51.521431,25.352423,51.462723&b=0&c=0&k1=en-US&k2=km

        return  "\(apiURL)\(apiToken)&start=\(start.longitude),\(start.latitude)&end=\(end.longitude),\(end.latitude)"
    }
    
    private func parseData(_ json: [String: Any]?) -> MapRouteResponse {
        guard let dict = json else {return MapRouteResponse(error: "fail query")}
       
        if let err = dict["error"] as? [String: Any]  {
            guard let message = err["message"] as? String else {
                return MapRouteResponse(error: "fail query")
            }
            return MapRouteResponse(error: message)
        }
            
        guard let features = dict["features"] as? [Any],
            let firstFeatures = features[0] as? [String: Any],
            let properties = firstFeatures["properties"] as?  [String: Any],
            let summary = properties["summary"] as?  [String: Any],
            let distance = summary["distance"] as?  Double,
            let duration = summary["duration"] as?  Double,
            let geometry = firstFeatures["geometry"] as? [String: Any],
            let coordinates = geometry["coordinates"] as? [Any] else {
                return MapRouteResponse(error: "fail query")
            }
                    
        var response = MapRouteResponse()
        response.distance = distance
        response.duration = duration
        coordinates.forEach {
            if let coordinate = $0 as? [Double] {
                response.coordinates.append(CLLocationCoordinate2D(latitude: coordinate[1], longitude: coordinate[0]))
            }
        }
        return response
    }
    
}


