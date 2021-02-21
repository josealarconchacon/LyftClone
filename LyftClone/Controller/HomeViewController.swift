//
//  HomeViewController.swift
//  LyftClone
//
//  Created by Jose Alarcon Chacon on 2/15/21.
//

import UIKit
import CoreLocation
import MapKit

class HomeViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // passing data between home and location vc
        if let locationViewController = segue.description as? LocationViewController {
            locationViewController.pickup = currentUserLocation
        }
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
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        // zoom in to the user location
        let distance = 200.0
        let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: distance, longitudinalMeters: distance)
        mapView.setRegion(region, animated: true)
        
        let lat = userLocation.coordinate.latitude
        let lng = userLocation.coordinate.longitude
        let offset = 0.00075
        let coord1 = CLLocationCoordinate2D(latitude: lat - offset, longitude: lng - offset)
        let coord2 = CLLocationCoordinate2D(latitude: lat, longitude: lng + offset)
        let coord3 = CLLocationCoordinate2D(latitude: lat, longitude: lng - offset)
        
        // create vehicle annotation and add it to mapview
        mapView.addAnnotations([
            Vehicle(coordinate: coord1),
            Vehicle(coordinate: coord2),
            Vehicle(coordinate: coord3)
        ])
    }
    
    // custom annotation view
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        // create custom annotation view with vehicle image
        let reuseIdentifier = "Vehicle"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.image = UIImage(named: "car")
        annotationView?.transform = CGAffineTransform(rotationAngle: CGFloat(arc4random_uniform(360) * 180) / CGFloat.pi)
        return annotationView
    }
}


extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
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

