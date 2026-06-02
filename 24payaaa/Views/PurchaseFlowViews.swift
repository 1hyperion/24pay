import SwiftUI

struct TicketCatalogView: View {
    @EnvironmentObject private var store: LocalStore

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                BackTitle(title: "Transport")
                    .padding(.top, 50)

                ForEach(store.products) { product in
                    NavigationLink {
                        PaymentSummaryView(product: product)
                    } label: {
                        LargeTicketProductCard(product: product)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 22)
        }
        .appBackground()
        .navigationBarBackButtonHidden(true)
    }
}

struct PaymentSummaryView: View {
    @EnvironmentObject private var store: LocalStore
    @EnvironmentObject private var viewModel: AppViewModel
    @Environment(\.dismiss) private var dismiss
    let product: TicketProduct
    @State private var quantity = 1
    @State private var showingProcessing = false

    var total: Double {
        product.price * Double(quantity)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    BackTitle(title: "Sumar de plat\u{0103}") {
                        dismiss()
                    }
                    .padding(.top, 50)

                    TicketSelectorCard(product: product, quantity: $quantity)

                    PaymentMethodCard(total: total, card: store.cards.first)

                    TermsCard()
                        .padding(.bottom, 94)
                }
                .padding(.horizontal, 22)
            }

            Button {
                showingProcessing = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    showingProcessing = false
                    viewModel.purchase(product: product, quantity: quantity)
                }
            } label: {
                Text(showingProcessing ? "Se proceseaz\u{0103}..." : "Pl\u{0103}te\u{0219}te")
                    .font(.system(size: 24.5, weight: .regular))
                    .foregroundStyle(.black)
                    .frame(height: 76)
                    .frame(maxWidth: .infinity)
                    .background(AppTheme.Color.yellowSoft)
                    .clipShape(RoundedRectangle(cornerRadius: 9, style: .continuous))
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 22)
            .padding(.bottom, 36)
            .disabled(showingProcessing)
        }
        .appBackground()
        .navigationBarBackButtonHidden(true)
    }
}

struct TicketQRView: View {
    let ticket: Ticket
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 24) {
            BackTitle(title: "Bilet QR") {
                dismiss()
            }
            .padding(.top, 50)
            .padding(.horizontal, 22)

            VStack(spacing: 18) {
                Text(ticket.product.city)
                    .font(.system(size: 33, weight: .bold))
                    .foregroundStyle(.white)
                Text(ticket.product.title)
                    .font(.system(size: 22))
                    .foregroundStyle(AppTheme.Color.muted)

                QRCodeView(text: ticket.code)
                    .frame(width: 250, height: 250)
                    .padding(.top, 6)

                Text(ticket.code)
                    .font(.system(size: 17, weight: .semibold, design: .monospaced))
                    .foregroundStyle(AppTheme.Color.yellow)

                VStack(spacing: 6) {
                    Text("Valabil p\u{00E2}n\u{0103} la")
                        .font(.system(size: 17))
                        .foregroundStyle(AppTheme.Color.muted)
                    Text(ticket.expiresAt, format: .dateTime.day().month().hour().minute())
                        .font(.system(size: 23.5, weight: .semibold))
                        .foregroundStyle(.white)
                }
            }
            .padding(25)
            .frame(maxWidth: .infinity)
            .background(AppTheme.Color.surface)
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
            .padding(.horizontal, 22)

            Spacer()
        }
        .appBackground()
        .navigationBarBackButtonHidden(true)
    }
}

struct BackTitle: View {
    let title: String
    var action: (() -> Void)?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        HStack(spacing: 13) {
            Button {
                if let action {
                    action()
                } else {
                    dismiss()
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 33, weight: .medium))
                    .foregroundStyle(.white)
            }
            .buttonStyle(.plain)

            Text(title)
                .font(.system(size: 31, weight: .regular))
                .foregroundStyle(.white)
            Spacer()
        }
    }
}

struct LargeTicketProductCard: View {
    let product: TicketProduct

    var body: some View {
        HStack(spacing: 18) {
            CTPMark()
            VStack(alignment: .leading, spacing: 7) {
                Text(product.city)
                    .font(.system(size: 27, weight: .bold))
                    .foregroundStyle(.black)
                Text(product.title)
                    .font(.system(size: 20.5))
                    .foregroundStyle(AppTheme.Color.muted)
                Text(product.validity)
                    .font(.system(size: 18))
                    .foregroundStyle(AppTheme.Color.muted)
            }
            Spacer()
            VStack {
                Image(systemName: product.isFavorite ? "heart.fill" : "heart")
                    .font(.system(size: 27))
                    .foregroundStyle(AppTheme.Color.danger)
                Spacer()
                Text("\(product.price, specifier: "%.2f") RON")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.black)
            }
        }
        .padding(24)
        .frame(height: 158)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

struct TicketSelectorCard: View {
    let product: TicketProduct
    @Binding var quantity: Int

