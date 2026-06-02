import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject private var viewModel: AppViewModel
    private let keypad = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "", "0", "⌫"]

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            pinCard
                .padding(.horizontal, AppTheme.Layout.horizontal)

            Spacer()

            contactSection
                .padding(.bottom, 28)

            hiddenPinPad

            authButton
                .padding(.horizontal, AppTheme.Layout.horizontal)
                .padding(.bottom, 40)
        }
        .appBackground()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                viewModel.authenticateWithFaceID()
            }
        }
    }

    private var pinCard: some View {
        VStack(spacing: 20) {
            Text("Bun venit!")
                .font(AppTheme.Font.hero)
                .foregroundStyle(.white)
                .padding(.top, 28)

            Text("Introdu codul PIN")
                .font(AppTheme.Font.body)
                .foregroundStyle(AppTheme.Color.muted)

            HStack(spacing: 26) {
                ForEach(0..<4, id: \.self) { index in
                    Circle()
                        .stroke(AppTheme.Color.muted, lineWidth: 1.5)
                        .background(Circle().fill(index < viewModel.enteredPin.count ? AppTheme.Color.yellow : .clear))
                        .frame(width: 28, height: 28)
                }
            }
            .padding(.vertical, 8)

            Button("Am uitat codul PIN") { }
                .font(AppTheme.Font.body)
                .foregroundStyle(AppTheme.Color.yellow)
                .padding(.bottom, 28)
        }
        .frame(maxWidth: .infinity)
        .background(AppTheme.Color.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Layout.cardCorner, style: .continuous))
    }

    private var contactSection: some View {
        VStack(spacing: 8) {
            Text("Contact:")
                .font(AppTheme.Font.caption)
                .foregroundStyle(AppTheme.Color.muted)
            Text("+40 721 102 424,  +40 753 300 151")
                .font(AppTheme.Font.caption)
                .foregroundStyle(AppTheme.Color.yellow)
                .underline()
        }
    }

    private var hiddenPinPad: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 18), count: 3), spacing: 10) {
            ForEach(keypad, id: \.self) { key in
                keypadButton(key)
            }
        }
        .frame(height: 0)
        .opacity(0.01)
        .accessibilityHidden(true)
    }

    private var authButton: some View {
        Button {
            viewModel.authenticateWithPin()
        } label: {
            Text("Autentificare")
                .font(AppTheme.Font.large)
                .foregroundStyle(viewModel.enteredPin.count == 4 ? AppTheme.Color.background : AppTheme.Color.muted)
                .frame(height: 64)
                .frame(maxWidth: .infinity)
                .background(viewModel.enteredPin.count == 4 ? AppTheme.Color.yellow : .clear)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Layout.corner, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: AppTheme.Layout.corner, style: .continuous)
                        .stroke(AppTheme.Color.border, lineWidth: 1.2)
                }
        }
        .buttonStyle(.plain)
    }

    private func keypadButton(_ key: String) -> some View {
        Button {
            if key == "⌫" {
                _ = viewModel.enteredPin.popLast()
            } else if !key.isEmpty {
                viewModel.appendPin(key)
            }
        } label: {
            Text(key).frame(height: 1)
        }
    }
}
