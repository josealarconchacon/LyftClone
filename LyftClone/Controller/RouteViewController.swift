//
//  RouteViewController.swift
//  LyftClone
//
//  Created by Jose Alarcon Chacon on 2/22/21.
//

import UIKit

class RouteViewController: UIViewController {
    
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
}
