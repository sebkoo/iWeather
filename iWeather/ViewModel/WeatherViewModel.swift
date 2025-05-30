//
//  WeatherViewModel.swift
//  iWeather
//
//  Created by Bonmyeong Koo - Vendor on 5/29/25.
//

import Foundation
import Combine

class WeatherViewModel: ObservableObject {
    @Published var city: String = ""
    @Published var weather: WeatherResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?

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

        service.fetchWeather(for: city)
            .sink { completion in
                self.isLoading = false
                if case let .failure(error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { response in
                self.weather = response
                self.cacheWeather(response, city: self.city)
            }
            .store(in: &cancellables)
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
