//
//  UIView+View.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 04/04/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

extension UIView {
    func addGradient(startColor: UIColor, endColor: UIColor) {
        
        let gradient = CAGradientLayer()

        gradient.frame = self.bounds
        gradient.colors = [startColor.cgColor, endColor.cgColor]

        self.layer.insertSublayer(gradient, at: 0)
    }
}
