//
//  NetworkService.swift
//  iWeather
//
//  Created by Bonmyeong Koo - Vendor on 5/30/25.
//

import Foundation

enum NetworkError: Error {
    case notFound
    case serverError
    case badURL
    case decodingError
    case unknownError(statusCode: Int)
    case custom(message: String)

    var description: String? {
        switch self {
        case .notFound:
            return "City not found (404). Please check the spelling or try a different location."
        case .serverError:
            return "Server is unavailable (500). Please try again later."
        case .badURL:
            return "Invalid URL. Please contact support."
        case .decodingError:
            return "Failed to decode response."
        case .unknownError(let statusCode):
            return "Unexpected error (\(statusCode))."
        case .custom(let message):
            return message
        }
    }
}
