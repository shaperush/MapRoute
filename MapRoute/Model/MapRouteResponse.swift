//
//  MapRouteResponse.swift
//  MapRoute
//
//  Created by Dmitriy Zakharov on 23.04.2020.
//  Copyright © 2020 Dmitriy Zakharov. All rights reserved.
//

import Foundation
import CoreLocation

struct MapRouteResponse {
    var coordinates: [CLLocationCoordinate2D] = []
    var distance: Double = 0.0000
    var duration: Double = 0.0000
    var error: String? = nil
}
