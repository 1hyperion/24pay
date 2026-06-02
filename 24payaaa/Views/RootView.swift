import SwiftUI

struct RootView: View {
    @StateObject private var viewModel = AppViewModel()

    var body: some View {
        Group {
            if viewModel.isAuthenticated {
                MainTabView()
                    .environmentObject(viewModel)
                    .environmentObject(viewModel.store)
                    .transition(.opacity.combined(with: .scale(scale: 1.04)))
            } else {
                AuthenticationView()
                    .environmentObject(viewModel)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.45), value: viewModel.isAuthenticated)
    }
}

struct MainTabView: View {
    @EnvironmentObject private var viewModel: AppViewModel
    @EnvironmentObject private var store: LocalStore

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Group {
                    switch viewModel.selectedTab {
                    case .home:
                        HomeView()
                    case .services:
                        ServicesView()
                    case .scan:
                        ScanView()
                    case .transactions:
                        TransactionsView()
                    case .wallet:
                        WalletView()
                    }
                }
                .environmentObject(viewModel)
                .environmentObject(store)
                .safeAreaPadding(.bottom, AppTheme.Layout.tabBarHeight - 8)

                BottomTabBar(selectedTab: $viewModel.selectedTab)
            }
            .appBackground()
            .navigationDestination(item: $viewModel.selectedTicket) { ticket in
                TicketQRView(ticket: ticket)
            }
        }
    }
}

#Preview {
    RootView()
}
