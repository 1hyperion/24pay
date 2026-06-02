import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var store: LocalStore
    @EnvironmentObject private var viewModel: AppViewModel

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 22), count: 3)

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 27) {
                AppHeader()
                    .padding(.top, 31)

                Text("Favorite")
                    .font(AppTheme.Font.title)
                    .foregroundStyle(.white)
                    .padding(.leading, 11)

                if let product = store.products.first(where: \.isFavorite) {
                    NavigationLink {
                        PaymentSummaryView(product: product)
                    } label: {
                        FavoriteTicketCard(product: product)
                    }
                    .buttonStyle(.plain)
                    .padding(.leading, 11)
                }

                SectionTitleRow(title: "Servicii", action: "Vezi toate serviciile")
                    .padding(.horizontal, 11)
                    .padding(.top, 10)
                    .onTapGesture {
                        viewModel.selectedTab = .services
                    }

                LazyVGrid(columns: columns, spacing: 22) {
                    ForEach(store.services.prefix(8)) { service in
                        serviceLink(service)
                    }
                }
                .padding(.horizontal, 11)

                Text("Parteneri")
                    .font(AppTheme.Font.title)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 11)
                    .padding(.top, 12)

                PartnerBanner()
                    .padding(.horizontal, 11)
            }
            .padding(.horizontal, 11)
        }
    }

    @ViewBuilder
    private func serviceLink(_ service: PayService) -> some View {
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

struct PartnerBanner: View {
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(red: 238 / 255, green: 242 / 255, blue: 249 / 255))

            WaveLines()
                .stroke(Color.cyan.opacity(0.18), lineWidth: 1)
                .frame(height: 120)
                .offset(x: 80, y: -15)

            VStack(alignment: .leading, spacing: 18) {
                BrandLogo(payColor: AppTheme.Color.surface)
                    .scaleEffect(0.75, anchor: .leading)
                    .padding(.leading, 23)

                Text("Și tu poți câștiga!")
                    .font(.system(size: 28, weight: .black))
                    .foregroundStyle(.white)
                    .padding(.vertical, 15)
                    .padding(.horizontal, 26)
                    .background(AppTheme.Color.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))

                Text("Detalii pe 24pay.ro\nla secțiunea Media")
                    .font(.system(size: 15, weight: .black))
                    .foregroundStyle(AppTheme.Color.surface)
                    .padding(.leading, 23)
            }

            HStack(spacing: -18) {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.black.opacity(0.82))
                    .frame(width: 92, height: 86)
                    .overlay(alignment: .topLeading) {
                        Circle().fill(.black).frame(width: 15, height: 15).padding(10)
                    }
                RoundedRectangle(cornerRadius: 7)
                    .fill(LinearGradient(colors: [.yellow, .green, .cyan, .yellow], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 113, height: 62)
                    .overlay(RoundedRectangle(cornerRadius: 7).stroke(.black, lineWidth: 3))
            }
            .offset(x: 263, y: 18)
        }
        .frame(height: 191)
        .clipped()
    }
}

struct WaveLines: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        for index in 0..<18 {
            let y = CGFloat(index) * 8
            path.move(to: CGPoint(x: 0, y: y))
            path.addCurve(to: CGPoint(x: rect.width, y: y + 30), control1: CGPoint(x: rect.width * 0.3, y: y - 36), control2: CGPoint(x: rect.width * 0.68, y: y + 50))
        }
        return path
    }
}
