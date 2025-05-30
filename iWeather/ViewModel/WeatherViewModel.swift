//
//  WeatherViewModel.swift
//  iWeather
//
//  Created by Bonmyeong Koo - Vendor on 5/29/25.
//

import Foundation
import Combine

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var city: String = ""
    @Published var weather: WeatherResponse?
    @Published var errorMessage: String? = nil
    @Published var forecast: [ForecastDay] = []
    @Published var isLoading: Bool = false
    @Published var isRefreshing: Bool = false

    private let service = WeatherService()
    private let cityKey = "lastCity"
    private let weatherKey = "lastWeather"

    init() {
        loadCachedWeather()
    }

    func search(isManual: Bool = true) async {
        guard !city.isEmpty else { return }

        if isManual {
            isLoading = true
        } else {
            isRefreshing = true
        }

        errorMessage = nil

        do {
            async let weather = service.fetchWeather(for: city)
            async let forecast = service.fetchForecast(for: city)

            let (weatherResult, forecastResult) = try await (weather, forecast)

            self.weather = weatherResult
            self.forecast = forecastResult
            self.cacheWeather(weatherResult, city: city)
        } catch {
            handle(error: error)
        }

        isLoading = false
        isRefreshing = false
    }

    private func handle(error: Error) {
        if let networkError = error as? NetworkError {
            self.errorMessage = networkError.localizedDescription
        } else if let urlError = error as? URLError {
            self.errorMessage = "Network error: \(urlError.localizedDescription)"
        } else {
            self.errorMessage = "Unexpected error: \(error.localizedDescription)"
        }
    }

    private func cacheWeather(_ weather: WeatherResponse, city: String) {
        let encoder = JSONEncoder()
        if let encodedWeather = try? encoder.encode(weather) {
            UserDefaults.standard.setValue(city, forKey: cityKey)
            UserDefaults.standard.setValue(encodedWeather, forKey: weatherKey)
        }
    }

    private func loadCachedWeather() {
        if let savedCity = UserDefaults.standard.string(forKey: cityKey),
           let savedData = UserDefaults.standard.data(forKey: weatherKey),
           let decodedWeather = try? JSONDecoder().decode(WeatherResponse.self, from: savedData) {
            self.city = savedCity
            self.weather = decodedWeather
        }
    }
}
