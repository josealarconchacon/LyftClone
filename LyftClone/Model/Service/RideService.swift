//
//  RideService.swift
//  LyftClone
//
//  Created by Jose Alarcon Chacon on 2/12/21.
//

import Foundation
import CoreLocation

// RideService will manage the collection of rides
class RideService {
    
    // singleton
    static let share = RideService()
    
    private init() {}
    
    func getRide(pickupLocation: Location, dropoffLocation: Location) -> [Ride] {
        let locarion_1 = CLLocation(latitude: pickupLocation.lat, longitude: pickupLocation.lng)
        let locarion_2 = CLLocation(latitude: dropoffLocation.lat, longitude: dropoffLocation.lng)
        // distance in Meters
        let distance = locarion_1.distance(from: locarion_2)
        
        // minimum amount
        let minimum_amount = 3.0
        
        return [
            Ride(thumbnail: "ride-shared", name: "Shared", capacity: "1-2", price: minimum_amount + (distance * 0.5), time: Date()),
            Ride(thumbnail: "ride-compact", name: "Shared", capacity: "1-4", price: minimum_amount +  (distance * 0.9), time: Date()),
            Ride(thumbnail: "ride-large", name: "Shared", capacity: "1-6", price: minimum_amount + (distance * 1.5), time: Date())
        ]
    }
}
