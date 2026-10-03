import SwiftUI

struct ModuleCard: View {

    let module: BioModule
    let action: () -> Void

    @State private var pressed = false

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                ZStack {
                    Circle()
                        .fill(module.tint.opacity(0.18))
                        .frame(width: 56, height: 56)
                    Image(systemName: module.icon)
                        .font(.system(size: 26, weight: .semibold))
                        .foregroundColor(module.tint)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(module.rawValue)
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundColor(Palette.textPrimary)
                    Text(module.subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(Palette.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(Palette.surface)
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(module.tint.opacity(0.35), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .shadow(color: module.tint.opacity(0.10), radius: 14, y: 6)
        }
        .buttonStyle(.plain)
        .scaleEffect(pressed ? 0.97 : 1.0)
        .animation(.spring(response: 0.25, dampingFraction: 0.7), value: pressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in pressed = true }
                .onEnded   { _ in pressed = false }
        )
    }
}
