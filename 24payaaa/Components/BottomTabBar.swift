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
        .padding(.horizontal, 16)
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
            withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
                selectedTab = tab
            }
        } label: {
            VStack(spacing: 5) {
                Image(systemName: tab.icon)
                    .font(.system(size: 27, weight: .medium))
                    .frame(width: 34, height: 31)
                Text(tab.title)
                    .font(.system(size: 14, weight: .bold))
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
            withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
                selectedTab = .scan
            }
        } label: {
            VStack(spacing: 3) {
                Image(systemName: "viewfinder")
                    .font(.system(size: 30, weight: .bold))
                Text("Scanează")
                    .font(.system(size: 16, weight: .black))
            }
            .foregroundStyle(AppTheme.Color.background)
            .frame(width: 86, height: 86)
            .background(Circle().fill(AppTheme.Color.yellow))
            .offset(y: -20)
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
    }
}

