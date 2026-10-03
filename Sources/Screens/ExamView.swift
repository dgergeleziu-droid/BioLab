import SwiftUI

struct ExamView: View {

    @State private var index = 0
    @State private var selected: Int? = nil
    @State private var showAnswer = false
    @State private var score = 0
    @State private var finished = false

    private let questions = OGEQuestion.all

    var body: some View {
        ZStack {
            Palette.background.ignoresSafeArea()

            if finished {
                ResultsView(score: score, total: questions.count) {
                    index = 0; score = 0; selected = nil
                    showAnswer = false; finished = false
                }
            } else {
                GeometryReader { geo in
                    let h = geo.size.height

                    VStack(spacing: 8) {

                        // Прогресс
                        HStack(spacing: 10) {
                            Text("Вопрос \(index + 1) / \(questions.count)")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(Palette.textSecondary)
                            Spacer()
                            Text("Очки: \(score)")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(Palette.green)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 6)

                        ProgressView(value: Double(index), total: Double(questions.count))
                            .tint(Palette.green)
                            .padding(.horizontal, 20)

                        // Вопрос
                        Text(questions[index].question)
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundColor(Palette.textPrimary)
                            .multilineTextAlignment(.center)
                            .lineLimit(3)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 4)

                        // Варианты — компактнее
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 6) {
                                ForEach(Array(questions[index].options.enumerated()), id: \.offset) { i, opt in
                                    OptionRow(
                                        text: opt,
                                        state: optionState(i),
                                        action: {
                                            guard selected == nil else { return }
                                            selected = i
                                            if i == questions[index].correctIndex { score += 1 }
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal, 30)
                        }

                        // Объяснение (если показано)
                        if showAnswer {
                            Text(questions[index].explanation)
                                .font(.system(size: 11))
                                .foregroundColor(Palette.textSecondary)
                                .multilineTextAlignment(.center)
                                .lineLimit(3)
                                .padding(.horizontal, 30)
                                .transition(.opacity)
                        }

                        // Кнопки
                        HStack(spacing: 10) {
                            if selected != nil && !showAnswer {
                                Button("Показать решение") { showAnswer = true }
                                    .buttonStyle(SecondaryButton())
                            }

                            Button(showAnswer || selected == nil ? "Далее" : "Дальше") {
                                if index + 1 < questions.count {
                                    index += 1
                                    selected = nil
                                    showAnswer = false
                                } else {
                                    finished = true
                                }
                            }
                            .buttonStyle(PrimaryButton())
                            .disabled(selected == nil)
                        }
                        .padding(.bottom, 8)
                    }
                }
            }
        }
    }

    private func optionState(_ i: Int) -> OptionRow.State {
        guard let s = selected else { return .idle }
        if showAnswer {
            if i == questions[index].correctIndex { return .correct }
            if i == s { return .wrong }
            return .idle
        }
        return i == s ? .selected : .idle
    }
}

struct OptionRow: View {
    enum State { case idle, selected, correct, wrong }

    let text: String
    let state: State
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(text)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(color)
                    .lineLimit(2)
                Spacer()
                if state == .correct {
                    Image(systemName: "checkmark.circle.fill").foregroundColor(Palette.green)
                        .font(.system(size: 14))
                } else if state == .wrong {
                    Image(systemName: "xmark.circle.fill").foregroundColor(Palette.danger)
                        .font(.system(size: 14))
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(background)
            .overlay(
                RoundedRectangle(cornerRadius: 10).stroke(border, lineWidth: 1.4)
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
    }

    private var color: Color {
        switch state {
        case .correct: return Palette.green
        case .wrong:   return Palette.danger
        default:       return Palette.textPrimary
        }
    }

    private var background: Color {
        switch state {
        case .selected: return Palette.green.opacity(0.15)
        case .correct:  return Palette.green.opacity(0.15)
        case .wrong:    return Palette.danger.opacity(0.15)
        default:        return Palette.surface
        }
    }

    private var border: Color {
        switch state {
        case .selected: return Palette.green
        case .correct:  return Palette.green
        case .wrong:    return Palette.danger
        default:        return Palette.stroke
        }
    }
}

struct PrimaryButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 12, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .padding(.horizontal, 18).padding(.vertical, 9)
            .background(Palette.green)
            .clipShape(Capsule())
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}

struct SecondaryButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 12, weight: .semibold, design: .rounded))
            .foregroundColor(Palette.textPrimary)
            .padding(.horizontal, 16).padding(.vertical, 9)
            .background(Palette.surface)
            .overlay(Capsule().stroke(Palette.stroke, lineWidth: 1))
            .clipShape(Capsule())
    }
}

struct ResultsView: View {
    let score: Int
    let total: Int
    let onRetry: () -> Void

    private var mark: String {
        switch Double(score) / Double(total) {
        case ..<0.45:  return "2"
        case ..<0.65:  return "3"
        case ..<0.85:  return "4"
        default:       return "5"
        }
    }

    private var message: String {
        switch mark {
        case "2": return "Попробуй ещё — у тебя получится!"
        case "3": return "Неплохо! Продолжай тренироваться."
        case "4": return "Хорошо! Немного доработать."
        default:  return "Отлично! Ты знаешь биологию!"
        }
    }

    var body: some View {
        HStack(spacing: 24) {
            // Оценка
            ZStack {
                Circle().fill(Palette.green.opacity(0.15)).frame(width: 120, height: 120)
                Circle().stroke(Palette.green, lineWidth: 3).frame(width: 120, height: 120)
                VStack(spacing: 0) {
                    Text(mark)
                        .font(.system(size: 44, weight: .heavy, design: .rounded))
                        .foregroundColor(Palette.green)
                    Text("оценка")
                        .font(.system(size: 10))
                        .foregroundColor(Palette.textSecondary)
                }
            }

            // Текст
            VStack(alignment: .leading, spacing: 8) {
                Text("Результат")
                    .font(.system(size: 18, weight: .heavy, design: .rounded))
                    .foregroundColor(Palette.textPrimary)

                Text("Правильных: \(score) из \(total)")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Palette.textPrimary)

                Text(message)
                    .font(.system(size: 12))
                    .foregroundColor(Palette.textSecondary)
                    .lineLimit(2)

                Button("Пройти заново", action: onRetry)
                    .buttonStyle(PrimaryButton())
            }
        }
        .padding(24)
    }
}
