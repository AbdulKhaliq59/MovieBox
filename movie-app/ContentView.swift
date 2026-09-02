//
//  ContentView.swift
//  movie-app
//
//  Created by khaliq on 02/09/2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "film.fill")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Movie App")
                .font(.title.bold())

            Label(
                AppConfiguration.isConfigured ? "TMDB API key configured" : "TMDB API key not set",
                systemImage: AppConfiguration.isConfigured ? "checkmark.circle.fill" : "exclamationmark.triangle.fill"
            )
            .foregroundStyle(AppConfiguration.isConfigured ? .green : .orange)
            .font(.subheadline)

            if !AppConfiguration.isConfigured {
                Text("Add your key to Core/Configuration/Secrets.swift")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
