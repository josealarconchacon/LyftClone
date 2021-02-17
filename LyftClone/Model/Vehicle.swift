//
//  Vehicle.swift
//  LyftClone
//
//  Created by Jose Alarcon Chacon on 2/17/21.
//

import MapKit

class Vehicle: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
