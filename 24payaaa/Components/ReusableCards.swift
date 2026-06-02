import SwiftUI

struct ServiceCard: View {
    let service: PayService

    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: service.icon)
                .font(.system(size: 36, weight: .light))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(service.isEnabled ? .white : .white.opacity(0.58))
                .frame(width: 58, height: 54, alignment: .leading)

            Spacer(minLength: 18)

            Text(service.title)
                .font(AppTheme.Font.body)
                .foregroundStyle(service.isEnabled ? .white : .white.opacity(0.6))
                .lineSpacing(4)
                .minimumScaleFactor(0.82)
        }
        .padding(.leading, 15)
        .padding(.top, 23)
        .padding(.bottom, 18)
        .frame(height: 149)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(service.isEnabled ? AppTheme.Color.surface : AppTheme.Color.surfaceDim.opacity(0.45))
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
    }
}

struct CTPMark: View {
    var body: some View {
        VStack(alignment: .leading, spacing: -4) {
            Text("CTP")
                .font(.system(size: 28, weight: .black, design: .rounded))
                .italic()
                .foregroundStyle(.green)
                .overlay(alignment: .leading) {
                    Capsule()
                        .fill(.gray.opacity(0.85))
                        .frame(width: 42, height: 19)
                        .offset(x: -19, y: 9)
                        .zIndex(-1)
                }
            Text("COMPANIA DE TRANSPORT PUBLIC IA\u{0218}I")
                .font(.system(size: 4.8, weight: .bold))
                .foregroundStyle(.black)
        }
        .frame(width: 92, alignment: .leading)
    }
}

struct FavoriteTicketCard: View {
    let product: TicketProduct

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top) {
                CTPMark()
                    .padding(.top, 18)
                    .padding(.leading, 28)
                Spacer()
                Image(systemName: "heart.fill")
                    .font(.system(size: 27))
                    .foregroundStyle(AppTheme.Color.danger)
                    .padding(.top, 27)
                    .padding(.trailing, 22)
            }

            Spacer()

            VStack(alignment: .leading, spacing: 9) {
                Text("\(product.city) - \(product.title)")
                Text("- \(product.price, specifier: "%.1f") RON")
            }
            .font(.system(size: 17.5, weight: .regular))
            .foregroundStyle(.black)
            .padding(.horizontal, 16)
            .padding(.bottom, 28)
        }
        .frame(width: 217, height: 174)
        .background {
            VStack(spacing: 0) {
                Color.white
                AppTheme.Color.lavender
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
    }
}

struct FilterButton: View {
    let title: String
    let icon: String?

    var body: some View {
        HStack(spacing: 10) {
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: 19, weight: .bold))
                    .foregroundStyle(AppTheme.Color.yellow)
            }
            Text(title)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.white)
        }
        .frame(height: 53)
        .frame(maxWidth: .infinity)
        .background(AppTheme.Color.background)
        .overlay {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(.white.opacity(0.31), lineWidth: 1.2)
        }
    }
}

struct SectionTitleRow: View {
    let title: String
    var action: String?

    var body: some View {
        HStack(alignment: .lastTextBaseline) {
            Text(title)
                .font(AppTheme.Font.title)
                .foregroundStyle(.white)
            Spacer()
            if let action {
                Text(action)
                    .font(.system(size: 19, weight: .regular))
                    .foregroundStyle(AppTheme.Color.yellowSoft)
            }
        }
    }
}

