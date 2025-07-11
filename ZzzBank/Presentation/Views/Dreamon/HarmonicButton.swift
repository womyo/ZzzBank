import SwiftUI

struct HarmonicStyle: ButtonStyle {
    @ObservedObject var viewModel: DreamonViewModel
    
    @State private var scale: CGFloat = 1.0
    
    @State private var speedMultiplier: Double = 1.0
    @State private var amplitude: Float = 0.5
    
    @State private var elapsedTime: Double = 0.0
    private let updateInterval: Double = 0.016
    
    func makeBody(configuration: Configuration) -> some View {
        TimelineView(.periodic(from: .now, by: updateInterval / speedMultiplier)) { context in
            configuration.label
                .spatialWrap(Capsule(), lineWidth: 1.0)
                .background {
                    Rectangle()
                        .colorEffect(ShaderLibrary.default.harmonicColorEffect(
                            .boundingRect, // bounding rect
                            .float(6), // waves count,
                            .float(elapsedTime), // animation clock
                            .float(amplitude), // amplitude
                            .float(viewModel.isInBattle ? 1.0 : 0.0) // monochrome coeff
                        ))
                }
                .clipShape(Capsule())
                .scaleEffect(scale)
                .onChange(of: context.date) { _, _ in
                    elapsedTime += updateInterval * speedMultiplier
                }
        }
        .onChange(of: viewModel.isInBattle) { _, newValue in
            withAnimation(.spring(duration: 0.3)) {
                amplitude = newValue ? 2.0 : 0.5
                speedMultiplier = newValue ? 2.0 : 1.0
                scale = newValue ? 0.95 : 1.0
            }
        }
        .sensoryFeedback(.impact, trigger: configuration.isPressed)
    }
}
