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
            }
            .store(in: &cancellables)
    }
}
