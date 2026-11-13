import WidgetKit
import SwiftUI

struct HoldingItem: Codable, Identifiable {
    var id: String { ticker }
    let ticker: String
    let companyName: String
    let quantity: Int
    let currentPrice: Double
    let totalCurrentValue: Double
    let gainOrLoss: Double
    let formattedValue: String
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let portfolioValue: String
    let gainOrLoss: String
    let isPositive: Bool
    let invested: String
    let lastUpdated: String
    let appTheme: String
    let portfolioValueLabel: String
    let investedLabel: String
    let topHoldingsLabel: String
    let topHoldings: [HoldingItem]
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(
            date: Date(),
            portfolioValue: "$42,580.00",
            gainOrLoss: "+$5,240.50 (+14.02%)",
            isPositive: true,
            invested: "$37,339.50",
            lastUpdated: "Today 14:35",
            appTheme: "vibrant",
            portfolioValueLabel: "Total Portfolio Value",
            investedLabel: "Invested",
            topHoldingsLabel: "Top Holdings",
            topHoldings: [
                HoldingItem(ticker: "AAPL", companyName: "Apple Inc", quantity: 10, currentPrice: 185.2, totalCurrentValue: 1852.0, gainOrLoss: 120.0, formattedValue: "$1,852.00"),
                HoldingItem(ticker: "NVDA", companyName: "NVIDIA Corp", quantity: 5, currentPrice: 450.0, totalCurrentValue: 2250.0, gainOrLoss: 300.0, formattedValue: "$2,250.00"),
            ]
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = entryFromUserDefaults()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let entry = entryFromUserDefaults()
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30, to: Date()) ?? Date()
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }

    private func entryFromUserDefaults() -> SimpleEntry {
        let defaults = UserDefaults(suiteName: "group.com.turskyi.investtracks")
        let portfolioValue = defaults?.string(forKey: "total_portfolio_value") ?? "$0.00"
        let gainOrLoss = defaults?.string(forKey: "total_gain_or_loss") ?? "+$0.00"
        let gainLossPct = defaults?.string(forKey: "total_gain_or_loss_percentage") ?? "(+0.00%)"
        let isPositive = defaults?.bool(forKey: "is_positive") ?? true
        let invested = defaults?.string(forKey: "total_invested") ?? "$0.00"
        let lastUpdated = defaults?.string(forKey: "last_updated") ?? "Just now"
        let appTheme = defaults?.string(forKey: "app_theme") ?? "vibrant"
        let portfolioValueLabel = defaults?.string(forKey: "total_portfolio_value_label") ?? "Total Portfolio Value"
        let investedLabel = defaults?.string(forKey: "invested_label") ?? "Invested"
        let topHoldingsLabel = defaults?.string(forKey: "top_holdings_label") ?? "Top Holdings"
        let holdingsJson = defaults?.string(forKey: "top_holdings_json") ?? "[]"

        let topHoldings: [HoldingItem] = (try? JSONDecoder().decode([HoldingItem].self, from: holdingsJson.data(using: .utf8) ?? Data())) ?? []

        return SimpleEntry(
            date: Date(),
            portfolioValue: portfolioValue,
            gainOrLoss: "\(gainOrLoss) (\(gainLossPct))",
            isPositive: isPositive,
            invested: invested,
            lastUpdated: lastUpdated,
            appTheme: appTheme,
            portfolioValueLabel: portfolioValueLabel,
            investedLabel: investedLabel,
            topHoldingsLabel: topHoldingsLabel,
            topHoldings: topHoldings
        )
    }
}

struct InvestTrackWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("InvestTracks")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white.opacity(0.9))
                Spacer()
                Text(entry.lastUpdated)
                    .font(.system(size: 10))
                    .foregroundColor(.white.opacity(0.7))
            }

            Spacer()

            VStack(alignment: .leading, spacing: 2) {
                Text(entry.portfolioValueLabel)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.75))

                Text(entry.portfolioValue)
                    .font(family == .systemSmall ? .title2 : .title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }

            Text(entry.gainOrLoss)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(entry.isPositive ? Color.green : Color.red)

            if family != .systemSmall {
                Text("\(entry.investedLabel): \(entry.invested)")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.8))
            }

            if family == .systemLarge && !entry.topHoldings.isEmpty {
                Divider()
                    .background(Color.white.opacity(0.3))
                    .padding(.vertical, 4)

                Text(entry.topHoldingsLabel)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.white.opacity(0.9))

                VStack(spacing: 4) {
                    ForEach(entry.topHoldings.prefix(3)) { item in
                        HStack {
                            Text(item.ticker)
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Spacer()
                            Text(item.formattedValue)
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                        }
                    }
                }
            }

            Spacer()
        }
        .padding()
        .widgetContainerBackground(BackgroundGradient(appTheme: entry.appTheme))
    }
}

struct BackgroundGradient: View {
    let appTheme: String

    var body: some View {
        LinearGradient(
            colors: appTheme == "stealth"
                ? [Color(hex: 0xB71C1C), Color(hex: 0x000000)]
                : [Color(hex: 0x0D47A1), Color(hex: 0xC79100)],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

extension Color {
    init(hex: UInt32) {
        let red = Double((hex & 0xFF0000) >> 16) / 255.0
        let green = Double((hex & 0x00FF00) >> 8) / 255.0
        let blue = Double(hex & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}

extension View {
    @ViewBuilder
    func widgetContainerBackground<Background: View>(_ backgroundView: Background) -> some View {
        if #available(iOS 17.0, macOS 14.0, *) {
            self.containerBackground(for: .widget) {
                backgroundView
            }
        } else {
            self.background(backgroundView)
        }
    }
}

extension WidgetConfiguration {
    func disableContentMarginsIfNeeded() -> some WidgetConfiguration {
        if #available(iOS 17.0, macOS 14.0, *) {
            return self.contentMarginsDisabled()
        } else {
            return self
        }
    }
}

@main
struct InvestTrackWidgets: Widget {
    let kind: String = "InvestTrackWidgets"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            InvestTrackWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("InvestTracks Portfolio")
        .description("Track your portfolio value and gain/loss at a glance.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
        .disableContentMarginsIfNeeded()
    }
}
