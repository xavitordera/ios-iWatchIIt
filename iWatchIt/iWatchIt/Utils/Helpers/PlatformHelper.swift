//
//  PlatformHelper.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 05/04/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import Foundation
import UIKit

let kDeepURLAmazon = "aiv://aiv/play?asin=%@"

enum PlatformSite: String, CaseIterable {
    case Netflix = "Netflix"
    case AmazonPrimeVideo = "Amazon Prime Video"
    case AmazonInstantVideo = "Amazon Instant Video"
    case AppleTV = "Apple TV+"
    case iTunes = "iTunes"
    case YouTubePremium = "YouTube Premium"
    case DisneyPlus = "Disney Plus"
    case Hulu = "Hulu"
    case AtomTickets = "Atom Tickets"
    case CBS = "CBS"
    case DCUniverse = "DC Universe"
    case HBO = "HBO"
    case DiscoveryChannel = "Discovery Channel"
    case FandangoMovies = "Fandango Movies"
    case Fox = "Fox"
    case NBC = "NBC"
    case Nickelodeon = "Nickelodeon"
    case Syfy = "Syfy"
    case HBOMax = "HBO Max"
    case Peacock = "Peacock"
}

enum PlatformScheme: String, CaseIterable {
    case Netflix = "nflx"
    case AmazonPrimeVideo = "aiv"
    case AppleTV = "videos"
    case iTunes = "itms"
    case HBO = "hbogo"
    case Hulu = "hulu"
}

class PlatformHelper {
    
    static let excludedPlatformWords = ["Google"]
    
    class func getImageForSite(platform: Platform?) -> UIImage? {
        guard let platform = platform, let site = getSiteForPlatform(platform: platform) else { return nil }
        
        switch site {
        case .Netflix:
            return kNetflix
        case .AmazonPrimeVideo:
            return kAmazonPrimeVideo
        case .AmazonInstantVideo:
            return kAmazonInstantVideo
        case .AppleTV:
            return kAppleTV
        case .iTunes:
            return kiTunes
        case .YouTubePremium:
            return kYouTubePremium
        case .DisneyPlus:
            return kDisneyPlus
        case .Hulu:
            return kHulu
        case .AtomTickets:
            return kAtomTickets
        case .CBS:
            return kCBS
        case .DCUniverse:
            return kDCUniverse
        case .HBO:
            return kHBO
        case .DiscoveryChannel:
            return kDiscoveryChannel
        case .FandangoMovies:
            return kFandangoMovies
        case .Fox:
            return kFox
        case .NBC:
            return kNBC
        case .Nickelodeon:
            return kNickelodeon
        case .Syfy:
            return kSyfy
        case .HBOMax:
            return kHBOMax
        case .Peacock:
            return kPeacock
        }
    }
    
    /// Nope, we filter some locations because we don't want to...you know...display anything wierd or offensive to our beloved users
    class func filteredLocations(of platform: RootPlatform?) -> [Platform]? {
        guard var locations = platform?.collection?.locations else {
            return nil
        }
        var i = 0
        for location in locations {
            if let name = location.displayName {
                if checkIfHasExcludedWords(term: name) {
                    locations.remove(at: i)
                }
            }
            i += 1
        }
        
        return locations
    }
    
    /// check if any string contains excluded words
    /// return: true if constains excluded words false if not
    private class func checkIfHasExcludedWords(term: String) -> Bool {
        for word in excludedPlatformWords {
            if term.contains(word) {
                return true
            }
        }
        
        return false
    }
    
    class func goToPlatform(platform: Platform?) {
        guard let platform = platform, let platformUrl = platform .url else {
            return
        }
        
