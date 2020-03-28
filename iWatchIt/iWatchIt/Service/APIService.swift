
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
    // GET -> /configuration
    // Store in Realm
    
    // Home Services
    // GET -> getTrendingMovies
    // GET -> getTrendingTVShows
    // GET -> discoverMovies
    // GET -> discoverTVShows
    
    /// Detail services
    // GET -> getDetails
    // GET -> getVideos
    // GET -> getReviews
    // GET -> getSimilarMovies
    // GET -> getSimilarTVShows
}
