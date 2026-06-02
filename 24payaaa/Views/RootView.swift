import SwiftUI

struct RootView: View {
    @StateObject private var viewModel = AppViewModel()

    var body: some View {
        Group {
            if viewModel.isAuthenticated {
                MainTabView()
                    .environmentObject(viewModel)
                    .environmentObject(viewModel.store)
            } else {
                AuthenticationView()
                    .environmentObject(viewModel)
            }
        }
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
