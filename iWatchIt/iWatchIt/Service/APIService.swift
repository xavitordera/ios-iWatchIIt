
//
//  File.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 22/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import Alamofire
import Foundation

class APIService {
    
    static let shared: APIService = APIService()
    
    lazy var sessionManager: Session = {
        let configuration = URLSessionConfiguration.default
    
        configuration.headers = .default
        
        return Session(configuration: configuration)
    }()
    
    func requestObject<T: Decodable>(from route: APIRouter, decoder: JSONDecoder = JSONDecoder(), completion: (@escaping (_: Result<T, Error>) -> Void)) {
        
        sessionManager.request(route).responseDecodable(of: T.self) { (response) in
            
            guard let resp = response.response,
                (200...300).contains(resp.statusCode) else {
                    
                    guard let error = response.error else {
                        completion(.failure(AppError.generic))
                        return
                    }
                    
                    completion(.failure(error.localizedDescription.isEmpty ? AppError.generic: error))
                    
                    return
            }
                
            switch response.result {
            case .failure(let error):
                completion(Result.failure(error))
            case .success(let value):
                completion(Result.success(value))
            }
        }
       }
    
    
    // MARK: - The movie DB services
    
    /// Configuration
    func getConfiguration(completion: @escaping (Configuration?, Error?) -> Void) {
        requestObject(from: APIRouter.configuration) { (result: Result<RootConfiguration, Error>) in
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let value):
                completion(value.images, nil)
            }
        }
    }
    
    func getGenres(mediaType: MediaType, language: String, completion: @escaping (RootGenres?, Error?) -> Void) {
        requestObject(from: APIRouter.genres(mediaType: mediaType, language: language)) { (result: Result<RootGenres, Error>)
            in
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let value):
                completion(value, nil)
            }
        }
    }
    
    // Home Services
    
    func getTrending(mediaType: MediaType, timeWindow: TimeWindow, language: String, completion: @escaping (Root?, Error?) -> Void) {
        requestObject(from: APIRouter.trending(mediaType: mediaType, timeWindow: timeWindow.rawValue, language: language)) { (result: Result<Root, Error>)
            in
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let value):
                completion(value, nil)
            }
        }
    }
    
    func discover(mediaType: MediaType, language: String, withGenres: String, completion: @escaping (Root?, Error?) -> Void) {
        requestObject(from: APIRouter.discover(mediaType: mediaType, language: language, withGenres: withGenres)) { (result: Result<Root, Error>)
            in
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let value):
                completion(value, nil)
            }
        }
    }

    func search(query: String, mediaType: MediaType, language: String, page: Int, completion: @escaping (Root?, Error?) -> Void) {
        requestObject(from: APIRouter.search(mediaType: mediaType, query: query, language: language, page: page)) { (result: Result<Root, Error>)
            in
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let value):
                completion(value, nil)
            }
        }
    }
    
    func searchKeyword(query: String, completion: @escaping (GenericSearchResults?, Error?) -> Void) {
        requestObject(from: APIRouter.searchKeyword(query: query)) { (result: Result<GenericSearchResults, Error>)
            in
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let value):
                completion(value, nil)
            }
        }
    }
    
    func searchPeople(query: String, language: String, completion: @escaping (GenericSearchResults?, Error?) -> Void) {
        requestObject(from: APIRouter.searchPeople(query: query, language: language)) { (result: Result<GenericSearchResults, Error>)
            in
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let value):
                completion(value, nil)
            }
        }
    }
    
    /// Detail services
    
    func detail(mediaType: MediaType, id: Int, language: String, appendToResponse: String, completion: @escaping (ContentExtended?, Error?) -> Void) {
        requestObject(from: APIRouter.detail(mediaType: mediaType, id: id, language: language, appendToResponse: appendToResponse)) { (result: Result<ContentExtended, Error>)
            in
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let value):
                completion(value, nil)
            }
        }
    }
    
    func discoverExtended(mediaType: MediaType, language: String, withGenres: String, withPeople: String, withKeywords: String, page: Int, completion: @escaping (Root?, Error?) -> Void) {
        requestObject(from: APIRouter.discoverExtended(mediaType: mediaType, language: language, page: page, withGenres: withGenres, withPeople: withPeople, withKeywords: withKeywords)) { (result: Result<Root, Error>)
            in
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let value):
                completion(value, nil)
            }
        }
    }
    
    func getTrendingPeople(mediaType: MediaType, timeWindow: TimeWindow, language: String, completion: @escaping (GenericSearchResults?, Error?) -> Void) {
        requestObject(from: APIRouter.trending(mediaType: mediaType, timeWindow: timeWindow.rawValue, language: language)) { (result: Result<GenericSearchResults, Error>)
            in
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let value):
                completion(value, nil)
            }
        }
    }
    
    func getPlatforms(id: String, country: String, source: String, completion: @escaping (RootPlatform?, Error?) -> Void) {
        requestObject(from: APIRouter.platforms(id: id, source: source, country: country)) { (result: Result<RootPlatform, Error>)
            in
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let value):
                completion(value, nil)
            }
        }
    }
    // GET -> getReviews
    // GET -> getSimilarMovies
    // GET -> getSimilarTVShows
}
