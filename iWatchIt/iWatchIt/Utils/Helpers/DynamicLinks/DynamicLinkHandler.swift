//
//  DynamicLinkHandler.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 01/08/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import Foundation
import FirebaseDynamicLinks

final class DynamicLinkHandler {
    static let shared = DynamicLinkHandler()
    
    func manage(link: DynamicLink) {
        guard let url = link.url else {
            debugPrint("Error - Odd, dynamic link has no url")
            return
        }
        
        debugPrint("incoming link parameter is: \(url.absoluteString)")
        
        let components = url.pathComponents
        
        guard components.count == 2 else {
            debugPrint("Error - Dynamic Link components not expected")
                       return
        }
        
        let type = components[0]
        let id = components[1]
        
        switch type {
        case "0":
            // MOVIE
            if let id = Int(id) {
                let detailVC = DetailRouter.shared.createModule(with: id, and: .movie)
                navigate(detailVC)
            }
            
        case "1":
            // SHOW
            if let id = Int(id) {
                let detailVC = DetailRouter.shared.createModule(with: id, and: .show)
                navigate(detailVC)
            }
            
        default:
            break
        }
    }
    
    private func navigate(_ viewController: UIViewController) {
        Navigation.shared.navigateTo(viewController)
    }
}
