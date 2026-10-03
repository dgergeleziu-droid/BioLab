import SwiftUI

struct ContentView: View {

    @State private var showMicroscope = false
    @State private var showCellViewer = false
    @State private var showDNA = false

    private let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Palette.background, Palette.backgroundHi],
                    startPoint: .top, endPoint: .bottom
                )
                .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {

                        HStack {
                            MDLogo()
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 12)

                        Spacer().frame(height: 24)

                        Text("Welcome to the lab")
                            .font(.system(size: 28, weight: .heavy, design: .rounded))
                            .foregroundColor(Palette.textPrimary)
                            .padding(.horizontal, 20)

                        Text("Pick an experiment and start exploring life.")
                            .font(.system(size: 14))
                            .foregroundColor(Palette.textSecondary)
                            .padding(.horizontal, 20)
                            .padding(.top, 4)

                        Spacer().frame(height: 22)

                        LazyVGrid(columns: columns, spacing: 14) {
                            ModuleCard(module: .microscope) { showMicroscope = true }
                            ModuleCard(module: .cellViewer) { showCellViewer = true }
                            ModuleCard(module: .dna)        { showDNA = true }
                            ComingSoonCard()
                        }
                        .padding(.horizontal, 20)

                        Spacer().frame(height: 30)
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $showMicroscope) { MicroscopeView() }
            .navigationDestination(isPresented: $showCellViewer) { CellViewerView() }
            .navigationDestination(isPresented: $showDNA)        { DNAView() }
        }
    }
}

private struct ComingSoonCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack {
                Circle()
                    .fill(Palette.textDim.opacity(0.15))
                    .frame(width: 56, height: 56)
                Image(systemName: "hourglass")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(Palette.textDim)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text("Genetics")
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundColor(Palette.textSecondary)
                Text("Punnett squares — soon")
                    .font(.system(size: 12))
                    .foregroundColor(Palette.textDim)
            }
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Palette.surface.opacity(0.5))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Palette.stroke, lineWidth: 1)
                .opacity(0.5)
        )
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}
