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
    func startFetchingKeywords(term: String)
    func startFilteringGenres(term: String, mediaType: MediaType)
    func startFetchingPeople(term: String)
    func contentSelected(navigationController: UINavigationController, for contentWithId: Int, and mediaType: MediaType)
}

protocol DiscoverPresenterToViewProtocol: BasePresenterToViewProtocol{
    func onKeywordsFetched(isEmpty: Bool)
    func onGenresFiltered(isEmpty: Bool)
    func onPeopleFetched(isEmpty: Bool)
}

protocol DiscoverPresenterToRouterProtocol: BasePresenterToRouterProtocol {
    func pushToResultsScreen(navigationController: UINavigationController, for searchQuery: DiscoverQuery)
}

protocol DiscoverPresenterToInteractorProtocol: BasePresenterToInteractorProtocol {
    func fetchKeywords(term: String)
    func fetchGenres(mediaType: String)
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
