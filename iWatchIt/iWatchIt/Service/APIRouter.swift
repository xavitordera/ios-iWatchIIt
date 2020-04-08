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
    
    /// Get detailed information
    
    case detail(mediaType: MediaType, id: Int, language: String, appendToResponse: String)
    
    
    /// UTELLY: - Get platform links
    
    case platforms(term: String, country: String)
    
    
    var method: HTTPMethod {
        switch self {
            
        case .configuration, .trending, .discover, .search, .detail, .platforms: return .get
            
            // case : return .head
            // case : return .delete
            // case : return .patch
            // case : return .put
        }
    }
    
    var baseURLString: String {
        switch self {
        case .configuration, .discover, .trending, .search, .detail:
            return kTMDBBaseURL + kTMDBAPIVersion
        case .platforms:
            return kUtellyBaseURL
        }
    }
    
    var path: String {
        switch self {
        case .configuration: return kGETConfiguration
        case .trending(let mediaType, let timeWindow): return String(format: kGETTrending, mediaType.rawValue, timeWindow)
        case .discover(let mediaType, _, _): return String(format: kGETDiscover, mediaType.rawValue)
        case .search(let mediaType, _, _, _): return String(format: kGETSearch, mediaType.rawValue)
        case .detail(let mediaType, let id, _, _): return String(format: kGETDetail, mediaType.rawValue, id)
        case .platforms(_, _): return kGETLookup
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
        case .detail(_, _, let language, let appendToResponse):
            return [
                URLQueryItem.init(name: kApiKey, value: kTMDBAPIKey),
                URLQueryItem.init(name: kLanguage, value: language),
                URLQueryItem.init(name: kAppendToResponse, value: appendToResponse)
            ]
        case .platforms(let term, let country):
            return [
                URLQueryItem.init(name: kCountry, value: country),
                URLQueryItem.init(name: kTerm, value: term)
            ]
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .platforms:
            return
                HTTPHeaders.init([
                HTTPHeader.init(name: kHeaderRapidAPIHost, value: kUtellyHost),
                HTTPHeader.init(name: kHeaderRapidAPIKey, value: kUtellyAPIKey)
            ])
        default:
            return nil
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let serviceUrl = try self.baseURLString.asURL().appendingPathComponent(path)
        let urlComp = serviceUrl.absoluteString
        
        guard var components = URLComponents.init(string: urlComp) else {
            return URLRequest.init(url: serviceUrl)
        }
        
        switch self {
            
            //case :
        //      urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters) // URL
        case .configuration, .discover, .trending, .search, .detail, .platforms:
            components.queryItems = queryParams
        }
        
        let url = try components.asURL()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        if let headers = headers {
            urlRequest.headers = headers
        }
    
        return urlRequest
    }
}

enum TimeWindow: String {
    case day = "day"
    case week = "week"
}
