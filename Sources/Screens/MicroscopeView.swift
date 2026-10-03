import SwiftUI

struct MicroscopeView: View {

    @State private var selectedSample: BioSample?
    @State private var selectedDye: Dye?
    @State private var observation: Observation?
    @State private var showNoResult = false

    var body: some View {
        HStack(spacing: 0) {

            // ─── Панель образцов (слева) ─────────────────────
            VStack(alignment: .leading, spacing: 8) {
                Text("ОБРАЗЦЫ")
                    .font(.system(size: 11, weight: .bold))
                    .tracking(1.5)
                    .foregroundColor(Palette.textDim)
                    .padding(.horizontal, 14)

                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(BioSample.all) { s in
                            ReagentChip(
                                emoji: s.emoji,
                                title: s.name,
                                color: s.color,
                                isSelected: selectedSample?.id == s.id
                            ) {
                                withAnimation {
                                    selectedSample = (selectedSample?.id == s.id) ? nil : s
                                    observation = nil
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.bottom, 14)
                }
            }
            .frame(width: 200)
            .background(Palette.surface.opacity(0.4))

            // ─── Линза микроскопа (центр) ────────────────────
            ZStack {
                // Круглая линза
                Circle()
                    .fill(Palette.surfaceHi)
                    .frame(width: 340, height: 340)
                    .overlay(Circle().stroke(Palette.stroke, lineWidth: 2))
                    .shadow(color: Palette.green.opacity(0.3), radius: 30)

                Circle()
                    .fill(Palette.background)
                    .frame(width: 300, height: 300)
                    .overlay(Circle().stroke(Palette.green.opacity(0.5), lineWidth: 2))

                // Содержимое линзы
                MicroLensContent(sample: selectedSample, dye: selectedDye, result: observation)
                    .frame(width: 290, height: 290)
                    .clipShape(Circle())

                // Блик
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.white.opacity(0.15), .clear],
                            startPoint: .topLeading, endPoint: .center
                        )
                    )
                    .frame(width: 290, height: 290)
                    .allowsHitTesting(false)

                // Подпись
                VStack {
                    Spacer().frame(height: 380)
                    if let s = selectedSample {
                        Text(s.name)
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundColor(Palette.textPrimary)
                        if let o = observation {
                            Text(o.result)
                                .font(.system(size: 12))
                                .foregroundColor(Palette.greenLight)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 30)
                        }
                    } else {
                        Text("Выберите образец")
                            .font(.system(size: 13))
                            .foregroundColor(Palette.textDim)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // ─── Панель красителей (справа) ──────────────────
            VStack(alignment: .leading, spacing: 8) {
                Text("КРАСИТЕЛИ")
                    .font(.system(size: 11, weight: .bold))
                    .tracking(1.5)
                    .foregroundColor(Palette.textDim)
                    .padding(.horizontal, 14)

                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(Dye.all) { d in
                            ReagentChip(
                                emoji: d.emoji,
                                title: d.name,
                                color: d.color,
                                isSelected: selectedDye?.id == d.id
                            ) {
                                withAnimation {
                                    selectedDye = (selectedDye?.id == d.id) ? nil : d
                                    checkObservation()
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.bottom, 14)
                }

                // Кнопка "Сбросить"
                Button {
                    withAnimation {
                        selectedSample = nil
                        selectedDye = nil
                        observation = nil
                    }
                } label: {
                    HStack {
                        Image(systemName: "arrow.counterclockwise")
                        Text("Сбросить")
                    }
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Palette.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Palette.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10).stroke(Palette.stroke, lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.horizontal, 14)
                .padding(.bottom, 14)
            }
            .frame(width: 200)
            .background(Palette.surface.opacity(0.4))
        }
        .alert("Реакция не найдена", isPresented: $showNoResult) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Попробуйте другой краситель или образец.")
        }
    }

    private func checkObservation() {
        guard let s = selectedSample, let d = selectedDye else { return }
        if let found = Observation.find(sample: s.name, dye: d.name) {
            observation = found
        } else {
            observation = nil
            showNoResult = true
        }
    }
}

// ─── Что показывается в линзе ─────────────────────────────────

private struct MicroLensContent: View {
    let sample: BioSample?
    let dye: Dye?
    let result: Observation?

    var body: some View {
        ZStack {
            Circle().fill(sample?.color.opacity(0.10) ?? Color.clear)

            if let s = sample {
                let count = 12
                ForEach(0..<count, id: \.self) { i in
                    let row = i / 4
                    let col = i % 4
                    let step: CGFloat = 60
                    let x = step * CGFloat(col) + step * 0.5 - 120
                    let y = step * CGFloat(row) + step * 0.5 - 90

                    CellView(
                        baseColor: s.color,
                        dyeColor: result?.effect == .blue ? Color.blue :
                                  result?.effect == .red  ? Color.red  :
                                  result?.effect == .purple ? Color.purple :
                                  result?.effect == .green ? Palette.chloro : nil,
                        size: 52
                    )
                    .offset(x: x, y: y)
                }
            }
        }
    }
}

private struct CellView: View {
    let baseColor: Color
    let dyeColor: Color?
    let size: CGFloat

    var body: some View {
        ZStack {
            // Мембрана
            Circle()
                .fill(baseColor.opacity(0.55))
                .overlay(Circle().stroke(baseColor.opacity(0.9), lineWidth: 1.2))
                .frame(width: size, height: size)

            // Ядро — если есть краситель
            if let dye = dyeColor {
                Circle()
                    .fill(dye.opacity(0.85))
                    .frame(width: size * 0.32, height: size * 0.32)
                    .shadow(color: dye.opacity(0.7), radius: 6)
            }
        }
    }
}
