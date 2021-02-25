//
//  RouteViewController.swift
//  LyftClone
//
//  Created by Jose Alarcon Chacon on 2/22/21.
//

import UIKit
import MapKit

class RouteViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var routeMapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var routeLableView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var selecteRideButton: UIButton!
    
    
    var selectedIndex = 1
    
    var pickupLocation: Location?
    var dropoffLocation: Location?
    var ride = [Ride]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        view_button_layout()
        location()
        mapView_annotation()
    }
    
    func view_button_layout() {
        // rounding all the corners
        routeLableView.layer.cornerRadius = 10.0
        backButton.layer.cornerRadius = backButton.frame.size.width / 2.0
        selecteRideButton.layer.cornerRadius = 10.0
    }
    
    func location() {
        let location = LocationService.share.get_recent_location()
        pickupLocation = location[0]
        dropoffLocation = location[1]
        ride = RideService.share.getRide(pickupLocation: pickupLocation!, dropoffLocation: dropoffLocation!)
    }
    
    // Add annotation to mapView
    func mapView_annotation() {
        let pickup = CLLocationCoordinate2D(latitude: pickupLocation!.lat, longitude: pickupLocation!.lng)
        let dropoff = CLLocationCoordinate2D(latitude: dropoffLocation!.lat, longitude: dropoffLocation!.lng)
        let pickup_annotation = LocationAnnotation(coordinate: pickup, location_type: "pickup")
        let dropoff_annotation = LocationAnnotation(coordinate: dropoff, location_type: "dropoff")
        routeMapView.addAnnotations([pickup_annotation, dropoff_annotation])
        
        routeMapView.delegate = self

    }
}

extension RouteViewController: UITableViewDataSource, UITableViewDelegate  {
    // da
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ride.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RideCell") as! RideCell
        
        let rides = ride[indexPath.row]
        cell.update(ride: rides)
        cell.updateSelectedStatus(status: indexPath.row == selectedIndex)
        return cell
    }
    
    //de
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        let selected_ride = ride[indexPath.row]
        selecteRideButton.setTitle("Select \(selected_ride.name)", for: .normal)
        tableView.reloadData()
    }
    
    // costume annotation view
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { // will not provide a custom view for user location
            return nil
        }
        let identifire = "LocationAnnotation"
        var annotationView = routeMapView.dequeueReusableAnnotationView(withIdentifier: identifire)
        // if don't get an annotation from the identifier,created it
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifire)
        } else {
            annotationView!.annotation = annotation
        }
        
        // custom annotation image view
        let locationAnnotation = annotation as! LocationAnnotation
        annotationView?.image = UIImage(named: "dot-\(locationAnnotation.location_type)")
        return annotationView
    }
}