    var body: some View {
        VStack(spacing: 23) {
            HStack(alignment: .top, spacing: 18) {
                CTPMark()
                    .padding(.top, 33)
                VStack(alignment: .leading, spacing: 10) {
                    Text(product.city)
                        .font(.system(size: 28.5, weight: .bold))
                        .foregroundStyle(.black)
                    Text(product.title)
                    Text(product.validity)
                }
                .font(.system(size: 21.5, weight: .regular))
                .foregroundStyle(AppTheme.Color.muted)
                Spacer()
                Image(systemName: "heart.fill")
                    .font(.system(size: 30))
                    .foregroundStyle(AppTheme.Color.danger)
                    .padding(.top, 32)
            }
            .padding(.horizontal, 25)

            VStack(spacing: 23) {
                Text("Selecteaz\u{0103} num\u{0103}r de c\u{0103}l\u{0103}torii")
                    .font(.system(size: 24.5, weight: .regular))
                    .foregroundStyle(.black)

                HStack(spacing: 10) {
                    stepButton("-") {
                        quantity = max(1, quantity - 1)
                    }

                    Text("\(quantity)")
                        .font(.system(size: 43, weight: .regular))
                        .foregroundStyle(.black)
                        .frame(width: 76, height: 64)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(AppTheme.Color.background, lineWidth: 2)
                        }

                    stepButton("+") {
                        quantity += 1
                    }
                }
            }
            .padding(.vertical, 23)
            .frame(maxWidth: .infinity)
            .background(AppTheme.Color.surfaceSoft)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .padding(.horizontal, 22)
            .padding(.bottom, 20)
        }
        .padding(.top, 16)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }

    private func stepButton(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 31, weight: .regular))
                .foregroundStyle(.white)
                .frame(width: 80, height: 64)
                .background(AppTheme.Color.background)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

struct PaymentMethodCard: View {
    let total: Double
    let card: PaymentCard?

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack(alignment: .top) {
                Text("Vei pl\u{0103}ti\n\u{00EE}n total:")
                    .font(.system(size: 30, weight: .regular))
                    .lineSpacing(14)
                Spacer()
                Text("\(total, specifier: "%.2f") RON")
                    .font(.system(size: 30, weight: .regular))
                    .padding(.top, 26)
            }

            Rectangle()
                .fill(.white.opacity(0.08))
                .frame(height: 1)

            Text("Metod\u{0103} de plat\u{0103}")
                .font(.system(size: 28, weight: .regular))

            HStack(spacing: 19) {
                RoundedRectangle(cornerRadius: 1)
                    .fill(Color.cyan)
                    .frame(width: 67, height: 41)
                    .overlay(alignment: .topLeading) {
                        Text("Revolut")
                            .font(.system(size: 6, weight: .bold))
                            .padding(5)
                    }
                    .overlay(alignment: .bottomTrailing) {
                        Text("VISA")
                            .font(.system(size: 7, weight: .black))
                            .padding(5)
                    }

                VStack(alignment: .leading, spacing: 10) {
                    Text(card?.brand ?? "CREDIT CARD")
                        .font(.system(size: 20.5, weight: .regular))
                    Text("**** **** ******\(card?.last4 ?? "2971")")
                        .font(.system(size: 16.5, weight: .regular))
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 35, weight: .medium))
                    .foregroundStyle(.white.opacity(0.55))
            }
        }
        .foregroundStyle(.white)
        .padding(22)
        .frame(maxWidth: .infinity)
        .background(AppTheme.Color.surface)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

struct TermsCard: View {
    var body: some View {
        Text("Ia\u{0219}i - 4 RON Bilet urban valabil 120 de minute.\nNu se restituie contravaloarea titlului de c\u{0103}l\u{0103}torie dup\u{0103} cump\u{0103}rare.")
            .font(.system(size: 20, weight: .regular))
            .foregroundStyle(AppTheme.Color.muted)
            .lineSpacing(8)
            .padding(22)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppTheme.Color.surface)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

