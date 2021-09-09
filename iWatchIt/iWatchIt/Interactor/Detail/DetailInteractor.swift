//
//  DetailInteractor.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 02/04/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import FirebaseCrashlytics

class DetailInteractor: BaseInteractor, DetailPresenterToInteractorProtocol {
    
    init(presenter: DetailInteractorToPresenterProtocol) {
        super.init()
        self.presenter = presenter
    }
    
    func fetchDetail(type: MediaType, id: Int, language: String) {
        APIService.shared.detail(mediaType: type, id: id, language: Preference.getLocaleLanguage(), appendToResponse: String(format: "%@,%@,%@,%@", kGETDetailVideos, kGETDetailCredits, kGETDetailExternalIDs, kGETDetailSimilar)) { (result, error) in
            guard let presenter = self.getPresenter() else {
                return
            }
            
            guard let result = result else {
                presenter.detailFetchFailed(message: error?.localizedDescription)
                return
            }
            presenter.detailFetchSuccess(detail: result)
        }
    }
    
    func fetchPlatforms(id: String) {
        let keys = Preference.getUtellyKeys()

        let key = keys.randomElement()

        APIService.shared.getPlatforms(id: id, country: Preference.getCurrentCountry(), source: kIMDB, key: key) {
            [weak self] (result, error) in
            
            EventLogger.logEvent(UserEvents.utellyReq)
            
            guard let presenter = self?.getPresenter() else {
                return
            }
            
            guard let result = result else {
                Crashlytics.crashlytics().record(error: AppError.utellyRequestFailed)
                Crashlytics.crashlytics().log("Failing Utelly API key: \(String(describing: key))")
                presenter.platformsFetchFailed(message: error?.localizedDescription)
                return
            }
            presenter.platformsFetchSuccess(platforms: result)
        }
    }
    
    func saveRecentlySeen(id: Int?, title: String?, type: MediaType?) {
        RecentlySeenHelper.saveRecentlySeen(id: id, title: title, mediaType: type)
    }
    
    func getPresenter() -> DetailInteractorToPresenterProtocol? {
        guard let presenter = presenter as? DetailInteractorToPresenterProtocol else {
            return nil
        }
        return presenter
    }
}
