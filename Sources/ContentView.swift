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
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Palette.background, Palette.backgroundHi],
                    startPoint: .top, endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 0) {

                    // ─── Шапка ────────────────────────────────────
                    HStack {
                        MDLogo()

                        Spacer()

                        // Переключатель режимов
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

                        // Кнопка меню
                        Button {
                            showMenu = true
                        } label: {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Palette.green)
                                .frame(width: 38, height: 38)
                                .background(Palette.surface)
                                .overlay(
                                    Circle().stroke(Palette.stroke, lineWidth: 1)
                                )
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Palette.background.opacity(0.9))

                    // ─── Контент режима ───────────────────────────
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
            .navigationBarHidden(true)
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
            HStack(spacing: 6) {
                Image(systemName: mode.icon)
                    .font(.system(size: 12, weight: .semibold))
                Text(mode.rawValue)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
            }
            .foregroundColor(isActive ? Palette.textPrimary : Palette.textSecondary)
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(
                Capsule()
                    .fill(isActive ? Palette.green.opacity(0.22) : Palette.surface)
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
