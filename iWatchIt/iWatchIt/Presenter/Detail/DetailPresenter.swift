//
//  DetailPresenter.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 28/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

class DetailPresenter: BasePresenter, DetailInteractorToPresenterProtocol, DetailViewToPresenterProtocol {
    
    var detail: ContentExtended?
    var type: MediaType?
    var platforms: [Platform]?
    
    var shouldShowAffiliateCell: Bool {
        guard let platforms = platforms else { return false }
        
       for platform in platforms {
            if PlatformHelper.shouldDisplayAffiliateCell(for: platform) {
                return true
            }
        }
        
        return false
    }
    
    // MARK: Interactor protocol
    func detailFetchSuccess(detail: ContentExtended?) {
        self.detail = detail
        if let view = getView() {
            view.onDetailFetched()
        }
        
        guard let interactor = interactor as? DetailPresenterToInteractorProtocol else {
            return
        }
        interactor.saveRecentlySeen(id: detail?.id, title: detail?.title ?? detail?.name, type: type)
        
        if let externalID = self.detail?.externalIDs?.imdbID {
            interactor.fetchPlatforms(id: externalID)
        }
    }
    
    func detailFetchFailed(message: String?) {
        view?.showError(message: message)
    }
    
    func platformsFetchSuccess(platforms: RootPlatform?) {
        if let locations = PlatformHelper.filteredLocations(of: platforms) {
            self.platforms = locations
        }

        if let view = getView() {
            view.onPlatformsFetched()
        }
    }
    
    func platformsFetchFailed(message: String?) {
        view?.showError(message: message)
    }
    
    // MARK: View protocol
    
    func startFetchingDetail(type: MediaType?, id: Int?) {
        guard let interactor = interactor as? DetailPresenterToInteractorProtocol,
        let type = type,
        let id = id
        else {
            detailFetchFailed(message: "app_error_generic".localized)
            return
        }
        self.type = type
        interactor.fetchDetail(type: type, id: id, language: Preference.getLocaleLanguage())
    }
    
    func startFetchingPlatform(term: String) {
        
        guard let interactor = interactor as? DetailPresenterToInteractorProtocol else {
            return
        }
        
        interactor.fetchPlatforms(id: term)
    }
    
    func didTapOnPlatform(platform: Platform?) {
        PlatformHelper.goToPlatform(platform: platform)
    }
    
    func didTapOnCast(cast: Cast?, nav: UINavigationController?) {
        guard type == .movie else { return }
        
        let people = TypedSearchResult()
        people.id = cast?.id
        people.name = cast?.name
        people.createPeople()
        
        let query = DiscoverQuery()
        query.addOrRemovePeople(people: people)
        query.type = .movie
        query.title = people.name
        
        if let router = router as? DetailPresenterToRouterProtocol {
            router.pushDiscoverResults(query: query, nav: nav)
        }
    }
    
    func didTapOnVideo(video: Video?, nav: UINavigationController) {
        
    }
    
    func didTapShare() {
        
    }
    
    func didTapOnSimilarContent(content: Content?, nav: UINavigationController?) {
        guard let id = content?.id, let nav = nav else { return }
        if let router = router as? DetailPresenterToRouterProtocol {
            router.pushDetail(for: id, type: type ?? .movie, navigationController: nav)
        }
    }
    
    func didTapWatchlist() -> Bool {
        guard let detail = detail, let id = detail.id, let type = type else {return false}
        if WatchlistManager.shared.isInWatchlist(id: id, type: type) {
            WatchlistManager.shared.removeFromWatchlist(id: id, type: type)
            return false
        } else {
            WatchlistManager.shared.addToWatchlist(content: detail, type: type)
            return true
        }
    }
    
    func getView() -> DetailPresenterToViewProtocol? {
        guard let view = self.view as? DetailPresenterToViewProtocol else {
            return nil
        }
        return view
    }
}
