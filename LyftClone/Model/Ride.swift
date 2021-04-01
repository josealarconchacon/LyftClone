//
//  Ride.swift
//  LyftClone
//
//  Created by Jose Alarcon Chacon on 2/12/21.
//

import Foundation
import MapKit

// Ride file is the data that user see when selecting a ride
class Ride {
    var thumbnail: String
    let name: String
    let capacity: String
    let price: Double
    let time: Date
    
    init(thumbnail: String, name: String, capacity: String, price: Double, time: Date) {
        self.thumbnail = thumbnail
        self.name = name
        self.capacity = capacity
        self.price = price
        self.time = time
    }
}
