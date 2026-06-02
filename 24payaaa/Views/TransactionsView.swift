import SwiftUI

struct TransactionsView: View {
    @EnvironmentObject private var store: LocalStore
    @State private var selectedPage = 0
    @State private var selectedChart = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Tranzacții")
                .font(AppTheme.Font.hero)
                .foregroundStyle(.white)
                .padding(.top, 76)
                .padding(.leading, 53)

            HStack(spacing: 16) {
                tabText("Istoric plăți", index: 0)
                tabText("Statistici", index: 1)
                Spacer()
            }
            .padding(.top, 38)
            .padding(.horizontal, 27)

            if selectedPage == 0 {
                TransactionHistoryView(transactions: store.transactions)
                    .padding(.top, 26)
            } else {
                StatisticsView(selectedChart: $selectedChart)
                    .padding(.top, 26)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    private func tabText(_ title: String, index: Int) -> some View {
        Button {
            selectedPage = index
        } label: {
            VStack(alignment: .leading, spacing: 13) {
                Text(title)
                    .font(.system(size: 23, weight: .regular))
                    .foregroundStyle(selectedPage == index ? AppTheme.Color.yellow : AppTheme.Color.muted)
                Rectangle()
                    .fill(selectedPage == index ? AppTheme.Color.yellow : .clear)
                    .frame(height: 3)
            }
            .fixedSize()
        }
        .buttonStyle(.plain)
    }
}

struct TransactionHistoryView: View {
    let transactions: [Transaction]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 30) {
                FilterButton(title: "Filtrează tranzacții", icon: "line.3.horizontal.decrease")
                    .padding(.horizontal, 27)

                ForEach(Array(groupedMonths.enumerated()), id: \.offset) { _, group in
                    VStack(alignment: .leading, spacing: 14) {
                        Text(group.title)
                            .font(AppTheme.Font.large)
                            .foregroundStyle(.white)
                            .padding(.leading, 53)

                        ForEach(group.items) { transaction in
                            TransactionRow(transaction: transaction)
                                .padding(.horizontal, 27)
                        }
                    }
                }
            }
        }
    }

    private var groupedMonths: [(title: String, items: [Transaction])] {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ro_RO")
        formatter.dateFormat = "MMMM yyyy"
        let grouped = Dictionary(grouping: transactions) { transaction in
            formatter.string(from: transaction.date).capitalized
        }
        return grouped.map { ($0.key, $0.value.sorted { $0.date > $1.date }) }
            .sorted { ($0.items.first?.date ?? .distantPast) > ($1.items.first?.date ?? .distantPast) }
    }
}

struct TransactionRow: View {
    let transaction: Transaction

    var body: some View {
        HStack(spacing: 16) {
            VStack(spacing: 1) {
                Text(day)
                    .font(.system(size: 22, weight: .regular))
                Text(month)
                    .font(.system(size: 24, weight: .regular))
            }
            .foregroundStyle(.white)
            .frame(width: 66)

            Rectangle()
                .fill(AppTheme.Color.muted)
                .frame(width: 1, height: 68)

            VStack(alignment: .leading, spacing: 9) {
                Text(transaction.city)
                    .font(.system(size: 25, weight: .regular))
                    .foregroundStyle(.white)
                Text(transaction.subtitle)
                    .font(.system(size: 19, weight: .regular))
                    .foregroundStyle(AppTheme.Color.muted)
            }

            Spacer()

            Text("\(transaction.amount, specifier: "%.2f") RON")
                .font(.system(size: 25, weight: .regular))
                .foregroundStyle(AppTheme.Color.muted)
        }
        .padding(.horizontal, 18)
        .frame(height: 103)
        .background(AppTheme.Color.surface)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
    }

    private var day: String {
        String(Calendar.current.component(.day, from: transaction.date))
    }

    private var month: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ro_RO")
        formatter.dateFormat = "MMM"
        return formatter.string(from: transaction.date).uppercased().replacingOccurrences(of: ".", with: "")
    }
}

struct StatisticsView: View {
    @Binding var selectedChart: Int

    var body: some View {
        VStack(spacing: 24) {
            FilterButton(title: "Ultimele 7 zile", icon: nil)
                .padding(.horizontal, 27)

            SegmentedStatsPicker(selected: $selectedChart)

            StatisticsChart(values: Array(repeating: 0, count: 7))
                .padding(.horizontal, 27)
                .padding(.top, 12)
        }
    }
}
