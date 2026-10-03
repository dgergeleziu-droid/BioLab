import SwiftUI

struct ClassifierView: View {

    @State private var current = 0
    @State private var slots: [String?] = []
    @State private var pool: [String] = []
    @State private var message: String? = nil

    private var species: Species { Species.all[current] }

    var body: some View {
        GeometryReader { geo in
            let h = geo.size.height

            HStack(spacing: 0) {

                // ─── Инфо (слева) ────────────────────────────
                VStack(alignment: .leading, spacing: 8) {
                    Text("ОПРЕДЕЛИТЕЛЬ")
                        .font(.system(size: 9, weight: .bold))
                        .tracking(1.2)
                        .foregroundColor(Palette.textDim)

                    Text(species.emoji)
                        .font(.system(size: 48))

                    Text(species.name)
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(Palette.textPrimary)
                        .lineLimit(2)

                    Text(species.hint)
                        .font(.system(size: 10))
                        .foregroundColor(Palette.textSecondary)
                        .lineLimit(3)

                    Spacer()

                    Text("Перетащи таксоны в правильном порядке — от большего к меньшему.")
                        .font(.system(size: 9))
                        .foregroundColor(Palette.textDim)
                        .lineLimit(4)
                }
                .padding(14)
                .frame(width: 180)
                .background(Palette.surface.opacity(0.4))

                // ─── Слоты (центр) ──────────────────────────
                VStack(spacing: 4) {

                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 4) {
                            ForEach(0..<species.chain.count, id: \.self) { i in
                                HStack(spacing: 6) {
                                    Text(species.chain[i].0)
                                        .font(.system(size: 9, weight: .bold))
                                        .foregroundColor(Palette.textDim)
                                        .frame(width: 75, alignment: .leading)

                                    ZStack {
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(slots.isEmpty || slots[i] == nil
                                                  ? Palette.surface
                                                  : Palette.green.opacity(0.2))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 6)
                                                    .stroke(
                                                        slots.isEmpty || slots[i] == nil
                                                            ? Palette.stroke : Palette.green,
                                                        lineWidth: slots.isEmpty || slots[i] == nil ? 1 : 1.4
                                                    )
                                            )

                                        if !slots.isEmpty, let s = slots[i] {
                                            Text(s)
                                                .font(.system(size: 12, weight: .semibold))
                                                .foregroundColor(Palette.textPrimary)
                                        } else {
                                            Text("перетащи")
                                                .font(.system(size: 10))
                                                .foregroundColor(Palette.textDim)
                                        }
                                    }
                                    .frame(height: 30)
                                    .onDrop(of: [.text], isTargeted: nil) { providers in
                                        handleDrop(providers, at: i)
                                        return true
                                    }
                                }
                                .padding(.horizontal, 14)
                            }
                        }
                    }

                    // Пул
                    HStack(spacing: 6) {
                        ForEach(pool, id: \.self) { p in
                            Text(p)
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(Palette.textPrimary)
                                .padding(.horizontal, 10).padding(.vertical, 6)
                                .background(Palette.surfaceHi)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Palette.stroke, lineWidth: 1)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .onDrag { NSItemProvider(object: p as NSString) }
                        }
                    }
                    .padding(.horizontal, 14)
                    .frame(height: 40)

                    // Кнопки
                    HStack(spacing: 10) {
                        Button("Проверить") { check() }
                            .buttonStyle(PrimaryButton())
                        Button("Дальше") { next() }
                            .buttonStyle(SecondaryButton())
                    }
                    .padding(.bottom, 6)

                    if let msg = message {
                        Text(msg)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(msg.hasPrefix("Правильно") ? Palette.green : Palette.danger)
                            .padding(.bottom, 4)
                    }
                }
                .frame(maxWidth: .infinity)
            }
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
                if slots.indices.contains(index), let oldIdx = slots.firstIndex(where: { $0 == text }) {
                    slots[oldIdx] = nil
                }
                if slots.indices.contains(index) {
                    slots[index] = text
                    pool.removeAll { $0 == text }
                }
            }
        }
    }

    private func check() {
        let correct = species.chain.map { $0.1 }
        message = slots == correct ? "Правильно! ✓" : "Не совсем. Попробуй ещё."
    }

    private func next() {
        current = (current + 1) % Species.all.count
        loadSpecies()
    }
}
