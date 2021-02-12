//
//  Location.swift
//  LyftClone
//
//  Created by Jose Alarcon Chacon on 2/12/21.
//

import Foundation

class Location: Codable {
    var title: String
    var subtitle: String
    let lat: Double
    let lng: Double
    
    init(title: String, subtitle: String, lat: Double, lng: Double) {
        self.title = title
        self.subtitle = subtitle
        self.lat = lat
        self.lng = lng
    }
}
