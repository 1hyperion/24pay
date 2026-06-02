import Foundation
import LocalAuthentication
import SwiftUI
internal import Combine

@MainActor
final class AppViewModel: ObservableObject {
    var objectWillChange: ObservableObjectPublisher
    
    @Published var selectedTab: AppTab = .home
    @Published var isAuthenticated = false
    @Published var enteredPin = ""
    @Published var selectedTicket: Ticket?

    let store: LocalStore

    init(store: LocalStore = LocalStore()) {
        self.store = store
    }

    func authenticateWithPin() {
        guard enteredPin.count == 4 else { return }
        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
            isAuthenticated = true
        }
    }

    func appendPin(_ digit: String) {
        guard enteredPin.count < 4 else { return }
        enteredPin.append(digit)
        if enteredPin.count == 4 {
            authenticateWithPin()
        }
    }

    func authenticateWithFaceID() {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Autentificare 24pay") { [weak self] success, _ in
                Task { @MainActor in
                    if success {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.82)) {
                            self?.isAuthenticated = true
                        }
                    }
                }
            }
        } else {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.82)) {
                isAuthenticated = true
            }
        }
    }

    func purchase(product: TicketProduct, quantity: Int) {
        selectedTicket = store.purchase(product: product, quantity: quantity)
    }
}

