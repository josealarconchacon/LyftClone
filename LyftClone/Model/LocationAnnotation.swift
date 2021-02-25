//
//  LocationAnnotation.swift
//  LyftClone
//
//  Created by Jose Alarcon Chacon on 2/25/21.
//

import UIKit
import MapKit

class LocationAnnotation: NSObject, MKAnnotation {
    
    var coordinate:  CLLocationCoordinate2D
    let location_type: String
    
    init(coordinate: CLLocationCoordinate2D, location_type: String) {
        self.coordinate = coordinate
        self.location_type = location_type
    }
}
