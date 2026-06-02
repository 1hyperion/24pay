import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject private var viewModel: AppViewModel
    private let keypad = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "", "0", "⌫"]

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            pinCard
                .padding(.horizontal, 18)

            Spacer()

            contactSection

            Spacer(minLength: 0)

            hiddenPinPad

            authButton
                .padding(.horizontal, 34)
                .padding(.bottom, 34)
        }
        .appBackground()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                viewModel.authenticateWithFaceID()
            }
        }
    }

    private var pinCard: some View {
        VStack(spacing: 15) {
            ZStack {
                Circle()
                    .stroke(.white.opacity(0.78), lineWidth: 1.2)
                    .frame(width: 86, height: 86)
                    .background(Circle().fill(AppTheme.Color.surface.opacity(0.94)))

                Image(systemName: "person")
                    .font(.system(size: 42, weight: .light))
                    .foregroundStyle(.white)
            }
            .padding(.top, 20)

            Text("Bun venit! Introdu codul PIN")
                .font(.system(size: 23, weight: .regular))
                .foregroundStyle(.white)
                .padding(.top, 3)

            HStack(spacing: 23) {
                ForEach(0..<4, id: \.self) { index in
                    Circle()
                        .stroke(AppTheme.Color.muted, lineWidth: 1.25)
                        .background(Circle().fill(index < viewModel.enteredPin.count ? AppTheme.Color.yellow : .clear))
                        .frame(width: 25, height: 25)
                }
            }
            .padding(.top, 1)

            Button("Am uitat cod PIN") { }
                .font(.system(size: 19, weight: .regular))
                .foregroundStyle(AppTheme.Color.yellow)
                .padding(.top, 3)
        }
        .padding(.horizontal, 14)
        .padding(.bottom, 23)
        .frame(maxWidth: .infinity)
        .background(AppTheme.Color.surface)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    private var contactSection: some View {
        VStack(spacing: 12) {
            Text("Contact:")
                .font(.system(size: 19, weight: .bold))
            Text("+40 721 102 424,  +40 753 300 151")
                .font(.system(size: 18, weight: .regular))
                .underline()
        }
        .foregroundStyle(AppTheme.Color.yellow)
        .padding(.top, 23)
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
                .font(.system(size: 27, weight: .regular))
                .foregroundStyle(viewModel.enteredPin.count == 4 ? AppTheme.Color.background : AppTheme.Color.muted)
                .frame(height: 64)
                .frame(maxWidth: .infinity)
                .background(viewModel.enteredPin.count == 4 ? AppTheme.Color.yellow : .clear)
                .overlay {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(AppTheme.Color.muted, lineWidth: 1.2)
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
            Text(key)
                .frame(height: 1)
        }
    }
}


