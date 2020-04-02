//
//  APIRouter.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 25/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//
import Alamofire
import Foundation

enum APIRouter: URLRequestConvertible {
    
    /// Gets API configuration.
    
    case configuration
    
    /// Gets trending movies or tv shows
    
    case trending(mediaType: MediaType, timeWindow: String)
    
    /// Discover trending content
    
    case discover(mediaType: MediaType, language: String, withGenres: String)
    
    /// Search content
    
    case search(mediaType: MediaType, query: String, language: String, page: Int = 1)
    

    var method: HTTPMethod {
        switch self {
            
        case .configuration, .trending, .discover, .search: return .get
        
        // case : return .head
        // case : return .delete
        // case : return .patch
        // case : return .put
        }
    }
    
    static let baseURLString = kTMDBBaseURL + kTMDBAPIVersion
    
    var path: String {
        switch self {
        case .configuration: return kGETConfiguration
        case .trending(let mediaType, let timeWindow): return String(format: kGETTrending, mediaType.rawValue, timeWindow)
        case .discover(let mediaType, _, _): return String(format: kGETDiscover, mediaType.rawValue)
        case .search(let mediaType, _, _, _): return String(format: kGETSearch, mediaType.rawValue)
        }
    }
    
    
    var queryParams: [URLQueryItem]? {
        switch self {
        case .configuration:
            return [URLQueryItem.init(name: kApiKey, value: kTMDBAPIKey)]
        case .trending(_, _):
            return [URLQueryItem.init(name: kApiKey, value: kTMDBAPIKey)]
        case .discover(_, let language, let withGenres):
            return [
                URLQueryItem.init(name: kApiKey, value: kTMDBAPIKey),
                URLQueryItem.init(name: kLanguage, value: language),
                URLQueryItem.init(name: kWithGenres, value: withGenres)
            ]
        case .search(_ , let query, let language, let page):
            return [
                URLQueryItem.init(name: kApiKey, value: kTMDBAPIKey),
                URLQueryItem.init(name: kLanguage, value: language),
                URLQueryItem.init(name: kQuery, value: query),
                URLQueryItem.init(name: kPage, value: String(page))
            ]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let serviceUrl = try APIRouter.baseURLString.asURL().appendingPathComponent(path)
        let urlComp = serviceUrl.absoluteString
        
        guard var components = URLComponents.init(string: urlComp) else {
            return URLRequest.init(url: serviceUrl)
        }
        
        switch self {
            
        //case :
          //      urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters) // URL
        case .configuration, .discover, .trending, .search:
            components.queryItems = queryParams
        }
        
        let url = try components.asURL()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = .none
        
        debugPrint(urlRequest)
        
        return urlRequest
    }
}

enum TimeWindow: String {
    case day = "day"
    case week = "week"
}
