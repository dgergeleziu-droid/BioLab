import SwiftUI

/// Красивая сфера-чип для образцов, красителей, реагентов
struct ReagentChip: View {

    let emoji: String
    let title: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void

    @State private var pressed = false

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [color, color.opacity(0.7)],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 54, height: 54)
                        .overlay(
                            Circle().stroke(
                                isSelected ? Palette.greenLight : Color.black.opacity(0.25),
                                lineWidth: isSelected ? 2.5 : 1
                            )
                        )
                        .shadow(color: color.opacity(0.5), radius: 8, y: 4)

                    // Верхний блик
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.55), .clear],
                                startPoint: .top, endPoint: .center
                            )
                        )
                        .frame(width: 24, height: 18)
                        .offset(x: -8, y: -12)

                    Text(emoji)
                        .font(.system(size: 24))
                        .shadow(color: .black.opacity(0.3), radius: 1, y: 1)
                }

                Text(title)
                    .font(.system(size: 10, weight: .medium, design: .rounded))
                    .foregroundColor(isSelected ? Palette.textPrimary : Palette.textSecondary)
                    .lineLimit(1)
                    .frame(maxWidth: 70)
            }
        }
        .buttonStyle(.plain)
        .scaleEffect(pressed ? 0.9 : 1.0)
        .animation(.spring(response: 0.2, dampingFraction: 0.7), value: pressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in pressed = true }
                .onEnded   { _ in pressed = false }
        )
    }
}
