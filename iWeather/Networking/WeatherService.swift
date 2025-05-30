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
        return request(urlString: urlString)
//        guard let url = URL(string: urlString) else {
//            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
//        }
//
//        return URLSession.shared.dataTaskPublisher(for: url)
//            .map(\.data)
//            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
//            .receive(on: DispatchQueue.main)
//            .eraseToAnyPublisher()
    }

    func fetchForecast(for city: String) -> AnyPublisher<[ForecastDay], Error> {
        let urlString = "\(Constants.baseURL)/forecast.json?key=\(Constants.apiKey)&q=\(city)&days=7"
        return request(urlString: urlString, keyPath: \ForecastResponse.forecast.forecastday)
//        guard let url = URL(string: urlString) else {
//            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
//        }
//
//        return URLSession.shared.dataTaskPublisher(for: url)
//            .map(\.data)
//            .decode(type: ForecastResponse.self, decoder: JSONDecoder())
//            .map { $0.forecast.forecastday }
//            .receive(on: DispatchQueue.main)
//            .eraseToAnyPublisher()
    }

    // Generic request function
    private func request<T: Decodable>(urlString: String) -> AnyPublisher<T, Error> {
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    // Overload for nested key path decoding
    private func request<T: Decodable, R: Decodable>(
        urlString: String,
        keyPath: KeyPath<R, T>
    ) -> AnyPublisher<T, Error> {
        request(urlString: urlString)
            .map { (response: R) in response[keyPath: keyPath] }
            .eraseToAnyPublisher()
    }
}
