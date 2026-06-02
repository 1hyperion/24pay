import SwiftUI

enum AppTheme {
    enum Color {
        static let background = SwiftUI.Color(red: 20 / 255, green: 26 / 255, blue: 33 / 255)
        static let surface = SwiftUI.Color(red: 35 / 255, green: 43 / 255, blue: 54 / 255)
        static let surfaceDim = SwiftUI.Color(red: 22 / 255, green: 29 / 255, blue: 37 / 255)
        static let surfaceSoft = SwiftUI.Color(red: 229 / 255, green: 232 / 255, blue: 236 / 255)
        static let yellow = SwiftUI.Color(red: 244 / 255, green: 221 / 255, blue: 39 / 255)
        static let yellowSoft = SwiftUI.Color(red: 234 / 255, green: 221 / 255, blue: 76 / 255)
        static let text = SwiftUI.Color.white
        static let muted = SwiftUI.Color(red: 144 / 255, green: 157 / 255, blue: 174 / 255)
        static let muted2 = SwiftUI.Color(red: 132 / 255, green: 139 / 255, blue: 149 / 255)
        static let border = SwiftUI.Color.white.opacity(0.28)
        static let danger = SwiftUI.Color(red: 1.0, green: 62 / 255, blue: 67 / 255)
        static let lavender = SwiftUI.Color(red: 207 / 255, green: 202 / 255, blue: 252 / 255)
    }

    enum Font {
        static let hero = SwiftUI.Font.system(size: 34, weight: .bold, design: .default)
        static let title = SwiftUI.Font.system(size: 31, weight: .regular, design: .default)
        static let large = SwiftUI.Font.system(size: 26, weight: .regular, design: .default)
        static let cardTitle = SwiftUI.Font.system(size: 24, weight: .regular, design: .default)
        static let body = SwiftUI.Font.system(size: 20, weight: .regular, design: .default)
        static let bodyBold = SwiftUI.Font.system(size: 20, weight: .bold, design: .default)
        static let caption = SwiftUI.Font.system(size: 15, weight: .semibold, design: .default)
    }

    enum Layout {
        static let horizontal: CGFloat = 22
        static let tabBarHeight: CGFloat = 116
        static let corner: CGFloat = 16
        static let cardCorner: CGFloat = 28
    }
}

extension View {
    func appBackground() -> some View {
        frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppTheme.Color.background.ignoresSafeArea())
            .preferredColorScheme(.dark)
    }
}

