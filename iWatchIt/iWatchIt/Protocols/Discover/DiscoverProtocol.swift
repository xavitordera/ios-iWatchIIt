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
    var keywords: [Keyword]? {get set}
    var genres: [GenreRLM]? {get set}
    var people: [People]? {get set}
    func startFetchingKeywords(term: String)
    func startFetchingGenres(mediaType: MediaType)
    func startFilteringGenres(term: String, mediaType: MediaType)
    func startFetchingPeople(term: String)
    func contentSelected(navigationController: UINavigationController, for contentWithId: Int, and mediaType: MediaType)
    func didSelectKeyword(keyword: Keyword)
    func didSelectGenre(genre: GenreRLM)
    func didSelectPeople(people: People)
    func didBeginSearch(discoverType: DiscoverType, mediaType: MediaType, navigationController: UINavigationController, queryDelegate: DiscoverQueryDelegate)
}

protocol DiscoverPresenterToViewProtocol: BasePresenterToViewProtocol{
    func onKeywordsFetched()
    func onGenresFiltered(mediaType: MediaType)
    func onPeopleFetched()
}

protocol DiscoverPresenterToRouterProtocol: BasePresenterToRouterProtocol {
    func pushToResultsScreen(navigationController: UINavigationController,
                             for searchQuery: DiscoverQuery)
    
    func presentSearchInfoVC(discoverType: DiscoverType,
                             and mediaType: MediaType,
                             queryDelegate: DiscoverQueryDelegate,
                             nav: UINavigationController)
}

protocol DiscoverPresenterToInteractorProtocol: BasePresenterToInteractorProtocol {
    func fetchKeywords(term: String)
    func fetchGenres(mediaType: MediaType)
    func fetchPeople(term: String)
}

protocol DiscoverInteractorToPresenterProtocol: BaseInteractorToPresenterProtocol {
    func keywordsFetchSuccess(results: RootKeyword?)
    func keywordsFetchFailed(message: String?)
    func genresFetchSuccess(results: GenresRLM?)
    func genresFetchFailed(message: String?)
    func peopleFetchSuccess(results: RootPeople?)
    func peopleFetchFailed(message: String?)
}
