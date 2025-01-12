//
//  CircularSliderView.swift
//  ZzzBank
//
//  Created by 이인호 on 1/7/25.
//

import SwiftUI

struct Config {
    let minimumValue: CGFloat
    let maximumValue: CGFloat
    let totalValue: CGFloat
    let knobRadius: CGFloat
    let radius: CGFloat
}

struct CircularSliderView: View {
    @ObservedObject var viewModel: LoanViewModel
    @State var angleValue: CGFloat = 0.0
    
    func config() ->Config {
        return Config(minimumValue: 0.0, maximumValue: viewModel.getLoanLimit(), totalValue: 24.0, knobRadius: 15.0, radius: 150.0)
    }
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: config().radius*2, height: config().radius*2)
                .scaleEffect(1.2)
            
            Circle()
                .stroke(.gray, style: StrokeStyle(lineWidth: 7, lineCap: .butt, dash: [1, 38.25]))
                .frame(width: config().radius*2, height: config().radius*2)
            
            Circle()
                .trim(from: 0.0, to: viewModel.timeValue / config().totalValue)
                .stroke(.blue, lineWidth: 7)
                .frame(width: config().radius*2, height: config().radius*2)
                .rotationEffect(.degrees(-90))
            
            Circle()
                .fill(.blue)
                .frame(width: config().knobRadius*2, height: config().knobRadius*2)
                .padding(10)
                .offset(y: -config().radius)
                .rotationEffect(Angle.degrees(Double(angleValue)))
                .gesture(DragGesture(minimumDistance: 0.0)
                    .onChanged({ value in
                        change(location: value.location)
                    })
                )
            
            VStack {
                Text("\(String.init(format: "%.0f", viewModel.timeValue)) h")
                    .font(.system(size: 60))
                    .foregroundStyle(.white)
                
                HStack {
                    Text("⏳ 대출 한도: \(String.init(format: "%.0f", config().maximumValue)) h")
                        .font(.system(size: 10))
                        .foregroundStyle(.white)
                }
            }
        }
        .task {
            viewModel.timeValue = 0.0
        }
    }
    
    private func change(location: CGPoint) {
        let vector = CGVector(dx: location.x, dy: location.y)
        
        let angle = atan2(vector.dy - (config().knobRadius + 10), vector.dx - (config().knobRadius + 10)) + .pi/2.0
        
        let fixedAngle = angle < 0.0 ? angle + 2.0 * .pi : angle
        // 각도를 24등분으로 스냅
        let stepAngle = 2.0 * .pi / config().totalValue
        let snappedAngle = round(fixedAngle / stepAngle) * stepAngle
        
        // 값을 24등분으로 스냅
        let value = snappedAngle / (2.0 * .pi) * config().totalValue
        let snappedValue = round(value)
        
        // 한도 범위 체크 후 적용
        if snappedValue >= config().minimumValue && snappedValue <= config().maximumValue {
            viewModel.timeValue = snappedValue
            angleValue = snappedAngle * 180 / .pi // 각도를 스냅된 값으로 업데이트
        }
    }
}


//#Preview {
//    CircularSliderView()
//}
