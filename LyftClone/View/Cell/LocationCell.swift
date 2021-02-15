//
//  LocationCell.swift
//  LyftClone
//
//  Created by Jose Alarcon Chacon on 2/15/21.
//

import UIKit

class LocationCell: UITableViewCell {
    
    @IBOutlet weak var addressNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    // update outlet with location content
    func update(location: Location) {
        addressNameLabel.text = location.title
        addressLabel.text = location.subtitle
    }
}
