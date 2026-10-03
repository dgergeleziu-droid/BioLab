import SwiftUI

struct SplashView: View {

    let onFinish: () -> Void

    @State private var scale: CGFloat = 0.6
    @State private var opacity: Double = 0
    @State private var glow: Double = 0.3
    @State private var rotate: Double = 0

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Palette.background, Palette.backgroundHi],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            Circle()
                .fill(Palette.green.opacity(glow * 0.3))
                .frame(width: 340, height: 340)
                .blur(radius: 100)

            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .stroke(Palette.green.opacity(0.4), lineWidth: 2)
                        .frame(width: 130, height: 130)
                    Circle()
                        .trim(from: 0, to: 0.35)
                        .stroke(Palette.greenLight,
                                style: StrokeStyle(lineWidth: 3, lineCap: .round))
                        .frame(width: 150, height: 150)
                        .rotationEffect(.degrees(rotate))

                    Image(systemName: "leaf.fill")
                        .font(.system(size: 54, weight: .bold))
                        .foregroundColor(Palette.green)
                }

                VStack(spacing: 10) {
                    Text("BioLab")
                        .font(.system(size: 54, weight: .heavy, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Palette.greenLight, Palette.green, Palette.greenDark],
                                startPoint: .top, endPoint: .bottom
                            )
                        )
                        .shadow(color: Palette.green.opacity(0.5), radius: 20)

                    VStack(spacing: 3) {
                        HStack(spacing: 5) {
                            Text("Для любимой Анютки")
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
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
                            .foregroundColor(Palette.textSecondary)
                    }
                    .padding(.top, 4)
                }
            }
            .scaleEffect(scale)
            .opacity(opacity)
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                scale = 1.0
                opacity = 1.0
            }
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                glow = 1.0
            }
            withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
                rotate = 360
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                onFinish()
            }
        }
    }
}
