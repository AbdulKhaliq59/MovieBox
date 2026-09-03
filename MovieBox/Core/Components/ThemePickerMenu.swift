import SwiftUI

struct ThemePickerMenu: View {
    let themeManager: ThemeManager

    var body: some View {
        Menu {
            Picker("Appearance", selection: Binding(
                get: { themeManager.theme },
                set: { themeManager.theme = $0 }
            )) {
                ForEach(AppTheme.allCases) { theme in
                    Label(theme.label, systemImage: theme.icon).tag(theme)
                }
            }
        } label: {
            Image(systemName: themeManager.theme.icon)
        }
        .accessibilityLabel("Appearance")
    }
}
