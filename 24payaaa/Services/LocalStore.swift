import Foundation
import Combine

@MainActor
final class LocalStore: ObservableObject {
    let objectWillChange = ObservableObjectPublisher()
    
    @Published var services: [PayService] = []
    @Published var products: [TicketProduct] = []
    @Published var cards: [PaymentCard] = []
    @Published var transactions: [Transaction] = []
    @Published var tickets: [Ticket] = []

    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601

        self.encoder = encoder
        self.decoder = decoder
        self.defaults = defaults

        self.services = Self.load([PayService].self, key: "services", decoder: decoder, defaults: defaults) ?? Self.seedServices
        self.products = Self.load([TicketProduct].self, key: "products", decoder: decoder, defaults: defaults) ?? Self.seedProducts
        self.cards = Self.load([PaymentCard].self, key: "cards", decoder: decoder, defaults: defaults) ?? Self.seedCards
        self.transactions = Self.load([Transaction].self, key: "transactions", decoder: decoder, defaults: defaults) ?? Self.seedTransactions
        self.tickets = Self.load([Ticket].self, key: "tickets", decoder: decoder, defaults: defaults) ?? []
    }

    func save() {
        persist(services, key: "services")
        persist(products, key: "products")
        persist(cards, key: "cards")
        persist(transactions, key: "transactions")
        persist(tickets, key: "tickets")
    }

    func purchase(product: TicketProduct, quantity: Int) -> Ticket {
        let ticket = Ticket(id: UUID(), product: product, purchasedAt: Date(), quantity: quantity, code: "24PAY-\(Int.random(in: 100000...999999))")
        tickets.insert(ticket, at: 0)
        transactions.insert(Transaction(date: Date(), city: product.city, subtitle: product.title, amount: product.price * Double(quantity)), at: 0)
        save()
        return ticket
    }

    func toggleFavorite(product: TicketProduct) {
        guard let index = products.firstIndex(where: { $0.id == product.id }) else { return }
        products[index].isFavorite.toggle()
        save()
    }

    private func persist<T: Encodable>(_ value: T, key: String) {
        guard let data = try? encoder.encode(value) else { return }
        defaults.set(data, forKey: key)
    }

    private static func load<T: Decodable>(_ type: T.Type, key: String, decoder: JSONDecoder, defaults: UserDefaults) -> T? {
        guard let data = defaults.data(forKey: key) else { return nil }
        return try? decoder.decode(type, from: data)
    }
}

extension LocalStore {
    static let seedProducts = [
        TicketProduct(city: "Iași", title: "Bilet Zona Urbană", validity: "Valabilitate 120 minute", price: 4, isFavorite: true)
    ]

    static let seedCards = [
        PaymentCard(brand: "CREDIT CARD", last4: "2971", tintHex: "#10C9C3")
    ]

    static let seedServices = [
        PayService(title: "Transport\npublic", icon: "bus", category: .transport),
        PayService(title: "Parcare", icon: "parkingsign.square", category: .transport, isEnabled: false),
        PayService(title: "Transport\ninterurban", icon: "bus.doubledecker", category: .transport, isEnabled: false),
        PayService(title: "Plată\nfacturi", icon: "receipt", category: .payments),
        PayService(title: "Încărcare\nelectronică", icon: "arrow.up.doc", category: .prepay),
        PayService(title: "Încărcare\ninternațională", icon: "network", category: .prepay),
        PayService(title: "e-SIM", icon: "simcard", category: .prepay),
        PayService(title: "RCA &\ntaxe auto", icon: "checklist", category: .auto),
        PayService(title: "ESX", icon: "face.smiling", category: .auto),
        PayService(title: "Rovinieta", icon: "car", category: .auto, isEnabled: false),
        PayService(title: "Taxa HU", icon: "car.rear.and.tire.marks", category: .auto, isEnabled: false)
    ]

    static var seedTransactions: [Transaction] {
        let calendar = Calendar.current
        let dates: [(Int, Int, Int)] = [(2026, 5, 21), (2026, 4, 7), (2026, 3, 23), (2026, 3, 19)]
        return dates.compactMap { year, month, day in
            let date = calendar.date(from: DateComponents(year: year, month: month, day: day)) ?? Date()
            return Transaction(date: date, city: "Iasi", subtitle: "Bilet Zona Urbana", amount: 4)
        }
    }
}
