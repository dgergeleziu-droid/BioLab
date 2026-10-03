import SwiftUI

/// Персональная подпись — для любимой Анютки от Демьяна.
/// Используется в шапке главного экрана.
struct MDLogo: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 6) {
                Text("Для любимой Анютки")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Palette.greenLight, Palette.green],
                            startPoint: .leading, endPoint: .trailing
                        )
                    )

                Image(systemName: "heart.fill")
                    .font(.system(size: 11))
                    .foregroundColor(Color(hex: "#F472B6"))
            }

            Text("от Демьяна")
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundColor(Palette.textDim)
                .padding(.leading, 1)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Для любимой Анютки от Демьяна")
    }
}
