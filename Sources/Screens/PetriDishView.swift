import SwiftUI

struct PetriDishView: View {

    @State private var selected: Bacterium = Bacterium.all[0]
    @State private var colonies: [Colony] = []
    @State private var antibiotic: Bool = false
    @State private var timer: Timer?
    @State private var elapsed: Double = 0

    var body: some View {
        GeometryReader { geo in
            let h = geo.size.height
            let dishSize = min(h - 30, 300)

            HStack(spacing: 0) {

                // ─── Бактерии (слева) ───────────────────────
                VStack(alignment: .leading, spacing: 4) {
                    Text("БАКТЕРИИ")
                        .font(.system(size: 9, weight: .bold))
                        .tracking(1.2)
                        .foregroundColor(Palette.textDim)
                        .padding(.horizontal, 10)
                        .padding(.top, 6)

                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 8) {
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
                        .padding(.horizontal, 6)
                        .padding(.bottom, 10)
                    }
                }
                .frame(width: 150)
                .background(Palette.surface.opacity(0.4))

                // ─── Чашка (центр) ─────────────────────────
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Palette.surfaceHi.opacity(0.6),
                                         Palette.background.opacity(0.9)],
                                center: .center, startRadius: 20, endRadius: dishSize / 2
                            )
                        )
                        .frame(width: dishSize, height: dishSize)
                        .overlay(Circle().stroke(Palette.green.opacity(0.35), lineWidth: 2.5))
                        .shadow(color: Palette.green.opacity(0.2), radius: 20)

                    Circle()
                        .fill(Color(hex: "#F5DEB3").opacity(0.15))
                        .frame(width: dishSize - 30, height: dishSize - 30)

                    ForEach(colonies) { c in
                        ColonyView(colony: c)
                    }

                    if antibiotic {
                        Circle()
                            .fill(Color.blue.opacity(0.10))
                            .frame(width: dishSize * 0.55, height: dishSize * 0.55)
                            .overlay(Circle().stroke(Color.blue.opacity(0.4), lineWidth: 1))
                        Text("Антибиотик")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(.blue.opacity(0.8))
                            .offset(y: dishSize * 0.30)
                    }

                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.10), .clear],
                                startPoint: .topLeading, endPoint: .center
                            )
                        )
                        .frame(width: dishSize, height: dishSize)
                        .allowsHitTesting(false)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                // ─── Управление (справа) ───────────────────
                VStack(alignment: .leading, spacing: 8) {
                    Text("УПРАВЛЕНИЕ")
                        .font(.system(size: 9, weight: .bold))
                        .tracking(1.2)
                        .foregroundColor(Palette.textDim)

                    HStack(spacing: 10) {
                        VStack(alignment: .leading, spacing: 1) {
                            Text("Время")
                                .font(.system(size: 9))
                                .foregroundColor(Palette.textDim)
                            Text("\(Int(elapsed)) с")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(Palette.textPrimary)
                        }
                        VStack(alignment: .leading, spacing: 1) {
                            Text("Колоний")
                                .font(.system(size: 9))
                                .foregroundColor(Palette.textDim)
                            Text("\(colonies.count)")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(Palette.green)
                        }
                    }

                    Button {
                        seedColony()
                    } label: {
                        Label("Посеять", systemImage: "leaf.fill")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(Palette.green)
                            .clipShape(Capsule())
                    }

                    Button {
                        withAnimation {
                            antibiotic.toggle()
                            killSensitive()
                        }
                    } label: {
                        Label(antibiotic ? "Убрать" : "Антибиотик",
                              systemImage: "pills.fill")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(antibiotic ? .white : Palette.textSecondary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
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
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(Palette.danger)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(Palette.surface)
                            .overlay(Capsule().stroke(Palette.stroke, lineWidth: 1))
                            .clipShape(Capsule())
                    }

                    Spacer()

                    Text("Добавь антибиотик — устойчивые выживут.")
                        .font(.system(size: 9))
                        .foregroundColor(Palette.textDim)
                        .lineLimit(3)
                }
                .padding(14)
                .frame(width: 180)
                .background(Palette.surface.opacity(0.4))
            }
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
            x: CGFloat.random(in: -90...90),
            y: CGFloat.random(in: -90...90),
            size: 6
        )
        withAnimation { colonies.append(c) }
    }

    private func growColonies() {
        for i in colonies.indices {
            colonies[i].size = min(colonies[i].size + 0.6 * selected.growthRate, 32)
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
        Circle()
            .fill(colony.bacterium.color.opacity(0.7))
            .overlay(Circle().stroke(colony.bacterium.color, lineWidth: 1.2))
            .frame(width: colony.size, height: colony.size)
            .shadow(color: colony.bacterium.color.opacity(0.5), radius: 4)
            .offset(x: colony.x, y: colony.y)
            .animation(.easeOut(duration: 0.5), value: colony.size)
    }
}
