//
//  ErrorView.swift
//  iWeather
//
//  Created by Bonmyeong Koo - Vendor on 5/30/25.
//

import SwiftUI

struct ErrorView: View {
    let message: String
    let retryAction: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(.yellow)
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundColor(.red)
                .padding(.horizontal)
            Button("Retry", action: retryAction)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
        }
        .padding()
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    ErrorView(
        message: "City not found (404). Please check the spelling or try another location.",
        retryAction: { print("Retry tapped") }
    )
    .padding()
    .background(Color(.systemBackground))
}
