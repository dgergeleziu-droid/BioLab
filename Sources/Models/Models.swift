import SwiftUI

// MARK: - Образцы для микроскопа

struct BioSample: Identifiable, Equatable {
    let id = UUID()
    let name: String          // Русское название
    let emoji: String
    let color: Color
    let type: SampleType      // клетка / ткань / микроорганизм
    let baseDescription: String

    static let all: [BioSample] = [
        BioSample(name: "Клетка лука",     emoji: "🧅", color: Color(hex: "#FFD8A8"),
                  type: .cell, baseDescription: "Растительная клетка с плотной стенкой"),
        BioSample(name: "Клетка листа",    emoji: "🍃", color: Color(hex: "#86EFAC"),
                  type: .cell, baseDescription: "Фотосинтезирующая клетка с хлоропластами"),
        BioSample(name: "Эритроцит",       emoji: "🩸", color: Color(hex: "#FF7B7B"),
                  type: .cell, baseDescription: "Красная клетка крови, переносит кислород"),
        BioSample(name: "Клетка кожи",     emoji: "🫧", color: Color(hex: "#FBCFE8"),
                  type: .cell, baseDescription: "Плоская клетка эпителия"),
        BioSample(name: "Нейрон",          emoji: "🧠", color: Color(hex: "#A78BFA"),
                  type: .cell, baseDescription: "Клетка нервной системы с отростками"),
        BioSample(name: "Мышечная клетка", emoji: "💪", color: Color(hex: "#FCA5A5"),
                  type: .cell, baseDescription: "Длинная клетка с волокнами"),
        BioSample(name: "Инфузория",       emoji: "🦠", color: Color(hex: "#22D3EE"),
                  type: .microbe, baseDescription: "Одноклеточное с ресничками"),
        BioSample(name: "Амёба",           emoji: "🫧", color: Color(hex: "#7DD3FC"),
                  type: .microbe, baseDescription: "Одноклеточное с ложноножками"),
        BioSample(name: "Хламидомонада",   emoji: "🟢", color: Color(hex: "#4ADE80"),
                  type: .microbe, baseDescription: "Зелёная водоросль с жгутиками"),
        BioSample(name: "Дрожжи",          emoji: "🍞", color: Color(hex: "#FCD34D"),
                  type: .microbe, baseDescription: "Одноклеточные грибы, почкуются"),
    ]
}

enum SampleType: String {
    case cell    = "Клетка"
    case microbe = "Микроорганизм"
}

// MARK: - Красители

struct Dye: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let emoji: String
    let color: Color
    let description: String

    static let all: [Dye] = [
        Dye(name: "Йод",             emoji: "🟤", color: Color(hex: "#B45309"),
            description: "Окрашивает крахмал в синий цвет"),
        Dye(name: "Метиленовый синий", emoji: "🔵", color: Color(hex: "#3B82F6"),
            description: "Выделяет ядра клеток"),
        Dye(name: "Фуксин",           emoji: "🟥", color: Color(hex: "#DC2626"),
            description: "Красит клеточные стенки"),
        Dye(name: "Гематоксилин",     emoji: "🟣", color: Color(hex: "#7C3AED"),
            description: "Красит ядра и хромосомы"),
    ]
}

// MARK: - Наблюдения (взаимодействия)

struct Observation: Identifiable {
    let id = UUID()
    let sampleName: String
    let dyeName: String
    let result: String
    let effect: EffectKind

    static let all: [Observation] = [
        Observation(sampleName: "Клетка лука", dyeName: "Йод",
                    result: "Крахмал посинел — видно ядро и вакуоль",
                    effect: .blue),
        Observation(sampleName: "Клетка листа", dyeName: "Йод",
                    result: "Хлоропласты тёмно-зелёные, крахмала нет",
                    effect: .green),
        Observation(sampleName: "Эритроцит", dyeName: "Метиленовый синий",
                    result: "Ядро отсутствует — признак зрелого эритроцита",
                    effect: .blue),
        Observation(sampleName: "Клетка кожи", dyeName: "Метиленовый синий",
                    result: "Хорошо видны ядра эпителиальных клеток",
                    effect: .blue),
        Observation(sampleName: "Нейрон", dyeName: "Гематоксилин",
                    result: "Видны длинные отростки и ядро",
                    effect: .purple),
        Observation(sampleName: "Инфузория", dyeName: "Фуксин",
                    result: "Заметны реснички по краю клетки",
                    effect: .red),
    ]

