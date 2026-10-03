import SwiftUI

// MARK: - Модули главного меню

enum BioModule: String, CaseIterable, Identifiable {
    case microscope = "Microscope"
    case cellViewer = "Cell Viewer"
    case dna        = "DNA Helix"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .microscope: return "eye.trianglebadge.exclamationmark.fill"
        case .cellViewer: return "circle.hexagongrid.fill"
        case .dna:        return "waveform.path.ecg"
        }
    }

    var subtitle: String {
        switch self {
        case .microscope: return "Look at tiny worlds"
        case .cellViewer: return "Inside living cells"
        case .dna:        return "The code of life"
        }
    }

    var tint: Color {
        switch self {
        case .microscope: return Palette.green
        case .cellViewer: return Palette.cyan
        case .dna:        return Palette.nucleus
        }
    }
}

// MARK: - Клетка

enum CellKind: String, CaseIterable, Identifiable {
    case animal  = "Animal Cell"
    case plant   = "Plant Cell"
    case bacteria = "Bacterium"

    var id: String { rawValue }

    var shape: CellShapeKind {
        switch self {
        case .animal:   return .round
        case .plant:    return .rectangle
        case .bacteria: return .capsule
        }
    }
}

enum CellShapeKind {
    case round, rectangle, capsule
}

struct Organelle: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let color: Color
    /// Позиция в % от размера клетки (0..1)
    let x: CGFloat
    let y: CGFloat
    let size: CGFloat

    static let animal: [Organelle] = [
        Organelle(name: "Nucleus",   description: "Control centre of the cell. Contains DNA.",
                  color: Palette.nucleus, x: 0.50, y: 0.45, size: 0.28),
        Organelle(name: "Mitochondria", description: "The powerhouse — makes energy (ATP).",
                  color: Palette.mito, x: 0.24, y: 0.62, size: 0.16),
        Organelle(name: "Ribosomes", description: "Tiny factories that build proteins.",
                  color: Palette.ribosome, x: 0.72, y: 0.35, size: 0.10),
        Organelle(name: "Membrane", description: "Controls what enters and leaves the cell.",
                  color: Palette.membrane, x: 0.50, y: 0.82, size: 0.14),
    ]

    static let plant: [Organelle] = [
        Organelle(name: "Nucleus",   description: "Control centre of the plant cell.",
                  color: Palette.nucleus, x: 0.44, y: 0.50, size: 0.22),
        Organelle(name: "Chloroplast", description: "Captures sunlight — site of photosynthesis.",
                  color: Palette.chloro, x: 0.72, y: 0.62, size: 0.18),
        Organelle(name: "Vacuole",   description: "Stores water and keeps the cell firm.",
                  color: Palette.cyan, x: 0.26, y: 0.34, size: 0.20),
        Organelle(name: "Cell Wall", description: "Rigid outer layer. Only plants have it.",
                  color: Palette.green, x: 0.50, y: 0.86, size: 0.14),
    ]

    static let bacteria: [Organelle] = [
        Organelle(name: "Nucleoid", description: "Bacteria keep DNA loose, not in a nucleus.",
                  color: Palette.nucleus, x: 0.42, y: 0.48, size: 0.22),
        Organelle(name: "Ribosomes", description: "Build proteins, just like in our cells.",
                  color: Palette.ribosome, x: 0.70, y: 0.44, size: 0.10),
        Organelle(name: "Flagellum", description: "Tail-like whip used for swimming.",
                  color: Palette.mito, x: 0.86, y: 0.70, size: 0.14),
        Organelle(name: "Capsule",   description: "Slimy coat — protects from the immune system.",
                  color: Palette.membrane, x: 0.30, y: 0.70, size: 0.14),
    ]
}

// MARK: - Микроскоп — образцы

struct Specimen: Identifiable {
    let id = UUID()
    let name: String
    let emoji: String
    let tint: Color
    /// Как выглядят клетки под увеличением — параметры для отрисовки
    let cells: Int
    let cellColor: Color
    let grid: Int   // сколько линий в сетке

    static let all: [Specimen] = [
        Specimen(name: "Onion Skin",  emoji: "🧅", tint: .orange,
                 cells: 24, cellColor: Color(hex: "#FFD8A8"), grid: 6),
        Specimen(name: "Blood Drop",  emoji: "🩸", tint: .red,
                 cells: 18, cellColor: Color(hex: "#FF7B7B"), grid: 5),
        Specimen(name: "Leaf",        emoji: "🍃", tint: .green,
                 cells: 30, cellColor: Color(hex: "#86EFAC"), grid: 7),
        Specimen(name: "Cheek Cells", emoji: "😊", tint: .pink,
                 cells: 12, cellColor: Color(hex: "#FBCFE8"), grid: 4),
    ]
}
