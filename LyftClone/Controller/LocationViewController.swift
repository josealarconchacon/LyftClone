//
//  LocationViewController.swift
//  LyftClone
//
//  Created by Jose Alarcon Chacon on 2/19/21.
//

import UIKit
import MapKit

class LocationViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dropoffTextField: UITextField!
    
    
    // colletion of locations
    var locations = [Location]()
    var pickup: Location?
    var dropoff: Location?
    
    var searchCompleted = MKLocalSearchCompleter()
    var searchResult = [MKLocalSearchCompletion]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        locations = LocationService.share.get_recent_location()
        dropoffTextField.becomeFirstResponder()
        dropoffTextField.delegate = self
        
        searchCompleted.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func cancelDidTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}


extension LocationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.isEmpty ? locations.count : searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell_identifier = "LocationCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cell_identifier) as! LocationCell
        
        if searchResult.isEmpty {
            let location = locations[indexPath.row]
            cell.update(location: location)
        } else {
            let search_result = searchResult[indexPath.row]
            cell.update(searchResult: search_result)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchResult.isEmpty {
            let location = locations[indexPath.row]
            performSegue(withIdentifier: "RouteSegue", sender: location)
        } else {
            // convert search_result into a location object
            let search_result = searchResult[indexPath.row]
            let search_request = MKLocalSearch.Request(completion: search_result)
            let search = MKLocalSearch(request: search_request)
            search.start(completionHandler: {(response, error) in
                if error == nil {
                    if let dropoffPlaceMark = response?.mapItems.first?.placemark {
                        // convert PlaceMark into a location Object
                        let location = Location(placemark: dropoffPlaceMark)
                        self.performSegue(withIdentifier: "RouteSegue", sender: location)
                    }
                }
            })
        }
    }
}


// textField delegate protocol
extension LocationViewController:  UITextFieldDelegate, MKLocalSearchCompleterDelegate {
    // a later string that the user has typed
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let lastesString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        print("Last string: \(lastesString)")
        
        if lastesString.count > 3 {
            searchCompleted.queryFragment = lastesString
        }
        return true
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResult = completer.results
        // reload tableView
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let routeViewController = segue.destination as? RouteViewController,
           let dropoffLocation = sender as? Location {
            routeViewController.pickupLocation = pickup
            routeViewController.dropoffLocation = dropoffLocation
        }
    }
}
