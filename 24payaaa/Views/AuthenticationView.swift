import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject private var viewModel: AppViewModel
    @State private var animateOrb = false
    private let keypad = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "", "0", "⌫"]

    var body: some View {
        VStack(spacing: 0) {
            FaceIDOrb(animate: animateOrb)
                .frame(width: 184, height: 184)
                .padding(.top, 16)
                .zIndex(2)

            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .stroke(.white.opacity(0.78), lineWidth: 1.3)
                        .frame(width: 100, height: 100)
                        .background(Circle().fill(AppTheme.Color.surface.opacity(0.6)))
                    Image(systemName: "person")
                        .font(.system(size: 46, weight: .light))
                        .foregroundStyle(.white)
                }
                .offset(y: -58)
                .padding(.bottom, -48)

                Text("Bun venit! Introdu codul PIN")
                    .font(.system(size: 24, weight: .regular))
                    .foregroundStyle(.white)

                HStack(spacing: 25) {
                    ForEach(0..<4, id: \.self) { index in
                        Circle()
                            .stroke(AppTheme.Color.muted, lineWidth: 1.4)
                            .background(Circle().fill(index < viewModel.enteredPin.count ? AppTheme.Color.yellow : .clear))
                            .frame(width: 28, height: 28)
                    }
                }

                Button("Am uitat cod PIN") { }
                    .font(.system(size: 20, weight: .regular))
                    .foregroundStyle(AppTheme.Color.yellow)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 25)
            .frame(maxWidth: .infinity)
            .background(AppTheme.Color.surface)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .padding(.horizontal, 20)
            .offset(y: -44)

            Text("Autentificare cu")
                .font(.system(size: 28, weight: .regular))
                .foregroundStyle(.white)
                .padding(.top, 5)

            Button {
                viewModel.authenticateWithFaceID()
            } label: {
                Image(systemName: "faceid")
                    .font(.system(size: 64, weight: .regular))
                    .foregroundStyle(.black)
                    .frame(width: 86, height: 86)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
            .buttonStyle(.plain)
            .padding(.top, 18)

            VStack(spacing: 13) {
                Text("Contact:")
                    .font(.system(size: 20, weight: .bold))
                Text("+40 721 102 424,  +40 753 300 151")
                    .font(.system(size: 19, weight: .regular))
                    .underline()
            }
            .foregroundStyle(AppTheme.Color.yellow)
            .padding(.top, 26)

            Spacer()

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 18), count: 3), spacing: 10) {
                ForEach(keypad, id: \.self) { key in
                    keypadButton(key)
                }
            }
            .frame(height: 0)
            .opacity(0.01)
            .accessibilityHidden(true)

            Button {
                viewModel.authenticateWithPin()
            } label: {
                Text("Autentificare")
                    .font(.system(size: 28, weight: .regular))
                    .foregroundStyle(viewModel.enteredPin.count == 4 ? AppTheme.Color.background : AppTheme.Color.muted)
                    .frame(height: 65)
                    .frame(maxWidth: .infinity)
                    .background(viewModel.enteredPin.count == 4 ? AppTheme.Color.yellow : .clear)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke(AppTheme.Color.muted, lineWidth: 1.2)
                    }
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 34)
            .padding(.bottom, 39)
        }
        .appBackground()
        .onAppear {
            animateOrb = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                viewModel.authenticateWithFaceID()
            }
        }
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

struct FaceIDOrb: View {
    let animate: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 48, style: .continuous)
                .fill(.black)

            ForEach(0..<4, id: \.self) { index in
                Ellipse()
                    .stroke(Color.green.opacity(index == 0 ? 0.7 : 0.45), lineWidth: 9)
                    .blur(radius: index == 0 ? 7 : 3)
                    .frame(width: 98, height: 52)
                    .rotationEffect(.degrees(Double(index) * 45 + (animate ? 360 : 0)))
                    .animation(.linear(duration: 2.6 + Double(index) * 0.25).repeatForever(autoreverses: false), value: animate)
            }
        }
    }
}

