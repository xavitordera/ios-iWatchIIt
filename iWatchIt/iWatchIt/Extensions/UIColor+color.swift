//
//  UIColor+color.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 27/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

extension UIColor {
    static var darkGray = UIColor.init(red: 67.0, green: 67.0, blue: 67.0, alpha: 1.0)
    public static var whiteOrBlack: UIColor = {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    /// Return the color for Dark Mode
                    return .white
                } else {
                    /// Return the color for Light Mode
                    return .black
                }
            }
        } else {
            /// Return a fallback color for iOS 12 and lower.
            return .white
        }
    }()
    
    public static var blackOrWhite: UIColor = {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    /// Return the color for Dark Mode
                    return .black
                } else {
                    /// Return the color for Light Mode
                    return .white
                }
            }
        } else {
            /// Return a fallback color for iOS 12 and lower.
            return .white
        }
    }()
}
