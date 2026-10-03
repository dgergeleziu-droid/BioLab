import SwiftUI

struct DNAView: View {

    @State private var rotate: Double = 0
    @State private var selectedBase: String?

    private let bases: [(String, Color)] = [
        ("A", Color(hex: "#F87171")),
        ("T", Color(hex: "#FBBF24")),
        ("G", Color(hex: "#34D399")),
        ("C", Color(hex: "#60A5FA")),
    ]

    private let pairs: [(String, String)] = [
        ("A", "T"), ("G", "C"), ("T", "A"), ("C", "G"),
        ("A", "T"), ("G", "C"), ("C", "G"), ("T", "A"),
    ]

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Palette.background, Palette.backgroundHi],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {

                Text("Double Helix")
                    .font(.system(size: 24, weight: .heavy, design: .rounded))
                    .foregroundColor(Palette.textPrimary)
                    .padding(.top, 10)

                Text("The code of life — 4 bases, infinite variety")
                    .font(.system(size: 12))
                    .foregroundColor(Palette.textSecondary)
                    .padding(.top, 2)

                Spacer().frame(height: 24)

                ZStack {
                    ForEach(0..<pairs.count, id: \.self) { i in
                        let phase = Double(i) * .pi / 2.5
                        let y: CGFloat = CGFloat(i) * 42 - CGFloat(pairs.count - 1) * 21
                        let a = pairs[i].0
                        let b = pairs[i].1
                        DNAPairRow(
                            topBase: a,
                            bottomBase: b,
                            topColor: colorFor(a),
                            bottomColor: colorFor(b),
                            phase: phase,
                            selectedBase: selectedBase,
                            onTap: { base in
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedBase = (selectedBase == base) ? nil : base
                                }
                            }
                        )
                        .offset(y: y)
                    }
                }
                .frame(height: 500)
                .rotationEffect(.degrees(rotate))

                Spacer()

                if let base = selectedBase {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 10) {
                            Circle().fill(colorFor(base)).frame(width: 12, height: 12)
                            Text(fullName(for: base))
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(Palette.textPrimary)
                        }
                        Text(description(for: base))
                            .font(.system(size: 13))
                            .foregroundColor(Palette.textSecondary)
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Palette.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(colorFor(base).opacity(0.4), lineWidth: 1.5)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                } else {
                    Text("Tap a base to learn about it")
                        .font(.system(size: 13))
                        .foregroundColor(Palette.textDim)
                        .padding(.bottom, 34)
                }
            }
        }
        .navigationTitle("DNA")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            withAnimation(.linear(duration: 14).repeatForever(autoreverses: false)) {
                rotate = 360
            }
        }
    }

    private func colorFor(_ base: String) -> Color {
        bases.first { $0.0 == base }?.1 ?? .white
    }

    private func fullName(for b: String) -> String {
        switch b {
        case "A": return "Adenine"
        case "T": return "Thymine"
        case "G": return "Guanine"
        case "C": return "Cytosine"
        default:  return b
        }
    }

    private func description(for b: String) -> String {
        switch b {
        case "A": return "Pairs with Thymine (T). One of the two purines."
        case "T": return "Pairs with Adenine (A). Only found in DNA."
        case "G": return "Pairs with Cytosine (C). Purine base."
        case "C": return "Pairs with Guanine (G). Pyrimidine base."
        default:  return ""
        }
    }
}

private struct DNAPairRow: View {
    let topBase: String
    let bottomBase: String
    let topColor: Color
    let bottomColor: Color
    let phase: Double
    let selectedBase: String?
    let onTap: (String) -> Void

    var body: some View {
        let sinPhase = CGFloat(sin(phase))
        let xOffset: CGFloat = sinPhase * 40

        HStack(spacing: 4) {
            BaseBadge(base: topBase, color: topColor,
                      isSelected: selectedBase == topBase)
                .offset(x: xOffset)
                .onTapGesture { onTap(topBase) }

            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [topColor.opacity(0.7), bottomColor.opacity(0.7)],
                        startPoint: .leading, endPoint: .trailing
                    )
                )
                .frame(width: 46, height: 3)
                .opacity(abs(sinPhase) > 0.15 ? 1 : 0.3)

            BaseBadge(base: bottomBase, color: bottomColor,
                      isSelected: selectedBase == bottomBase)
                .offset(x: -xOffset)
                .onTapGesture { onTap(bottomBase) }
        }
        .frame(height: 44)
    }
}

private struct BaseBadge: View {
    let base: String
    let color: Color
    let isSelected: Bool

    var body: some View {
        ZStack {
            Circle()
                .fill(color.opacity(0.85))
                .overlay(Circle().stroke(color, lineWidth: isSelected ? 3 : 1.5))
                .frame(width: isSelected ? 40 : 34,
                       height: isSelected ? 40 : 34)
                .shadow(color: color.opacity(isSelected ? 0.8 : 0.3),
                        radius: isSelected ? 16 : 4)

            Text(base)
                .font(.system(size: 15, weight: .heavy, design: .rounded))
                .foregroundColor(.white)
        }
        .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isSelected)
    }
}
