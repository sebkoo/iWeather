//
//  ContentView.swift
//  iWeather
//
//  Created by Bonmyeong Koo - Vendor on 5/29/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                searchField

                if viewModel.isLoading {
                    ProgressView("Loading weather...")
                        .padding()
                } else if let weather = viewModel.weather {
                    VStack(spacing: 8) {
                        Text("\(weather.location.name), \(weather.location.country)")
                            .font(.title2)
                        Text("\(weather.current.temp_c, specifier: "%.1f")°C")
                            .font(.largeTitle)
                        Text(weather.current.condition.text)
                    }
                    .padding()
                } else if let errorMessage = viewModel.errorMessage {
                    ErrorView(message: errorMessage) {
                        Task { await viewModel.search() }
                    }
                } else {
                    Text("Search for a city to get weather information.")
                        .foregroundColor(.secondary)
                        .padding()
                }

                if !viewModel.forecast.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(viewModel.forecast) { day in
                                ForecastRow(forecastDay: day)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                Spacer(minLength: 20)
            }
            .padding()
        }
        .refreshable {
            await viewModel.search(isManual: false)
        }
        .overlay(
            Group {
                if viewModel.isRefreshing {
                    RefreshIndicator()
                        .transition(.opacity)
                        .padding(.top, 60)
                }
            },
            alignment: .top
        )
    }

    private var searchField: some View {
        HStack {
            TextField("Enter city", text: $viewModel.city)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .submitLabel(.search)
                .onSubmit {
                    Task { await viewModel.search() }
                }

            Button {
                Task { await viewModel.search() }
            } label: {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.blue)
            }
        }
    }
}

#Preview {
    ContentView()
}
