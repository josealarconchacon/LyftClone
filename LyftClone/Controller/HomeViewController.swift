//
//  HomeViewController.swift
//  LyftClone
//
//  Created by Jose Alarcon Chacon on 2/15/21.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    
    var locations = [Location]()
    
    var locationManager: CLLocationManager!
    var currentUserLocation: Location!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        let recent_location = LocationService.share.get_recent_location()
        locations = [recent_location[0], recent_location[1]]
        
        location_manager()
        
        // Add shadow to searchButton
        searchButton.search_bar()
    }
    
    func location_manager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        if locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    // get the location update
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let first_location = locations.first!
        currentUserLocation = Location(title: "Current Location", subtitle: "", lat: first_location.coordinate.latitude, lng: first_location.coordinate.longitude)
        // stop updating the location when the user doesn't need it anymore
        locationManager.stopUpdatingLocation()
    }
}


extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! LocationCell
        let location = locations[indexPath.row]
        cell.update(location: location)
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    
}
