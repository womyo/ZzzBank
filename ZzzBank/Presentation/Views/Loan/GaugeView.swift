//
//  GaugeView.swift
//  ZzzBank
//
//  Created by 이인호 on 1/7/25.
//

import SwiftUI

struct GaugeView: View {
    @State private var current = 67.0
    @State private var minValue = 0.0
    @State private var maxValue = 100.0
    let gradient = Gradient(colors: [.green, .yellow, .orange, .red])
    
    
    var body: some View {
        Gauge(value: current, in: minValue...maxValue) {
            Image(systemName: "heart.fill")
                .foregroundColor(.red)
        } currentValueLabel: {
            Text("예상 피로도")
                .foregroundColor(Color.green)
        } minimumValueLabel: {
            Text("\(Int(minValue))")
                .foregroundColor(Color.green)
        } maximumValueLabel: {
            Text("\(Int(maxValue))")
                .foregroundColor(Color.red)
        }
        .gaugeStyle(.accessoryCircular)
        .tint(gradient)
        .scaleEffect(1.2)
    }
}

#Preview {
    GaugeView()
}
