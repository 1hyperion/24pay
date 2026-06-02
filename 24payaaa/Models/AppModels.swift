import Foundation

enum AppTab: String, CaseIterable, Identifiable, Codable {
    case home
    case services
    case scan
    case transactions
    case wallet

    var id: String { rawValue }

    var title: String {
        switch self {
        case .home: "Acas\u{0103}"
        case .services: "Servicii"
        case .scan: "Scaneaz\u{0103}"
        case .transactions: "Tranzac\u{021B}ii"
        case .wallet: "Portofel"
        }
    }

    var icon: String {
        switch self {
        case .home: "house"
        case .services: "square.grid.2x2"
        case .scan: "viewfinder"
        case .transactions: "bag"
        case .wallet: "wallet.pass"
        }
    }
}

enum ServiceCategory: String, Codable, CaseIterable, Identifiable {
    case transport = "Transport"
    case payments = "Pl\u{0103}\u{021B}i"
    case prepay = "PrePay"
    case auto = "RCA & taxe auto"

    var id: String { rawValue }
}

struct PayService: Identifiable, Codable, Hashable {
    let id: UUID
    let title: String
    let icon: String
    let category: ServiceCategory
    var isEnabled: Bool

    init(id: UUID = UUID(), title: String, icon: String, category: ServiceCategory, isEnabled: Bool = true) {
        self.id = id
        self.title = title
        self.icon = icon
        self.category = category
        self.isEnabled = isEnabled
    }
}

struct TicketProduct: Identifiable, Codable, Hashable {
    let id: UUID
    let city: String
    let title: String
    let validity: String
    let price: Double
    var isFavorite: Bool

    init(id: UUID = UUID(), city: String, title: String, validity: String, price: Double, isFavorite: Bool) {
        self.id = id
        self.city = city
        self.title = title
        self.validity = validity
        self.price = price
        self.isFavorite = isFavorite
    }
}

struct PaymentCard: Identifiable, Codable, Hashable {
    let id: UUID
    let brand: String
    let last4: String
    let tintHex: String

    init(id: UUID = UUID(), brand: String, last4: String, tintHex: String) {
        self.id = id
        self.brand = brand
        self.last4 = last4
        self.tintHex = tintHex
    }
}

struct Transaction: Identifiable, Codable, Hashable {
    let id: UUID
    let date: Date
    let city: String
    let subtitle: String
    let amount: Double

    init(id: UUID = UUID(), date: Date, city: String, subtitle: String, amount: Double) {
        self.id = id
        self.date = date
        self.city = city
        self.subtitle = subtitle
        self.amount = amount
    }
}

struct Ticket: Identifiable, Codable, Hashable {
    let id: UUID
    let product: TicketProduct
    let purchasedAt: Date
    let quantity: Int
    let code: String

    var expiresAt: Date {
        Calendar.current.date(byAdding: .minute, value: 120, to: purchasedAt) ?? purchasedAt
    }
}
