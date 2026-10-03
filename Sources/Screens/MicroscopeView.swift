import SwiftUI

struct MicroscopeView: View {

    @State private var selected: Specimen = Specimen.all[0]
    @State private var zoom: CGFloat = 1.0
    @State private var glowPulse = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Palette.background, Palette.backgroundHi],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {

                ZStack {
                    Circle()
                        .fill(Palette.surfaceHi)
                        .frame(width: 310, height: 310)
                        .overlay(Circle().stroke(Palette.stroke, lineWidth: 2))
                        .shadow(color: Palette.green.opacity(0.35), radius: 30)

                    Circle()
                        .fill(Palette.background)
                        .frame(width: 270, height: 270)
                        .overlay(
                            Circle()
                                .stroke(selected.tint.opacity(glowPulse ? 0.75 : 0.4),
                                        lineWidth: 2)
                        )

                    SpecimenCanvas(specimen: selected, zoom: zoom)
                        .frame(width: 260, height: 260)
                        .clipShape(Circle())

                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.18), .clear],
                                startPoint: .topLeading, endPoint: .center
                            )
                        )
                        .frame(width: 260, height: 260)
                        .blendMode(.screen)
                        .allowsHitTesting(false)
                }
                .padding(.top, 30)

                VStack(spacing: 4) {
                    Text(selected.name)
                        .font(.system(size: 22, weight: .heavy, design: .rounded))
                        .foregroundColor(Palette.textPrimary)
                    Text("×\(Int(zoom * 100))  magnification")
                        .font(.system(size: 12))
                        .foregroundColor(Palette.green)
                }
                .padding(.top, 22)

                HStack(spacing: 14) {
                    Image(systemName: "minus.magnifyingglass")
                        .foregroundColor(Palette.textSecondary)
                    Slider(value: $zoom, in: 0.8...1.6)
                        .tint(Palette.green)
                    Image(systemName: "plus.magnifyingglass")
                        .foregroundColor(Palette.textSecondary)
                }
                .padding(.horizontal, 30)
                .padding(.top, 14)

                Spacer()

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(Specimen.all) { s in
                            SpecimenChip(specimen: s, isSelected: s.id == selected.id) {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                                    selected = s
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 24)
            }
        }
        .navigationTitle("Microscope")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true)) {
                glowPulse = true
            }
        }
    }
}

private struct SpecimenCanvas: View {
    let specimen: Specimen
    let zoom: CGFloat

    var body: some View {
        ZStack {
            Circle().fill(specimen.cellColor.opacity(0.08))

            ForEach(0..<specimen.cells, id: \.self) { i in
                let row = i / specimen.grid
                let col = i % specimen.grid
                let step: CGFloat = 260 / CGFloat(specimen.grid)
                let x = step * CGFloat(col) + step * 0.5 - 130
                let y = step * CGFloat(row) + step * 0.5 - 130

                CellUnderLens(color: specimen.cellColor,
                              size: step * 0.85 * zoom)
                .offset(x: x, y: y)
            }
        }
    }
}

private struct CellUnderLens: View {
    let color: Color
    let size: CGFloat

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.22)
                .fill(color.opacity(0.55))
                .overlay(
                    RoundedRectangle(cornerRadius: size * 0.22)
                        .stroke(color, lineWidth: 1.2)
                )
            Circle()
                .fill(color.opacity(0.9))
                .frame(width: size * 0.32, height: size * 0.32)
                .offset(x: size * 0.05, y: -size * 0.05)
        }
        .frame(width: size, height: size)
    }
}

private struct SpecimenChip: View {
    let specimen: Specimen
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Text(specimen.emoji).font(.system(size: 28))
                Text(specimen.name)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(isSelected ? Palette.textPrimary : Palette.textSecondary)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 14)
            .background(isSelected ? Palette.surfaceHi : Palette.surface)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? specimen.tint : Palette.stroke, lineWidth: 1.5)
            )
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }
}
