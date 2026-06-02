import SwiftUI

struct BottomTabBar: View {
    @Binding var selectedTab: AppTab

    var body: some View {
        HStack(alignment: .bottom) {
            tab(.home)
            tab(.services)
            scanTab
            tab(.transactions)
            tab(.wallet)
        }
        .padding(.horizontal, 14)
        .padding(.top, 10)
        .frame(height: AppTheme.Layout.tabBarHeight)
        .frame(maxWidth: .infinity)
        .background(AppTheme.Color.background.opacity(0.98))
        .overlay(alignment: .top) {
            Rectangle()
                .fill(.black.opacity(0.18))
                .frame(height: 1)
        }
    }

    private func tab(_ tab: AppTab) -> some View {
        Button {
            selectedTab = tab
        } label: {
            VStack(spacing: 5) {
                Image(systemName: tab.icon)
                    .font(.system(size: 25, weight: .medium))
                    .frame(width: 32, height: 29)
                Text(tab.title)
                    .font(.system(size: 13.5, weight: .bold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.82)
            }
            .foregroundStyle(selectedTab == tab ? AppTheme.Color.yellow : .white.opacity(0.48))
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private var scanTab: some View {
        Button {
            selectedTab = .scan
        } label: {
            VStack(spacing: 3) {
                Image(systemName: "viewfinder")
                    .font(.system(size: 28, weight: .bold))
                Text("Scaneaz\u{0103}")
                    .font(.system(size: 15.5, weight: .black))
            }
            .foregroundStyle(AppTheme.Color.background)
            .frame(width: 82, height: 82)
            .background(Circle().fill(AppTheme.Color.yellow))
            .offset(y: -18)
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
    }
}

