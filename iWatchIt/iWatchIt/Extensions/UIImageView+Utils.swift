//
//  UIImageView+Utls.swift
//  WindowSightAPP
//
//  Created by Albert Mayans on 13/06/2019.
//  Copyright © 2019 Slashmobility. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func imageFrom(url: URL, with emptyState: UIImage? = kEmptyStateMedia, options: [KingfisherOptionsInfoItem] = [.cacheOriginalImage], completion: ((_ size: CGSize?) -> Void)? = nil) {
        
        kf.setImage(with: ImageResource(downloadURL: url),
                    placeholder: emptyState,
                    options: options, completionHandler:  { (result: Result<RetrieveImageResult, KingfisherError>) in

                        switch result {
                        case .failure(let error):
                            print(error)
                            completion?(nil)
                        case .success(let value):
                            let imageSize = value.image.size
                            completion?(imageSize)
                        }

                    })
    }
    
    func roundCornersForAspectFit(radius: CGFloat) {
        if let image = self.image {
            
            //calculate drawingRect
            let boundsScale = self.bounds.size.width / self.bounds.size.height
            let imageScale = image.size.width / image.size.height
            
            var drawingRect: CGRect = self.bounds
            
            if boundsScale > imageScale {
                drawingRect.size.width =  drawingRect.size.height * imageScale
                drawingRect.origin.x = (self.bounds.size.width - drawingRect.size.width) / 2
            } else {
                drawingRect.size.height = drawingRect.size.width / imageScale
                drawingRect.origin.y = (self.bounds.size.height - drawingRect.size.height) / 2
            }
            let path = UIBezierPath(roundedRect: drawingRect, cornerRadius: radius)
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
}