        if let site = getSiteForPlatform(platform: platform) {
            let (originalURLString, schemeURLString) = buildCustomURL(for: site, with: platformUrl)
            if let originalURL = URL(string: originalURLString), let schemeurl = schemeURLString,
                let customURL = URL(string: schemeurl) {
                let urlToOpen = UIApplication.shared.canOpenURL(customURL) ? customURL : originalURL
                UIApplication.shared.open(urlToOpen, options: [:], completionHandler: nil)
            } else {
                if let url = URL(string: platformUrl) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        } else {
            if let url = URL(string: platformUrl) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    /// Returns the original url and the custom url for each site
    private class func buildCustomURL(for site: PlatformSite, with url: String?) ->  (String, String?) {
        guard let url = url else {return ("","")}
        
        switch site {
        case .Netflix:
            return (url, buildSchemeURL(for: url, withScheme: .Netflix))
        case .AmazonPrimeVideo, .AmazonInstantVideo:
            return (url, buildSchemeURL(for: url, withScheme: .AmazonPrimeVideo))
        case .AppleTV:
            return (url, buildSchemeURL(for: url, withScheme: .AppleTV))
        case .Hulu:
            return (url, buildSchemeURL(for: url, withScheme: .Hulu))
        case .iTunes:
            return (url, buildSchemeURL(for: url, withScheme: .iTunes))
        case .HBO:
            return (url, buildSchemeURL(for: url, withScheme: .HBO))
        default:
            return (url, "")
        }
        
    }
    
    // FIXME: ASAP
    /// "Analyses" the incoming url and determines from with platform is
    private class func getSiteForPlatform(platform: Platform) -> PlatformSite? {
        guard let platformURL = platform.url else {
            return nil
        }
        
        if platformURL.contains("netflix") {
            return .Netflix
        }
        
        if platformURL.contains("amazon") || platformURL.contains("primevideo") {
            return .AmazonPrimeVideo
        }
        
        if platformURL.contains("tv.apple") {
            return .AppleTV
        }
        
        if platformURL.contains("itunes") {
            return .iTunes
        }
        
        if platformURL.contains("youtube") {
            return .YouTubePremium
        }
        
        if platformURL.contains("disney") {
            return .DisneyPlus
        }
        
        if platformURL.contains("hulu") {
            return .Hulu
        }
        
        if platformURL.contains("atom") {
            return .AtomTickets
        }
        
        if platformURL.contains("cbs") {
            return .CBS
        }
        
        if platformURL.contains("dcuniverse") {
            return .DCUniverse
        }
        
        if platformURL.contains("hbomax") {
            return .HBOMax
        }
        
        if platformURL.contains("hbo") {
            return .HBO
        }
        
        if platformURL.contains("discovery") {
            return .DiscoveryChannel
        }
        
        if platformURL.contains("fandango") {
            return .FandangoMovies
        }
        
        if platformURL.contains("fox") {
            return .Fox
        }
        
        if platformURL.contains("nbc") {
            return .NBC
        }
        
        if platformURL.contains("nickelodeon") {
            return .Nickelodeon
        }
        
        if platformURL.contains("syfy") {
            return .Syfy
        }
        
        if platformURL.contains("peacock") {
            return .Peacock
        }
        
        return nil
    }
    
    private class func buildSchemeURL(for url: String, withScheme: PlatformScheme) -> String? {
        
        switch withScheme {
        case .AmazonPrimeVideo:
            return buildAmazonPrimeURL(for: url)
        default:
            return url.replacingOccurrences(of: "https", with: withScheme.rawValue)
        }
    }
    
    private class func buildAmazonPrimeURL(for url: String) -> String? {
        guard let amazonURL = URLComponents(string: url), let queryItems = amazonURL.queryItems else {return nil}
        if let asin = queryItems.first(where: { $0.name == "creativeASIN" })?.value {
            return String(format: kDeepURLAmazon, asin)
        } else {
            return nil
        }
    }
    
    class func initializeUtellyKeys() {
        FirebaseDatabaseProvider.shared.fetchObject(name: DatabaseFields.utellyKeys) { (param: [String]?) in
            if let param = param {
                Preference.setUtellyKeys(keys: param)
            }
        }
    }
}
