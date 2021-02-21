//
//  LocationViewController.swift
//  LyftClone
//
//  Created by Jose Alarcon Chacon on 2/19/21.
//

import UIKit

class LocationViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dropoffTextField: UITextField!
    
    
    // colletion of locations
    var locations = [Location]()
    var pickup: Location?
    var dropoff: Location?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        locations = LocationService.share.get_recent_location()
        dropoffTextField.becomeFirstResponder()
        dropoffTextField.delegate = self
    }
}

extension LocationViewController: UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    // textField delegate protocol
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let lastesString = (textField.text as! NSString).replacingCharacters(in: range, with: string)
        print("Last string: \(lastesString)")
        return true
    }
    
    
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
