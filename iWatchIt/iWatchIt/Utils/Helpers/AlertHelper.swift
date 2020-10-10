//
//  AlertHelper.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 27/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

class AlertHelper {
    class func simpleAlertWith(title: String?, message: String?, action: String?) -> UIAlertController {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: action, style: .cancel, handler: nil))
        return alert
    }
}
