import Foundation


@Observable
@MainActor
final class ThemeManager {
    private static let storageKey = "appTheme"

    var theme: AppTheme {
        didSet {
            UserDefaults.standard.set(theme.rawValue, forKey: Self.storageKey)
        }
    }

    init() {
        let stored = UserDefaults.standard.string(forKey: Self.storageKey)
        theme = stored.flatMap(AppTheme.init(rawValue:)) ?? .system
    }
}
