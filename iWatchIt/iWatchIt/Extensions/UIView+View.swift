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
    
    func addGradient(startColor: UIColor, endColor: UIColor, startingY: CGFloat, endY: CGFloat) {
        
        let gradient = CAGradientLayer()
        
        let newFrame = CGRect(x: 0, y: startingY, width: self.frame.width, height: endY)
        
        gradient.frame = newFrame
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        
//        self.layer.insertSublayer(gradient, below: self.layer)

        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func hasGradient() -> Bool {
        guard let layers = layer.sublayers else { return false }
        for layer in layers {
            if layer.isKind(of: CAGradientLayer.self) {
                return true
            }
        }
        return false
    }
}
