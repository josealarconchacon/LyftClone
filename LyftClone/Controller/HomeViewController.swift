//
//  HomeViewController.swift
//  LyftClone
//
//  Created by Jose Alarcon Chacon on 2/15/21.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    
    var locations = [Location]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        let recent_location = LocationService.share.get_recent_location()
        locations = [recent_location[0], recent_location[1]]
        // Add shadow to searchButton
        searchButton.search_bar()
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