    static func find(sample: String, dye: String) -> Observation? {
        all.first { $0.sampleName == sample && $0.dyeName == dye }
    }
}

enum EffectKind {
    case blue, green, red, purple, gold
}

// MARK: - Классификация (Определитель)

struct Taxon: Identifiable {
    let id = UUID()
    let rank: String          // Царство, Тип, Класс...
    let name: String
    let nextRank: String?
}

struct Species: Identifiable {
    let id = UUID()
    let name: String
    let emoji: String
    let hint: String
    let chain: [(String, String)]   // [(Ранг, Название)]

    static let all: [Species] = [
        Species(name: "Заяц-беляк", emoji: "🐇",
                hint: "Млекопитающее, зимой меняет шубу",
                chain: [
                    ("Царство", "Животные"),
                    ("Тип",     "Хордовые"),
                    ("Класс",   "Млекопитающие"),
                    ("Отряд",   "Зайцеобразные"),
                    ("Семейство", "Зайцевые"),
                    ("Род",     "Зайцы"),
                    ("Вид",     "Заяц-беляк"),
                ]),
        Species(name: "Берёза", emoji: "🌳",
                hint: "Дерево с белым стволом",
                chain: [
                    ("Царство", "Растения"),
                    ("Отдел",   "Покрытосеменные"),
                    ("Класс",   "Двудольные"),
                    ("Порядок", "Букоцветные"),
                    ("Семейство", "Берёзовые"),
                    ("Род",     "Берёза"),
                    ("Вид",     "Берёза повислая"),
                ]),
        Species(name: "Волк", emoji: "🐺",
                hint: "Хищник, живёт стаями",
                chain: [
                    ("Царство", "Животные"),
                    ("Тип",     "Хордовые"),
                    ("Класс",   "Млекопитающие"),
                    ("Отряд",   "Хищные"),
                    ("Семейство", "Псовые"),
                    ("Род",     "Волки"),
                    ("Вид",     "Волк серый"),
                ]),
    ]
}

// MARK: - Бактерии для чашки Петри

struct Bacterium: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let color: Color
    let growthRate: Double      // насколько быстро растёт
    let resistance: Int         // 0-3, устойчивость к антибиотику

    static let all: [Bacterium] = [
        Bacterium(name: "Кишечная палочка", color: Color(hex: "#F87171"),
                  growthRate: 1.4, resistance: 0),
        Bacterium(name: "Стафилококк", color: Color(hex: "#FBBF24"),
                  growthRate: 1.0, resistance: 1),
        Bacterium(name: "Сенная палочка", color: Color(hex: "#86EFAC"),
                  growthRate: 1.2, resistance: 0),
        Bacterium(name: "Стрептококк", color: Color(hex: "#60A5FA"),
                  growthRate: 0.9, resistance: 2),
    ]
}

// MARK: - Вопросы ОГЭ

struct OGEQuestion: Identifiable {
    let id = UUID()
    let question: String
    let options: [String]
    let correctIndex: Int
    let explanation: String

    static let all: [OGEQuestion] = [
        OGEQuestion(
            question: "Какой органоид отвечает за синтез белка?",
            options: ["Митохондрия", "Рибосома", "Ядро", "Хлоропласт"],
            correctIndex: 1,
            explanation: "Рибосомы — это место синтеза белка. Они есть и в клетках прокариот, и эукариот."
        ),
        OGEQuestion(
            question: "Какая ткань обеспечивает рост растения в толщину?",
            options: ["Покровная", "Основная", "Образовательная", "Проводящая"],
            correctIndex: 2,
            explanation: "Образовательная ткань (камбий) делится и обеспечивает рост в толщину."
        ),
        OGEQuestion(
            question: "Сколько камер в сердце млекопитающих?",
            options: ["2", "3", "4", "5"],
            correctIndex: 2,
            explanation: "Четыре камеры: два предсердия и два желудочка."
        ),
        OGEQuestion(
            question: "Что из перечисленного — атавизм?",
            options: ["Аппендикс", "Хвост у человека", "Копчик", "Мышцы уха"],
            correctIndex: 1,
            explanation: "Хвост — атавизм (появляется редко), остальные — рудименты (есть у всех)."
        ),
        OGEQuestion(
            question: "Какая группа крови универсальный реципиент?",
            options: ["I (0)", "II (A)", "III (B)", "IV (AB)"],
            correctIndex: 3,
            explanation: "Люди с IV (AB) группой могут принимать кровь любой группы."
        ),
    ]
}
