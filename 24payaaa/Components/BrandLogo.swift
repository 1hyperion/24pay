import SwiftUI

struct BrandLogo: View {
    var payColor: Color = .white

    var body: some View {
        HStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(AppTheme.Color.surface)
                Text("24")
                    .font(.system(size: 20, weight: .black, design: .rounded))
                    .foregroundStyle(AppTheme.Color.yellow)
                    .rotationEffect(.degrees(-8))
            }
            .frame(width: 44, height: 44)

            Text("pay")
                .font(.system(size: 27, weight: .black, design: .rounded))
                .italic()
                .foregroundStyle(payColor)
        }
    }
}

struct TopIconButton: View {
    let icon: String
    var hasBadge = false

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Circle()
                .fill(AppTheme.Color.surface)
                .frame(width: 58, height: 58)
                .overlay {
                    Image(systemName: icon)
                        .font(.system(size: 26, weight: .regular))
                        .foregroundStyle(.white)
                }

            if hasBadge {
                Circle()
                    .fill(.red)
                    .frame(width: 13, height: 13)
                    .padding(8)
            }
        }
    }
}

struct AppHeader: View {
    var body: some View {
        HStack {
            BrandLogo()
            Spacer()
            HStack(spacing: 8) {
                TopIconButton(icon: "bell", hasBadge: true)
                TopIconButton(icon: "gearshape")
                TopIconButton(icon: "person")
            }
        }
        .padding(.horizontal, 11)
    }
}
