import SwiftUI

struct HPBar: View {
    let current: Double
    let max: Double
    
    var ratio: Double {
        max == 0 ? 0 : current / max
    }
    
    var body: some View {
        HStack {
            Text("\(Int(current))/\(Int(max))")
                .font(.system(size: 16, weight: .semibold, design: .monospaced))
                .kerning(-0.5)
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 100, height: 14)
                
                RoundedRectangle(cornerRadius: 6)
                    .fill(barColor)
                    .frame(width: CGFloat(ratio) * 100, height: 14)
                    .animation(.easeInOut(duration: 0.3), value: ratio)
            }
        }
    }
    
    var barColor: Color {
        switch ratio {
        case ..<0.3: return .red
        case ..<0.6: return .yellow
        default: return .green
        }
    }
}

#Preview {
    HPBar(current: 0, max: 0)
}
