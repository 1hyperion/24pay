import SwiftUI

struct ServicesView: View {
    @EnvironmentObject private var store: LocalStore
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 22), count: 3)

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                AppHeader()
                    .padding(.top, 31)

                serviceSection(.transport)
                serviceSection(.payments)
                serviceSection(.prepay)
                serviceSection(.auto)
            }
            .padding(.horizontal, 22)
            .padding(.top, -1)
        }
    }

    private func serviceSection(_ category: ServiceCategory) -> some View {
        VStack(alignment: .leading, spacing: 19) {
            Text(category.rawValue)
                .font(AppTheme.Font.title)
                .foregroundStyle(.white)
                .padding(.leading, 22)

            LazyVGrid(columns: columns, spacing: 22) {
                ForEach(store.services.filter { $0.category == category }) { service in
                    if service.title.contains("Transport") && service.isEnabled {
                        NavigationLink {
                            TicketCatalogView()
                        } label: {
                            ServiceCard(service: service)
                        }
                        .buttonStyle(.plain)
                    } else {
                        ServiceCard(service: service)
                    }
                }
            }
        }
    }
}

