import SwiftUI

struct MicroscopeView: View {

    @State private var selectedSample: BioSample?
    @State private var selectedDye: Dye?
    @State private var observation: Observation?
    @State private var showNoResult = false

    var body: some View {
        GeometryReader { geo in
            let h = geo.size.height
            let lensSize = min(h - 50, 300)

            HStack(spacing: 0) {

                // ─── Образцы (слева) ────────────────────────
                sidePanel(title: "ОБРАЗЦЫ") {
                    LazyVGrid(
                        columns: [GridItem(.flexible()), GridItem(.flexible())],
                        spacing: 8
                    ) {
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
                    .padding(.horizontal, 8)
                }

                // ─── Центр — линза ──────────────────────────
                VStack(spacing: 8) {
                    Spacer()

                    ZStack {
                        Circle()
                            .fill(Palette.surfaceHi)
                            .frame(width: lensSize, height: lensSize)
                            .overlay(Circle().stroke(Palette.stroke, lineWidth: 2))
                            .shadow(color: Palette.green.opacity(0.3), radius: 20)

                        Circle()
                            .fill(Palette.background)
                            .frame(width: lensSize - 30, height: lensSize - 30)
                            .overlay(Circle().stroke(Palette.green.opacity(0.5), lineWidth: 2))

                        MicroLensContent(
                            sample: selectedSample,
                            dye: selectedDye,
                            result: observation
                        )
                        .frame(width: lensSize - 38, height: lensSize - 38)
                        .clipShape(Circle())

                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.15), .clear],
                                    startPoint: .topLeading, endPoint: .center
                                )
                            )
                            .frame(width: lensSize - 38, height: lensSize - 38)
                            .allowsHitTesting(false)
                    }

                    // Подпись под линзой
                    VStack(spacing: 2) {
                        if let s = selectedSample {
                            Text(s.name)
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                                .foregroundColor(Palette.textPrimary)
                            if let o = observation {
                                Text(o.result)
                                    .font(.system(size: 10))
                                    .foregroundColor(Palette.greenLight)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                                    .padding(.horizontal, 20)
                            }
                        } else {
                            Text("Выбери образец и краситель")
                                .font(.system(size: 11))
                                .foregroundColor(Palette.textDim)
                        }
                    }
                    .frame(height: 32)

                    Spacer()
                }
                .frame(maxWidth: .infinity)

                // ─── Красители (справа) ─────────────────────
                sidePanel(title: "КРАСИТЕЛИ") {
                    LazyVGrid(
                        columns: [GridItem(.flexible()), GridItem(.flexible())],
                        spacing: 8
                    ) {
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
                    .padding(.horizontal, 8)

                    // Сброс
                    Button {
                        withAnimation {
                            selectedSample = nil
                            selectedDye = nil
                            observation = nil
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.counterclockwise")
                                .font(.system(size: 10))
                            Text("Сбросить")
                                .font(.system(size: 11, weight: .semibold))
                        }
                        .foregroundColor(Palette.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Palette.surface)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Palette.stroke, lineWidth: 1)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .padding(.horizontal, 8)
                    .padding(.bottom, 8)
                }
            }
        }
        .alert("Реакция не найдена", isPresented: $showNoResult) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Попробуй другой краситель или образец.")
        }
    }

    @ViewBuilder
    private func sidePanel<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 9, weight: .bold))
                .tracking(1.2)
                .foregroundColor(Palette.textDim)
                .padding(.horizontal, 10)
                .padding(.top, 6)

            ScrollView(showsIndicators: false) {
                content()
                    .padding(.bottom, 8)
            }
        }
        .frame(width: 170)
        .background(Palette.surface.opacity(0.4))
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

private struct MicroLensContent: View {
    let sample: BioSample?
    let dye: Dye?
    let result: Observation?

    var body: some View {
        GeometryReader { geo in
            let side = geo.size.width
            ZStack {
                Circle().fill(sample?.color.opacity(0.10) ?? Color.clear)

                if let s = sample {
                    let grid = 4
                    let step = side / CGFloat(grid)

                    ForEach(0..<(grid * grid), id: \.self) { i in
                        let row = i / grid
                        let col = i % grid
                        let x = step * CGFloat(col) + step * 0.5 - side / 2
                        let y = step * CGFloat(row) + step * 0.5 - side / 2

                        CellView(
                            baseColor: s.color,
                            dyeColor: dyeColorFrom(result),
                            size: step * 0.7
                        )
                        .offset(x: x, y: y)
                    }
                }
            }
        }
    }

    private func dyeColorFrom(_ r: Observation?) -> Color? {
        guard let e = r?.effect else { return nil }
        switch e {
        case .blue:   return Color.blue
        case .red:    return Color.red
        case .purple: return Color.purple
        case .green:  return Palette.chloro
        case .gold:   return Palette.gold
        }
    }
}

private struct CellView: View {
    let baseColor: Color
    let dyeColor: Color?
    let size: CGFloat

    var body: some View {
        ZStack {
            Circle()
                .fill(baseColor.opacity(0.55))
                .overlay(Circle().stroke(baseColor.opacity(0.9), lineWidth: 1))
                .frame(width: size, height: size)

            if let dye = dyeColor {
                Circle()
                    .fill(dye.opacity(0.85))
                    .frame(width: size * 0.32, height: size * 0.32)
                    .shadow(color: dye.opacity(0.7), radius: 4)
            }
        }
    }
}
