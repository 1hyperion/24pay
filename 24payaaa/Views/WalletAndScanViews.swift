import SwiftUI

struct WalletView: View {
    @EnvironmentObject private var store: LocalStore

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                Text("Portofel")
                    .font(AppTheme.Font.hero)
                    .foregroundStyle(.white)
                    .padding(.top, 76)
                    .padding(.leading, 31)

                VStack(alignment: .leading, spacing: 18) {
                    Text("Carduri")
                        .font(AppTheme.Font.large)

                    ForEach(store.cards) { card in
                        HStack {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.cyan)
                                .frame(width: 84, height: 51)
                                .overlay(alignment: .bottomTrailing) {
                                    Text("VISA")
                                        .font(.system(size: 9, weight: .black))
                                        .padding(6)
                                }

                            VStack(alignment: .leading, spacing: 7) {
                                Text(card.brand)
                                    .font(.system(size: 20.5))
                                Text("**** **** ******\(card.last4)")
                                    .font(.system(size: 16.5))
                                    .foregroundStyle(AppTheme.Color.muted)
                            }
                            Spacer()
                        }
                        .padding(22)
                        .background(AppTheme.Color.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 22)

                VStack(alignment: .leading, spacing: 18) {
                    Text("Bilete active")
                        .font(AppTheme.Font.large)
                        .foregroundStyle(.white)

                    if store.tickets.isEmpty {
                        Text("Nu ai bilete active.")
                            .font(AppTheme.Font.body)
                            .foregroundStyle(AppTheme.Color.muted)
                            .padding(22)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(AppTheme.Color.surface)
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    } else {
                        ForEach(store.tickets) { ticket in
                            NavigationLink {
                                TicketQRView(ticket: ticket)
                            } label: {
                                HStack {
                                    Image(systemName: "qrcode")
                                        .font(.system(size: 36))
                                    VStack(alignment: .leading, spacing: 7) {
                                        Text(ticket.product.city)
                                            .font(.system(size: 22.5))
                                        Text(ticket.product.title)
                                            .font(.system(size: 16.5))
                                            .foregroundStyle(AppTheme.Color.muted)
                                    }
                                    Spacer()
                                    Text("x\(ticket.quantity)")
                                        .font(.system(size: 20, weight: .bold))
                                }
                                .foregroundStyle(.white)
                                .padding(22)
                                .background(AppTheme.Color.surface)
                                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, 22)
            }
        }
    }
}

struct ScanView: View {
    var body: some View {
        VStack(spacing: 22) {
            Text("Scaneaz\u{0103}")
                .font(AppTheme.Font.hero)
                .foregroundStyle(.white)
                .padding(.top, 76)

            ZStack {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(AppTheme.Color.yellow, lineWidth: 3)
                    .frame(width: 250, height: 250)

                Image(systemName: "viewfinder")
                    .font(.system(size: 116, weight: .light))
                    .foregroundStyle(AppTheme.Color.yellow)
            }
            .padding(.top, 40)

            Text("Apropie codul QR de zona de scanare")
                .font(AppTheme.Font.body)
                .foregroundStyle(AppTheme.Color.muted)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 42)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

