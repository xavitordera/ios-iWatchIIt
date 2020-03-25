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
    
    case trending(mediaType: String, timeWindow: String)
    
    /// Discover trending movies
    
    case discover(mediaType: String, language: String, withGenres: String)
    

    var method: HTTPMethod {
        switch self {
            
        case .configuration, .trending, .discover: return .get
        
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
        case .trending(let mediaType, let timeWindow): return String(format: kGETTrending, mediaType, timeWindow)
        case .discover(let mediaType, _, _): return String(format: kGETDiscover, mediaType)
        }
    }
    
    
    var parameters: [String: Any]? {
        switch self {
        case .configuration:
            return [kApiKey: kTMDBAPIKey]
        case .trending(_, _):
            return [kApiKey: kTMDBAPIKey]
        case .discover(_, let language, let withGenres):
            return [kApiKey: kTMDBAPIKey, kLanguage: language, kWithGenres: withGenres]
        default:
            return nil
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try APIRouter.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = .none
        
        switch self {
            
        //case :
          //      urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters) // URL
//        case .createNewTV, .positionHasBeenPlayed, .positionStartedToPlay:
//                urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters) // Body
            default: break
        }
        
        return urlRequest
    }
}
