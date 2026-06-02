import Foundation
import Combine
import LocalAuthentication
import SwiftUI

@MainActor
final class AppViewModel: ObservableObject {
    let objectWillChange = ObservableObjectPublisher()
    
    @Published var selectedTab: AppTab = .home
    @Published var isAuthenticated = false
    @Published var enteredPin = ""
    @Published var selectedTicket: Ticket?

    let store: LocalStore

    init() {
        self.store = LocalStore()
    }

    init(store: LocalStore) {
        self.store = store
    }

    private func completeAuthentication() {
        selectedTab = .home
        withAnimation(.easeInOut(duration: 0.45)) {
            isAuthenticated = true
        }
    }

    func authenticateWithPin() {
        guard enteredPin.count == 4 else { return }
        completeAuthentication()
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
                Task { @MainActor [weak self, success] in
                    if success {
                        self?.completeAuthentication()
                    }
                }
            }
        } else {
            completeAuthentication()
        }
    }

    func purchase(product: TicketProduct, quantity: Int) {
        selectedTicket = store.purchase(product: product, quantity: quantity)
    }
}
