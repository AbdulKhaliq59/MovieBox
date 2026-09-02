//
//  movie_appApp.swift
//  movie-app
//
//  Created by khaliq on 02/09/2026.
//

import SwiftUI

@main
struct movie_appApp: App {
    private let container = AppContainer.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.appContainer, container)
        }
    }
}

private struct AppContainerKey: EnvironmentKey {
    static let defaultValue = AppContainer.shared
}

extension EnvironmentValues {
    var appContainer: AppContainer {
        get { self[AppContainerKey.self] }
        set { self[AppContainerKey.self] = newValue }
    }
}
