//
//  API.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 25/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

// MARK: API Constants

// MARK: The movie DB
let kTMDBBaseURL = "https://api.themoviedb.org/"
let kTMDBAPIVersion = "3"
let kTMDBAPIKey = "dc178d675fbe6650c6ddb7f638f3bb99"
let kUtellyBaseURL = "https://utelly-tv-shows-and-movies-availability-v1.p.rapidapi.com/"
let kUtellyHost = "utelly-tv-shows-and-movies-availability-v1.p.rapidapi.com"
let kUtellyAPIKey = "612d81ad38msh5a3671974754d62p1d34dejsnfc08e58195b9"

/// Enpoints
let kGETConfiguration = "/configuration"
let kGETTrending = "/trending/%@/%@"
let kGETDiscover = "/discover/%@"
let kGETSearch = "/search/%@"
let kGETDetail = "/%@/%d"
let kGETDetailVideos = "videos"
let kGETDetailImages = "images"
let kGETDetailCredits = "credits"
let kGETDetailExternalIDs = "external_ids"
let kGETLookup = "idlookup"
let kGETGenres = "/genre/%@/list"
let kGETSearchKeywords = "/search/keyword"
let kGETSearchPeople = "/search/person"


/// Param keys
let kApiKey = "api_key"
let kLanguage = "language"
let kWithGenres = "with_genres"
let kWithPeople = "with_people"
let kWithKeywords = "with_keywords"
let kPage = "page"
let kQuery = "query"
let kAppendToResponse = "append_to_response"
let kCountry = "country"
let kSourceId = "source_id"
let kSource = "source"
let kTerm = "term"
let kHeaderRapidAPIHost = "x-rapidapi-host"
let kHeaderRapidAPIKey = "x-rapidapi-key"

/// Config
let kIMDB = "imdb"






