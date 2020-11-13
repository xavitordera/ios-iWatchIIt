//
//  AppError.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 25/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import Foundation

enum AppError: Error {
    case message(String)
    case generic
    case malformedData
    case utellyRequestFailed
    
    public var errorDescription: String? {
        switch self {
        case .message(let message): return message
        case .generic: return "app_error_generic".localized
        default: return ""
        }
    }
}
