//
//  LocationViewController.swift
//  LyftClone
//
//  Created by Jose Alarcon Chacon on 2/19/21.
//

import UIKit

class LocationViewController: UIViewController {
    
    // colletion of locations
    var locations = [Location]()
    var pickup: Location?
    var dropoff: Location?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        locations = LocationService.share.get_recent_location()
    }
}

extension LocationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell_identifier = "LocationCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cell_identifier) as! LocationCell
        
        let location = locations[indexPath.row]
        cell.update(location: location)
        return cell
    }
}
