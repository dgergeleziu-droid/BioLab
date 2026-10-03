import SwiftUI

enum BioMode: String, CaseIterable, Identifiable {
    case microscope = "Микроскоп"
    case exam       = "ОГЭ"
    case classifier = "Определитель"
    case petri      = "Чашка Петри"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .microscope: return "eye.fill"
        case .exam:       return "doc.text.fill"
        case .classifier: return "list.bullet.indent"
        case .petri:      return "circle.grid.cross.fill"
        }
    }
}

struct ContentView: View {

    @State private var mode: BioMode = .microscope
    @State private var showMenu = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Palette.background, Palette.backgroundHi],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {

                // ─── Верхняя панель (компактная) ────────────────
                HStack(spacing: 8) {
                    // Подпись слева — сжатая
                    VStack(alignment: .leading, spacing: 1) {
                        HStack(spacing: 4) {
                            Text("Для любимой Анютки")
                                .font(.system(size: 11, weight: .semibold, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Palette.greenLight, Palette.green],
                                        startPoint: .leading, endPoint: .trailing
                                    )
                                )
                            Image(systemName: "heart.fill")
                                .font(.system(size: 9))
                                .foregroundColor(Color(hex: "#F472B6"))
                        }
                        Text("от Демьяна")
                            .font(.system(size: 9, weight: .medium, design: .rounded))
                            .foregroundColor(Palette.textDim)
                    }

                    Spacer()

                    // Табы режимов — компактные
                    HStack(spacing: 4) {
                        ForEach(BioMode.allCases) { m in
                            ModeTab(mode: m, isActive: mode == m) {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    mode = m
                                }
                            }
                        }
                    }

                    Spacer()

                    // Меню
                    Button {
                        showMenu = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Palette.green)
                            .frame(width: 32, height: 32)
                            .background(Palette.surface)
                            .overlay(Circle().stroke(Palette.stroke, lineWidth: 1))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background(Palette.background.opacity(0.9))

                Divider().overlay(Palette.stroke)

                // ─── Контент режима ─────────────────────────────
                Group {
                    switch mode {
                    case .microscope: MicroscopeView()
                    case .exam:       ExamView()
                    case .classifier: ClassifierView()
                    case .petri:      PetriDishView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .sheet(isPresented: $showMenu) {
            MenuView()
        }
    }
}

private struct ModeTab: View {
    let mode: BioMode
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: mode.icon)
                    .font(.system(size: 10, weight: .semibold))
                Text(mode.rawValue)
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
            }
            .foregroundColor(isActive ? Palette.textPrimary : Palette.textSecondary)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule().fill(isActive ? Palette.green.opacity(0.22) : Palette.surface)
            )
            .overlay(
                Capsule().stroke(
                    isActive ? Palette.green.opacity(0.6) : Palette.stroke,
                    lineWidth: 1
                )
            )
        }
        .buttonStyle(.plain)
    }
}
