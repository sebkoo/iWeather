//
//  ForecastRow.swift
//  iWeather
//
//  Created by Bonmyeong Koo - Vendor on 5/29/25.
//

import SwiftUI

struct ForecastRow: View {
    let forecastDay: ForecastDay

    var body: some View {
        VStack(spacing: 8) {
            Text(formattedDay(from: forecastDay.date))
                .font(.caption)
            AsyncImage(url: URL(string: "https:\(forecastDay.day.condition.icon)")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 40, height: 40)
            Text("\(Int(forecastDay.day.maxtemp_c))° / \(Int(forecastDay.day.mintemp_c))°")
                .font(.footnote)
        }
    }

    func formattedDay(from dateString: String) -> String {
        let input = DateFormatter()
        input.dateFormat = "yyyy-MM-dd"
        if let date = input.date(from: dateString) {
            let output = DateFormatter()
            output.dateFormat = "E"
            return output.string(from: date)
        }
        return ""
    }
}

#Preview {
    ForecastRow(forecastDay: ForecastDay(
        date: "2025-06-01",
        day: ForecastDetails(
            maxtemp_c: 28.4,
            mintemp_c: 18.9,
            condition: Condition(
                text: "Partly cloudy",
                icon: "//cdn.weatherapi.com/weather/64x64/day/116.png"
            )
        )
    ))
}
