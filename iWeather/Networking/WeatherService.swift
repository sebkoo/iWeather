//
//  WeatherService.swift
//  iWeather
//
//  Created by Bonmyeong Koo - Vendor on 5/29/25.
//

import Foundation
import Combine

protocol WeatherServiceProtocol {
    func fetchWeather(for city: String) -> AnyPublisher<WeatherResponse, Error>
}

final class WeatherService: WeatherServiceProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

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
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }

                switch httpResponse.statusCode {
                case 200:
                    return data
                case 404:
                    throw NetworkError.notFound
                case 500...599:
                    throw NetworkError.serverError
                default:
                    throw NetworkError.unknownError(statusCode: httpResponse.statusCode)
                }
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if error is DecodingError {
                    return NetworkError.decodingError
                }
                return error
            }
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
