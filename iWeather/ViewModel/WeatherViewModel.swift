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
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var forecast: [ForecastDay] = []

    private var cancellables = Set<AnyCancellable>()
    private let service = WeatherService()

    private let cityKey = "lastCity"
    private let weatherKey = "lastWeather"

    init() {
        loadCachedWeather()
    }

    func search() {
        guard !city.isEmpty else { return }

        isLoading = true
        errorMessage = nil

        Publishers.Zip(
            service.fetchWeather(for: city),
            service.fetchForecast(for: city)
        )
        .sink { [weak self] completion in
            guard let self = self else { return }
            self.isLoading = false

            if case let .failure(error) = completion {
                self.handle(error: error)
            }
        } receiveValue: { [weak self] (weather, forecast) in
            guard let self = self else { return }

            self.weather = weather
            self.forecast = forecast
            self.cacheWeather(weather, city: self.city)
        }
        .store(in: &cancellables)
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
