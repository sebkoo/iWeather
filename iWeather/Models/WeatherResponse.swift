//
//  WeatherResponse.swift
//  iWeather
//
//  Created by Bonmyeong Koo - Vendor on 5/29/25.
//

import Foundation

struct WeatherResponse: Codable {
    let location: Location
    let current: Current

}

struct Location: Codable {
    let name: String
    let region: String
}

struct Current: Codable {
    let temp_c: Double
    let condition: Condition
}

struct Condition: Codable {
    let text: String
    let icon: String
}
