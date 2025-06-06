//
//  GaugeView.swift
//  ZzzBank
//
//  Created by 이인호 on 1/7/25.
//

import SwiftUI

struct GaugeView: View {
    @ObservedObject private var viewModel: LoanViewModel
    @State private var minValue = 0.0
    @State private var maxValue = 100.0
    let gradient = Gradient(colors: [.green, .yellow, .orange, .red])
    
    init(viewModel: LoanViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Gauge(value: viewModel.condition.rawValue, in: minValue...maxValue) {
            Image(systemName: "heart.fill")
                .foregroundColor(.red)
        } currentValueLabel: {
            Text("Tiredness")
                .foregroundColor(Color.green)
        } minimumValueLabel: {
            Text("\(Int(minValue))")
                .foregroundColor(Color.green)
        } maximumValueLabel: {
            Text("\(Int(maxValue))")
                .foregroundColor(Color.red)
        }
        .background(Color(UIColor.customBackgroundColor))
        .gaugeStyle(.accessoryCircular)
        .tint(gradient)
        .scaleEffect(1.2)
    }
}

#Preview {
    GaugeView(viewModel: LoanViewModel())
}
