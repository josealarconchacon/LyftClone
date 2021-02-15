//
//  Button.swift
//  LyftClone
//
//  Created by Jose Alarcon Chacon on 2/15/21.
//

import UIKit

extension UIButton {
    func search_bar() {
        layer.cornerRadius = 10.0
        layer.shadowRadius = 1.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        layer.shadowOpacity = 0.5
    }
}
