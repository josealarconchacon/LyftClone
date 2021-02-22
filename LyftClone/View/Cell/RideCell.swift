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
    
    
    func updateSelectedStatus(status: Bool) {
        if status {
            contentView.layer.cornerRadius = 5.0
            contentView.layer.borderWidth = 2.0
            contentView.layer.borderColor = UIColor(red: 149.0 / 255.0, green: 67.0 / 255, blue: 255.0 / 255.0, alpha: 1.0).cgColor
        } else {
            contentView.layer.borderWidth = 0.0
        }
    }
    
    func update(ride: Ride) {
        rideImage.image = UIImage(named: ride.thumbnail)
        titleLabel.text = ride.name
        capacityLabel.text = ride.capacity
        priceLabel.text = String(format: "$%.2f", ride.price)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mma"
        
        timeLabel.text = dateFormatter.string(from: ride.time)
    }
}
