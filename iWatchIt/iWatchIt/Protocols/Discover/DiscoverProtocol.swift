//
//  DiscoverProtocol.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 12/04/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

protocol DiscoverViewToPresenterProtocol: BaseViewToPresenterProtocol{
    var query: DiscoverQuery? {get set}
    var keywords: [TypedSearchResult]? {get set}
    var genres: [TypedSearchResult]? {get set}
    var people: [TypedSearchResult]? {get set}
    var trendingResults: [TypedSearchResult]? { get set }
    func startFetchingKeywords(term: String)
    func startFetchingGenres(mediaType: MediaType)
    func startFilteringGenres(term: String, mediaType: MediaType)
    func startFilteringGenres(term: String)
    func startFetchingPeople(term: String)
    func startDiscovering(navigationController: UINavigationController, query: DiscoverQuery, mediaType: MediaType)
    
    func startFetchingTrendingPeople()
    func didTapOnTrendingPeople(index: Int, nav: UINavigationController?) 
}

protocol DiscoverPresenterToViewProtocol: BasePresenterToViewProtocol{
    func onKeywordsFetched()
    func onGenresFiltered()
    func onPeopleFetched()
    func onTrendingPeopleFetched()
}

protocol DiscoverPresenterToRouterProtocol: BasePresenterToRouterProtocol {
    func pushToResultsScreen(navigationController: UINavigationController,
                             for searchQuery: DiscoverQuery, mediaType: MediaType)
}

protocol DiscoverPresenterToInteractorProtocol: BasePresenterToInteractorProtocol {
    func fetchKeywords(term: String)
    func fetchGenres(mediaType: MediaType)
    func fetchPeople(term: String)
    func fetchTrendingPeople(timeWindow: TimeWindow)
}

protocol DiscoverInteractorToPresenterProtocol: BaseInteractorToPresenterProtocol {
    func keywordsFetchSuccess(results: GenericSearchResults?)
    func keywordsFetchFailed(message: String?)
    func genresFetchSuccess(results: GenresRLM?)
    func genresFetchFailed(message: String?)
    func peopleFetchSuccess(results: GenericSearchResults?)
    func peopleFetchFailed(message: String?)
    func trendingPeopleFetchSuccess(results: GenericSearchResults?)
    func trendingPeopleFetchFailed(message: String?)
}
