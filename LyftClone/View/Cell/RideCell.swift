//
//  RideCell.swift
//  LyftClone
//
//  Created by Jose Alarcon Chacon on 2/22/21.
//

import UIKit

class RideCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rideImage: UIImageView!
    @IBOutlet weak var capacityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    func update(ride: Ride) {
        rideImage.image = UIImage(named: ride.thumbnail)
        titleLabel.text = ride.name
        capacityLabel.text = ride.capacity
        priceLabel.text = String(format: "$%.2f", ride.price)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mma"
        
        titleLabel.text = dateFormatter.string(from: ride.time)
    }
}
