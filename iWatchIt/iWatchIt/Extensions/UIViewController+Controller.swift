//
//  UIViewController+Controller.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 02/04/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import Foundation
import UIKit
import SPAlert

extension UIViewController {

    /**
     *  Height of status bar + navigation bar (if navigation bar exist)
     */

    var topbarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
    
    func showAlert(message: String, image: UIImage? = nil) {
        let alertView = SPAlertView(title: message, message: nil, preset: SPAlertPreset.done)
        alertView.haptic = .success
        alertView.duration = 2
        alertView.present()
    }
}
