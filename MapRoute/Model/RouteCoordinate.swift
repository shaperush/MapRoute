//
//  RouteCoordinate.swift
//  MapRoute
//
//  Created by Dmitriy Zakharov on 23.04.2020.
//  Copyright © 2020 Dmitriy Zakharov. All rights reserved.
//

import Foundation
import RealmSwift

class RouteCoordinate: Object {
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
    @objc dynamic var route_id = ""
    @objc dynamic var created = Date()

}
