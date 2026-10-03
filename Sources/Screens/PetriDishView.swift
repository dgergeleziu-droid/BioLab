import SwiftUI

/// Чашка Петри — растим колонии бактерий, добавляем антибиотик
struct PetriDishView: View {

    @State private var selected: Bacterium = Bacterium.all[0]
    @State private var colonies: [Colony] = []
    @State private var antibiotic: Bool = false
    @State private var timer: Timer?
    @State private var elapsed: Double = 0

    var body: some View {
        HStack(spacing: 0) {

            // ─── Панель бактерий ─────────────────────────────
            VStack(alignment: .leading, spacing: 8) {
                Text("БАКТЕРИИ")
                    .font(.system(size: 11, weight: .bold))
                    .tracking(1.5)
                    .foregroundColor(Palette.textDim)
                    .padding(.horizontal, 14)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 10) {
                        ForEach(Bacterium.all) { b in
                            ReagentChip(
                                emoji: "🦠",
                                title: b.name,
                                color: b.color,
                                isSelected: selected.id == b.id
                            ) {
                                selected = b
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.bottom, 14)
                }
            }
            .frame(width: 180)
            .background(Palette.surface.opacity(0.4))

            // ─── Чашка Петри ─────────────────────────────────
            ZStack {
                // Стеклянная чашка
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Palette.surfaceHi.opacity(0.6), Palette.background.opacity(0.9)],
                            center: .center, startRadius: 20, endRadius: 200
                        )
                    )
                    .frame(width: 400, height: 400)
                    .overlay(Circle().stroke(Palette.green.opacity(0.35), lineWidth: 3))
                    .shadow(color: Palette.green.opacity(0.2), radius: 25)

                // Агар
                Circle()
                    .fill(Color(hex: "#F5DEB3").opacity(0.15))
                    .frame(width: 360, height: 360)

                // Колонии
                ForEach(colonies) { c in
                    ColonyView(colony: c)
                }

                // Антибиотик — синяя зона
                if antibiotic {
                    Circle()
                        .fill(Color.blue.opacity(0.10))
                        .frame(width: 200, height: 200)
                        .overlay(Circle().stroke(Color.blue.opacity(0.4), lineWidth: 1))
                    Text("Антибиотик")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.blue.opacity(0.8))
                        .offset(y: 110)
                }

                // Блик
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.white.opacity(0.10), .clear],
                            startPoint: .topLeading, endPoint: .center
                        )
                    )
                    .frame(width: 400, height: 400)
                    .allowsHitTesting(false)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // ─── Управление ──────────────────────────────────
            VStack(alignment: .leading, spacing: 14) {
                Text("УПРАВЛЕНИЕ")
                    .font(.system(size: 11, weight: .bold))
                    .tracking(1.5)
                    .foregroundColor(Palette.textDim)

                Text("Время: \(Int(elapsed)) с")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Palette.textPrimary)

                Text("Колоний: \(colonies.count)")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Palette.green)

                Button {
                    seedColony()
                } label: {
                    Label("Посеять", systemImage: "leaf.fill")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Palette.green)
                        .clipShape(Capsule())
                }

                Button {
                    withAnimation {
                        antibiotic.toggle()
                        killSensitive()
                    }
                } label: {
                    Label(antibiotic ? "Убрать антибиотик" : "Антибиотик",
                          systemImage: "pills.fill")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(antibiotic ? .white : Palette.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(antibiotic ? Color.blue : Palette.surface)
                        .overlay(
                            Capsule().stroke(Palette.stroke, lineWidth: antibiotic ? 0 : 1)
                        )
                        .clipShape(Capsule())
                }

                Button {
                    withAnimation {
                        colonies.removeAll()
                        elapsed = 0
                    }
                } label: {
                    Text("Очистить")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Palette.danger)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Palette.surface)
                        .overlay(
                            Capsule().stroke(Palette.stroke, lineWidth: 1)
                        )
                        .clipShape(Capsule())
                }

                Spacer()

                Text("Наблюдай, как растут бактерии. Добавь антибиотик — устойчивые выживут.")
                    .font(.system(size: 10))
                    .foregroundColor(Palette.textDim)
            }
            .padding(20)
            .frame(width: 220)
            .background(Palette.surface.opacity(0.4))
        }
        .onAppear { startTimer() }
        .onDisappear { timer?.invalidate() }
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            elapsed += 0.5
            growColonies()
        }
    }

    private func seedColony() {
        let c = Colony(
            bacterium: selected,
            x: CGFloat.random(in: -120...120),
            y: CGFloat.random(in: -120...120),
            size: 8
        )
        withAnimation { colonies.append(c) }
    }

    private func growColonies() {
        for i in colonies.indices {
            colonies[i].size = min(colonies[i].size + 0.8 * selected.growthRate, 42)
        }
    }

    private func killSensitive() {
        guard antibiotic else { return }
        colonies.removeAll { $0.bacterium.resistance < 2 }
    }
}

struct Colony: Identifiable {
    let id = UUID()
    let bacterium: Bacterium
    let x: CGFloat
    let y: CGFloat
    var size: CGFloat
}

private struct ColonyView: View {
    let colony: Colony

    var body: some View {
        ZStack {
            Circle()
                .fill(colony.bacterium.color.opacity(0.7))
                .overlay(Circle().stroke(colony.bacterium.color, lineWidth: 1.5))
                .frame(width: colony.size, height: colony.size)
                .shadow(color: colony.bacterium.color.opacity(0.5), radius: 6)
        }
        .offset(x: colony.x, y: colony.y)
        .animation(.easeOut(duration: 0.5), value: colony.size)
    }
}
