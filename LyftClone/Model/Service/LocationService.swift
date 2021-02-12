//
//  LocationService.swift
//  LyftClone
//
//  Created by Jose Alarcon Chacon on 2/12/21.
//

import Foundation

// Location Service Class that will manage a collection of locations

class LocationService {
    
    // singleton
    static let share = LocationService()
    
    // collection of recent location
    private var recent_location = [Location]()
    
    private init() {
        // load json data into recent_location property
        let location_url = Bundle.main.url(forResource: "locations", withExtension: "json")!
        let data = try! Data(contentsOf: location_url)
        let decoder = JSONDecoder()
        recent_location = try! decoder.decode([Location].self, from: data)
    }
    
    func get_recent_location() -> [Location]{
        return recent_location
    }
}
