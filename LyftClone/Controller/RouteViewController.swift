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
    @IBOutlet weak var pickupLabel: UILabel!
    @IBOutlet weak var dropoffLabel: UILabel!
    
    
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
        
        pickupLabel.text = pickupLocation?.title
        dropoffLabel.text = dropoffLocation?.title
        
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
        
        displayRoute(sourceLocation: pickupLocation!, destinationLocation: dropoffLocation!)

    }
    
    func displayRoute(sourceLocation: Location, destinationLocation: Location) {
        let source_coordinate = CLLocationCoordinate2D(latitude: sourceLocation.lat, longitude: sourceLocation.lng)
        let destination_coordinate = CLLocationCoordinate2D(latitude: destinationLocation.lat, longitude: destinationLocation.lng)
        let source_place_mark = MKPlacemark(coordinate: source_coordinate)
        let destination_place_mark = MKPlacemark(coordinate: destination_coordinate)
        
        let direction_request = MKDirections.Request()
        direction_request.source = MKMapItem(placemark: source_place_mark)
        direction_request.destination = MKMapItem(placemark: destination_place_mark)
        direction_request.transportType = .automobile
        
        let directions = MKDirections(request: direction_request)
        directions.calculate { (directionResponse, error) in
            if let error = error {
                print("Error calculation route: \(error.localizedDescription)")
            }
            guard let directionResponse = directionResponse  else { return }
            
            let route = directionResponse.routes[0]
            self.routeMapView.addOverlay(route.polyline, level: .aboveRoads)
            
            let adge: CGFloat = 80.0
            let boundingMapRect = route.polyline.boundingMapRect
            self.routeMapView.setVisibleMapRect(boundingMapRect, edgePadding: UIEdgeInsets(top: adge,
                                                                                           left: adge,
                                                                                           bottom: adge,
                                                                                           right: adge), animated: true)
        }
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
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.lineWidth = 5.0
        renderer.strokeColor = UIColor(red: 247.0 / 255.0, green: 66.0 / 255, blue: 190.0 / 255.0, alpha: 1)
        return renderer
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
