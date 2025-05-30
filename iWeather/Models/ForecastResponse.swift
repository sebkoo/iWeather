//
//  ForecastResponse.swift
//  iWeather
//
//  Created by Bonmyeong Koo - Vendor on 5/29/25.
//

import Foundation

struct ForecastResponse: Codable {
    let forecast: Forecast
}

struct Forecast: Codable {
    let forecastday: [ForecastDay]
}

struct ForecastDay: Codable, Identifiable {
    let date: String
    let day: ForecastDetails

    // For List use
    var id: String { date }
}

struct ForecastDetails: Codable {
    let maxtemp_c: Double
    let mintemp_c: Double
    let condition: Condition
}
