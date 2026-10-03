import SwiftUI

struct CellViewerView: View {

    @State private var kind: CellKind = .animal
    @State private var selectedOrganelle: Organelle?

    private var organelles: [Organelle] {
        switch kind {
        case .animal:   return Organelle.animal
        case .plant:    return Organelle.plant
        case .bacteria: return Organelle.bacteria
        }
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Palette.background, Palette.backgroundHi],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 16) {

                Picker("Cell", selection: $kind) {
                    ForEach(CellKind.allCases) { k in
                        Text(k.rawValue).tag(k)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 20)
                .padding(.top, 8)

                GeometryReader { geo in
                    let side = min(geo.size.width, geo.size.height) - 20

                    ZStack {
                        CellBody(kind: kind, side: side)

                        ForEach(organelles) { o in
                            OrganelleMarker(
                                organelle: o,
                                isSelected: selectedOrganelle?.id == o.id,
                                cellSide: side
                            )
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedOrganelle = (selectedOrganelle?.id == o.id) ? nil : o
                                }
                            }
                        }
                    }
                    .frame(width: side, height: side)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }

                Group {
                    if let o = selectedOrganelle {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 10) {
                                Circle().fill(o.color).frame(width: 12, height: 12)
                                Text(o.name)
                                    .font(.system(size: 17, weight: .bold, design: .rounded))
                                    .foregroundColor(Palette.textPrimary)
                            }
                            Text(o.description)
                                .font(.system(size: 13))
                                .foregroundColor(Palette.textSecondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Palette.surface)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(o.color.opacity(0.4), lineWidth: 1.5)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal, 20)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    } else {
                        Text("Tap an organelle to learn about it")
                            .font(.system(size: 13))
                            .foregroundColor(Palette.textDim)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 26)
                    }
                }

                Spacer(minLength: 20)
            }
        }
        .navigationTitle("Cell Viewer")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct CellBody: View {
    let kind: CellKind
    let side: CGFloat

    var body: some View {
        ZStack {
            switch kind.shape {
            case .round:
                Circle()
                    .fill(Palette.cyan.opacity(0.12))
                    .overlay(Circle().stroke(Palette.cyan.opacity(0.6), lineWidth: 2))
            case .rectangle:
                RoundedRectangle(cornerRadius: side * 0.06)
                    .fill(Palette.green.opacity(0.12))
                    .overlay(
                        RoundedRectangle(cornerRadius: side * 0.06)
                            .stroke(Palette.green.opacity(0.7), lineWidth: 3)
                    )
            case .capsule:
                Capsule()
                    .fill(Palette.nucleus.opacity(0.10))
                    .overlay(Capsule().stroke(Palette.nucleus.opacity(0.6), lineWidth: 2))
            }
        }
        .frame(width: side * 0.9, height: side * 0.9)
        .shadow(color: Palette.green.opacity(0.25), radius: 24)
    }
}

private struct OrganelleMarker: View {
    let organelle: Organelle
    let isSelected: Bool
    let cellSide: CGFloat

    var body: some View {
        let s = cellSide * organelle.size
        let x = (organelle.x - 0.5) * cellSide * 0.9
        let y = (organelle.y - 0.5) * cellSide * 0.9

        return ZStack {
            Circle()
                .fill(organelle.color.opacity(0.75))
                .overlay(
                    Circle().stroke(organelle.color, lineWidth: isSelected ? 3 : 1.5)
                )
                .frame(width: s, height: s)
                .shadow(color: organelle.color.opacity(isSelected ? 0.8 : 0.3),
                        radius: isSelected ? 18 : 6)

            if isSelected {
                Circle()
                    .stroke(organelle.color.opacity(0.6), lineWidth: 1.5)
                    .frame(width: s + 14, height: s + 14)
            }
        }
        .offset(x: x, y: y)
    }
}
