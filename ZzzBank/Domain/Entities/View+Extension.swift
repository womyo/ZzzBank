//
//  View+Extension.swift
//  Swift6
//
//  Created by wayblemac02 on 6/13/25.
//

import SwiftUI

extension View {
    @ViewBuilder
    func spatialWrap(
        _ shape: some InsettableShape,
        lineWidth: CGFloat
    ) -> some View {
        self
            .background {
                shape
                    .strokeBorder(
                        LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: .white.opacity(0.4), location: 0.0),
                                .init(color: .white.opacity(0.0), location: 0.4),
                                .init(color: .white.opacity(0.0), location: 0.6),
                                .init(color: .white.opacity(0.1), location: 1.0),
                            ]),
                            startPoint: .init(x: 0.16, y: -0.4),
                            endPoint: .init(x: 0.2, y: 1.5)
                        ),
                        style: .init(lineWidth: lineWidth)
                    )
            }
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
