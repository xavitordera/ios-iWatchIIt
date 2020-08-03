//
//  BaseVC.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 22/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//
import UIKit
import GoogleMobileAds

class BaseVC: UIViewController, BasePresenterToViewProtocol {
    var presenter: BaseViewToPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNotifications()
    }
    
    func addNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func showError(message: String?) {
        let alert = AlertHelper.simpleAlertWith(title: "app_error_title".localized, message: message, action: "dismiss_pop_up".localized)
        present(alert, animated: true, completion: nil)
    }
    
    func setNavigationBarHidden(isHidden: Bool) {
        self.navigationController?.isNavigationBarHidden = isHidden
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            UserDefaults.standard.set(keyboardRectangle.height, forKey: "keyboardHeight")
        }
    }
    
    func getPresenter<T>(type: T.Type) -> T? {
        guard let presenter = self.presenter as? T else { return nil }
        return presenter
    }
    
    func viewForBanner(size: CGSize? = nil) -> GADBannerView {
        var banner: GADBannerView!
        
        if let size = size {
            banner = GADBannerView(adSize: GADAdSizeFromCGSize(size))
        } else {
            banner = GADBannerView(adSize: kGADAdSizeBanner)
        }
        
        banner.adSizeDelegate = self
        banner.rootViewController = self
        #if DEBUG
        banner.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        #else
        banner.adUnitID = kAdMobID
        #endif
        banner.delegate = self
        
        banner.backgroundColor = UIColor.blackOrWhite
        banner.load(GADRequest())
        
        return banner
    }
}

// MARK: - ADMob Delegate
extension BaseVC: GADAdSizeDelegate, GADAdLoaderDelegate, GADBannerViewDelegate {
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        debugPrint(error)
    }
    
    func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
        debugPrint(adLoader)
    }
    
    func adView(_ bannerView: GADBannerView, willChangeAdSizeTo size: GADAdSize) {
        
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 0
        UIView.animate(withDuration: 0.75, animations: {
            bannerView.alpha = 1
        })
    }
}
