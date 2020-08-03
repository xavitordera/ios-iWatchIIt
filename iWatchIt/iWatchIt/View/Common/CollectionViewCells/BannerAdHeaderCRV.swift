//
//  BannerAdHeaderCRV.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 03/08/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

class BannerAdHeaderCRV: UICollectionReusableView, Reusable {
    var banner: UIView?
    
    func configureWithBanner(banner: UIView) {
        
        guard self.banner == nil else {return}
        
        self.banner = banner
        
        banner.center = self.center
        addSubview(banner)
    }
}
