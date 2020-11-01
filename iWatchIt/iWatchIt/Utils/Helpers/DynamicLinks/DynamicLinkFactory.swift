//
//  DynamicLinkFactory.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 29/07/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import Foundation
import FirebaseDynamicLinks
import LinkPresentation

let kDynamicLinkURL = "https://iwatchthis.page.link"
let kDynamicLinkBaseURL = "https://iwatchthis.page.link"

enum ShareContent {
    case movie(id: String, title: String, description: String?, image: String?)
    case show(id: String, title: String, description: String?, image: String?)
    
    var type: String {
        switch self {
        case .movie:
            return "0"
        case .show:
            return "1"
        }
    }
    
    var id: String {
        switch self {
        case .movie(let id,_,_,_):
            return id
        case .show(let id,_,_,_):
            return id
        }
    }
}

final class DynamicLinkFactory {
    
    static let shared = DynamicLinkFactory()
    
    /// Constructs a dynamic link from a given content
    /// - Parameters:
    ///   - content: The given content, including the type and the id
    ///   - completion: completion giving the created Dynamic link URL or nil if error
    func share(content: ShareContent, _ completion: @escaping (_ url: URL?) -> ()) {
        createDynamicLink(for: content, completion)
    }
    
    private func createDynamicLink(for content: ShareContent, _ completion: @escaping (_ url: URL?) -> ()) {
        
        guard let link = URL(string: kDynamicLinkBaseURL+"/\(content.type)/\(content.id)") else { return }
        let domain = kDynamicLinkURL
        let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: domain)
        linkBuilder?.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.xtordera.iWatchIt")
        
        linkBuilder?.socialMetaTagParameters = createMetadata(content: content)
        
        DynamicLinks.performDiagnostics(completion: nil)
        
        linkBuilder?.shorten() { url, warnings, error in
            guard let url = url, error == nil else {
                completion(nil)
                return
            }
            
            DynamicLinks.performDiagnostics(completion: nil)

            print("The short URL is: \(url)")
            completion(url)
        }
    }
    
    private func createMetadata(content: ShareContent) -> DynamicLinkSocialMetaTagParameters {
        let metaData = DynamicLinkSocialMetaTagParameters()
                
        switch content {
        case .movie(_, let title, let description, let image):
            metaData.title = title
            metaData.descriptionText = description
            if let imgPath = image {
                metaData.imageURL = URL(string: imgPath)
            }
            
        case .show(_, let title, let description, let image):
            metaData.title = title
            metaData.descriptionText = description
            if let imgPath = image {
                metaData.imageURL = URL(string: imgPath)
            }
        }

        return metaData
    }
}
