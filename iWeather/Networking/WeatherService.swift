//
//  WeatherService.swift
//  iWeather
//
//  Created by Bonmyeong Koo - Vendor on 5/29/25.
//

import Foundation
import Combine

class WeatherService {
    func fetchWeather(for city: String) -> AnyPublisher<WeatherResponse, Error> {
        let urlString = "\(Constants.baseURL)/current.json?key=\(Constants.apiKey)&q=\(city)"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func fetchForecast(for city: String) -> AnyPublisher<[ForecastDay], Error> {
        let urlString = "\(Constants.baseURL)/forecast.json?key=\(Constants.apiKey)&q=\(city)&days=7"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: ForecastResponse.self, decoder: JSONDecoder())
            .map { $0.forecast.forecastday }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
