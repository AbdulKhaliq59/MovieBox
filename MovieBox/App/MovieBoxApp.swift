//
//  MovieBoxApp.swift
//  MovieBox
//
//  Created by khaliq on 02/09/2026.
//

import SwiftUI

@main
struct MovieBoxApp: App {
    private let container = AppContainer.shared

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.appContainer, container)
                .preferredColorScheme(container.themeManager.theme.colorScheme)
                .onOpenURL { url in
                    container.router.handle(url: url)
                }
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
