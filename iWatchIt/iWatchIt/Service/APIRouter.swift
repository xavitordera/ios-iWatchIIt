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
    
    /// Gets current movie or tv genres
    case genres(mediaType: MediaType, language: String)
    
    /// Gets trending movies or tv shows
    
    case trending(mediaType: MediaType, timeWindow: String, language: String)
    
    /// Discover trending content
    
    case discover(mediaType: MediaType, language: String, withGenres: String)
    
    /// TopRated trending content
    
    case topRated(mediaType: MediaType, language: String)
    
    /// Search content
    
    case search(mediaType: MediaType, query: String, language: String, page: Int = 1)
    
    /// Get detailed information
    
    case detail(mediaType: MediaType, id: Int, language: String, appendToResponse: String)
    
    /// Keywords
    
    case searchKeyword(query: String)
    
    /// People
    
    case searchPeople(query: String, language: String)
    
    
    /// Discover Extended
    case discoverExtended(mediaType: MediaType, language: String, page: Int, withGenres: String, withPeople: String, withKeywords: String)
    
    
    /// UTELLY: - Get platform links
    
    case platforms(id: String, source: String, country: String)
    
    
    var method: HTTPMethod {
        switch self {
            
        case .configuration, .genres, .trending, .discover, .topRated, .search, .detail, .searchKeyword, .searchPeople, .discoverExtended, .platforms: return .get
            
            // case : return .head
            // case : return .delete
            // case : return .patch
            // case : return .put
        }
    }
    
    var baseURLString: String {
        switch self {
        case .configuration, .genres, .discover, .topRated, .trending, .search, .detail, .searchKeyword, .searchPeople, .discoverExtended:
            return kTMDBBaseURL + kTMDBAPIVersion
        case .platforms:
            return kUtellyBaseURL
        }
    }
    
    var path: String {
        switch self {
        case .configuration: return kGETConfiguration
        case .genres(let mediaType, _): return String(format: kGETGenres, mediaType.rawValue)
        case .trending(let mediaType, let timeWindow, _): return String(format: kGETTrending, mediaType.rawValue, timeWindow)
        case .discover(let mediaType, _, _): return String(format: kGETDiscover, mediaType.rawValue)
        case .topRated(let mediaType, _): return String(format: kGETTopRated, mediaType.rawValue)
        case .search(let mediaType, _, _, _): return String(format: kGETSearch, mediaType.rawValue)
        case .detail(let mediaType, let id, _, _): return String(format: kGETDetail, mediaType.rawValue, id)
        case .searchKeyword(_): return kGETSearchKeywords
        case .searchPeople(_,_): return kGETSearchPeople
        case .discoverExtended(let mediaType,_,_,_,_,_): return String(format: kGETDiscover, mediaType.rawValue)
        case .platforms(_, _, _): return kGETLookup
        }
    }
    
    
    var queryParams: [URLQueryItem]? {
        switch self {
        case .configuration:
            return [URLQueryItem.init(name: kApiKey, value: kTMDBAPIKey)]
        case .genres(_, let language):
            return [
                URLQueryItem.init(name: kApiKey, value: kTMDBAPIKey),
                URLQueryItem.init(name: kLanguage, value: language)
            ]
        case .trending(_, _, let language):
            return [
                URLQueryItem.init(name: kApiKey, value: kTMDBAPIKey),
                URLQueryItem.init(name: kLanguage, value: language)
            ]
        case .discover(_, let language, let withGenres):
            return [
                URLQueryItem.init(name: kApiKey, value: kTMDBAPIKey),
                URLQueryItem.init(name: kLanguage, value: language),
                URLQueryItem.init(name: kWithGenres, value: withGenres)
            ]
        case .topRated(_, let language):
            return [
                URLQueryItem.init(name: kApiKey, value: kTMDBAPIKey),
                URLQueryItem.init(name: kLanguage, value: language)
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
        case .searchKeyword(let query):
            return [
                URLQueryItem.init(name: kApiKey, value: kTMDBAPIKey),
                URLQueryItem.init(name: kQuery, value: query)
            ]
        case .searchPeople(let query, let language):
            return [
                URLQueryItem.init(name: kApiKey, value: kTMDBAPIKey),
                URLQueryItem.init(name: kLanguage, value: language),
                URLQueryItem.init(name: kQuery, value: query)
            ]
        case .discoverExtended(_, let language, let page, let withGenres, let withPeople, let withKeywords):
            return [
                URLQueryItem.init(name: kApiKey, value: kTMDBAPIKey),
                URLQueryItem.init(name: kLanguage, value: language),
                URLQueryItem.init(name: kWithGenres, value: withGenres),
                URLQueryItem.init(name: kWithPeople, value: withPeople),
                URLQueryItem.init(name: kWithKeywords, value: withKeywords),
                URLQueryItem.init(name: kPage, value: String(page))
            ]
        case .platforms(let id, let source, let country):
            return [
                URLQueryItem.init(name: kCountry, value: country),
                URLQueryItem.init(name: kSourceId, value: id),
                URLQueryItem.init(name: kSource, value: source)
            ]
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .platforms:
            return
                HTTPHeaders.init([
                    HTTPHeader.init(name: kHeaderRapidAPIHost, value: kUtellyHost),
                    HTTPHeader.init(name: kHeaderRapidAPIKey, value: randUtellyKey())
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
        case .configuration, .genres, .discover, .trending, .search, .detail, .searchKeyword, .searchPeople, .discoverExtended, .platforms, .topRated:
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
    
    private func randUtellyKey() -> String {
        let keys = Preference.getUtellyKeys()
        
        return keys.randomElement() ?? kUtellyAPIKey
    }
}

enum TimeWindow: String {
    case day = "day"
    case week = "week"
}
