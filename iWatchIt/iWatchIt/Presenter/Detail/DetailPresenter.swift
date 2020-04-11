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
        
        if let title = self.detail?.title {
            interactor.fetchPlatforms(term: title)
        } else if let name = self.detail?.name {
            interactor.fetchPlatforms(term: name)
        }
    }
    
    func detailFetchFailed(message: String?) {
        view?.showError(message: message)
    }
    
    func platformsFetchSuccess(platforms: RootPlatform?) {
        debugPrint("Querying for id")
        if let locations = PlatformHelper.filteredLocations(of: platforms, and: detail?.id) {
            self.platforms = locations
        }

        if let view = getView() {
            view.onPlatformsFetched()
        }
    }
    
    func platformsFetchFailed(message: String?) {
        view?.showError(message: message )
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
        interactor.fetchDetail(type: type, id: id, language: "en")
    }
    
    func startFetchingPlatform(term: String) {
        guard let interactor = interactor as? DetailPresenterToInteractorProtocol else {
            return
        }
        interactor.fetchPlatforms(term: term)
    }
    
    func didTapOnPlatform(platform: Platform?) {
        PlatformHelper.goToPlatform(platform: platform)
    }
    
    func didTapOnCast(cast: Cast?) {
        
    }
    
    func didTapOnVideo(video: Video?, nav: UINavigationController) {
//        VideoHelper.goToVideo(video: video, withNav: nav)
    }
    
    func didTapShare() {
        
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
