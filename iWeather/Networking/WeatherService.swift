//
//  WeatherService.swift
//  iWeather
//
//  Created by Bonmyeong Koo - Vendor on 5/29/25.
//

import Foundation
import Combine

final class WeatherService {
    func fetchWeather(for city: String) async throws -> WeatherResponse {
        guard let url = URL(string: "\(Constants.baseURL)/current.json?key=\(Constants.apiKey)&q=\(city)&aqi=no") else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(WeatherResponse.self, from: data)
    }

    func fetchForecast(for city: String) async throws -> [ForecastDay] {
        guard let url = URL(string: "\(Constants.baseURL)/forecast.json?key=\(Constants.apiKey)&q=\(city)&days=7&aqi=no&alerts=no") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(ForecastResponse.self, from: data)
        return response.forecast.forecastday
    }
}
