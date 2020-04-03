//
//  UIBarButtonItem+Item.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 03/04/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

enum BarButtonItemType:Int {
    case watchlistAdd
    case watchlistAdded
    case share
}

extension UIBarButtonItem
{
    convenience init(type:BarButtonItemType, target:Any, action:Selector)
    {
        var image: UIImage?
        
        switch type {
        case .watchlistAdd:
            image = kWatchlistAdd
        case .watchlistAdded:
            image = kWatchlistAdded
        case .share:
            image = kShare
        }
        
        let menuBtn = UIButton(type: .custom)
        menuBtn.frame = CGRect(x: 0.0, y: 0.0, width: 21, height: 21)
        menuBtn.setImage(image, for: .normal)
        menuBtn.addTarget(target, action: action, for: .touchUpInside)
    
        self.init(customView:menuBtn)
        
        let currWidth = customView?.widthAnchor.constraint(equalToConstant: 23)
        currWidth?.isActive = true
        let currHeight = customView?.heightAnchor.constraint(equalToConstant: 23)
        currHeight?.isActive = true
    }
}
