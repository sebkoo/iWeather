//
//  CustomRefreshIndicator.swift
//  iWeather
//
//  Created by Bonmyeong Koo - Vendor on 5/30/25.
//

import SwiftUI

struct RefreshIndicator: View {
    var body: some View {
        HStack(spacing: 8) {
            ProgressView()
            Text("Refreshing weather...")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(radius: 4)
        )
    }
}

#Preview {
    RefreshIndicator()
}
