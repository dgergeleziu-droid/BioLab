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
                    VStack(spacing: 12) {
                        ForEach(items, id: \.0) { item in
                            MenuRow(title: item.0, icon: item.1, tint: item.2)
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Меню")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Закрыть") { dismiss() }
                        .foregroundColor(Palette.green)
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
        HStack(spacing: 14) {
            ZStack {
                Circle().fill(tint.opacity(0.18)).frame(width: 46, height: 46)
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(tint)
            }

            Text(title)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(Palette.textPrimary)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(Palette.textDim)
        }
        .padding(14)
        .background(Palette.surface)
        .overlay(
            RoundedRectangle(cornerRadius: 16).stroke(Palette.stroke, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
