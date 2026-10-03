import SwiftUI

/// Режим "Определитель" — расставь таксоны по порядку
struct ClassifierView: View {

    @State private var current = 0
    @State private var slots: [String?] = Array(repeating: nil, count: 7)
    @State private var pool: [String] = []
    @State private var dragged: String? = nil
    @State private var message: String? = nil

    private var species: Species { Species.all[current] }

    var body: some View {
        HStack(spacing: 0) {

            // ─── Инфо ────────────────────────────────────────
            VStack(alignment: .leading, spacing: 12) {
                Text("ОПРЕДЕЛИТЕЛЬ")
                    .font(.system(size: 11, weight: .bold))
                    .tracking(1.5)
                    .foregroundColor(Palette.textDim)

                Text(species.emoji)
                    .font(.system(size: 72))

                Text(species.name)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(Palette.textPrimary)

                Text(species.hint)
                    .font(.system(size: 12))
                    .foregroundColor(Palette.textSecondary)

                Spacer()

                Text("Перетащи таксоны в правильном порядке — от большего к меньшему.")
                    .font(.system(size: 11))
                    .foregroundColor(Palette.textDim)
            }
            .padding(20)
            .frame(width: 240)
            .background(Palette.surface.opacity(0.4))

            // ─── Слоты ───────────────────────────────────────
            VStack(spacing: 8) {

                ForEach(0..<species.chain.count, id: \.self) { i in
                    HStack {
                        Text(species.chain[i].0)
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(Palette.textDim)
                            .frame(width: 100, alignment: .leading)

                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(slots[i] == nil ? Palette.surface : Palette.green.opacity(0.2))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(slots[i] == nil ? Palette.stroke : Palette.green,
                                                lineWidth: slots[i] == nil ? 1 : 1.5)
                                )

                            if let s = slots[i] {
                                Text(s)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Palette.textPrimary)
                            } else {
                                Text("перетащи сюда")
                                    .font(.system(size: 12))
                                    .foregroundColor(Palette.textDim)
                            }
                        }
                        .frame(height: 40)
                        .onDrop(of: [.text], isTargeted: nil) { providers in
                            handleDrop(providers, at: i)
                            return true
                        }
                    }
                    .padding(.horizontal, 30)
                }

                Spacer().frame(height: 12)

                // Пул вариантов
                HStack(spacing: 8) {
                    ForEach(pool, id: \.self) { p in
                        Text(p)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(Palette.textPrimary)
                            .padding(.horizontal, 12).padding(.vertical, 8)
                            .background(Palette.surfaceHi)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10).stroke(Palette.stroke, lineWidth: 1)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .onDrag {
                                dragged = p
                                return NSItemProvider(object: p as NSString)
                            }
                    }
                }
                .padding(.horizontal, 20)

                Spacer().frame(height: 10)

                HStack(spacing: 12) {
                    Button("Проверить") { check() }
                        .buttonStyle(PrimaryButton())
                    Button("Дальше") { next() }
                        .buttonStyle(SecondaryButton())
                }

                if let msg = message {
                    Text(msg)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(msg.hasPrefix("Правильно") ? Palette.green : Palette.danger)
                        .padding(.top, 6)
                }

                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
        .onAppear(perform: loadSpecies)
    }

    private func loadSpecies() {
        slots = Array(repeating: nil, count: species.chain.count)
        pool = species.chain.map { $0.1 }.shuffled()
        message = nil
    }

    private func handleDrop(_ providers: [NSItemProvider], at index: Int) {
        _ = providers.first?.loadObject(ofClass: NSString.self) { item, _ in
            guard let text = item as? String else { return }
            DispatchQueue.main.async {
                if let oldIdx = slots.firstIndex(where: { $0 == text }) {
                    slots[oldIdx] = nil
                }
                slots[index] = text
                pool.removeAll { $0 == text }
            }
        }
    }

    private func check() {
        let correct = species.chain.map { $0.1 }
        if slots == correct {
            message = "Правильно! ✓"
        } else {
            message = "Не совсем. Попробуй ещё."
        }
    }

    private func next() {
        current = (current + 1) % Species.all.count
        loadSpecies()
    }
}
