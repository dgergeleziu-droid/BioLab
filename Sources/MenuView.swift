import SwiftUI

struct MenuView: View {

    @Environment(\.dismiss) private var dismiss

    private let items: [(String, String, Color)] = [
        ("Достижения",         "trophy.fill",         Palette.gold),
        ("Дневник наблюдений", "book.closed.fill",    Palette.cyan),
        ("Справочник",         "books.vertical.fill", Palette.green),
        ("Игры",               "gamecontroller.fill", Palette.nucleus),
        ("Опыты",              "flask.fill",          Palette.mito),
        ("Настройки",          "gearshape.fill",      Palette.textSecondary),
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Palette.background.ignoresSafeArea()

                ScrollView {
                    LazyVGrid(
                        columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())],
                        spacing: 10
                    ) {
                        ForEach(items, id: \.0) { item in
                            MenuRow(title: item.0, icon: item.1, tint: item.2)
                        }
                    }
                    .padding(16)
                }
            }
            .navigationTitle("Меню")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Закрыть") { dismiss() }
                        .foregroundColor(Palette.green)
                        .font(.system(size: 13, weight: .semibold))
                }
            }
        }
    }
}

private struct MenuRow: View {
    let title: String
    let icon: String
    let tint: Color

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle().fill(tint.opacity(0.18)).frame(width: 40, height: 40)
                Image(systemName: icon)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(tint)
            }

            Text(title)
                .font(.system(size: 11, weight: .semibold, design: .rounded))
                .foregroundColor(Palette.textPrimary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Palette.surface)
        .overlay(
            RoundedRectangle(cornerRadius: 14).stroke(Palette.stroke, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
