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
        VStack {
            TextField("Enter city", text: $viewModel.city)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Search", action: viewModel.search)
                .padding()

            if viewModel.isLoading {
                ProgressView()
            } else if let weather = viewModel.weather {
                VStack(spacing: 8) {
                    Text("\(weather.location.name), \(weather.location.country)")
                        .font(.title2)
                    Text("\(weather.current.temp_c, specifier: "%.1f")°C")
                        .font(.largeTitle)
                    Text(weather.current.condition.text)
                }
                .padding()
            } else if let error = viewModel.errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
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
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
