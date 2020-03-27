//
//  AlertHelper.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 27/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

class AlertHelper {
    class func alertWith(title: String?, message: String?) -> UIAlertController {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        return alert
    }
}
