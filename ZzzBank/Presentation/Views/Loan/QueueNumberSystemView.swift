//
//  QueueNumberSystemView.swift
//  ZzzBank
//
//  Created by 이인호 on 1/8/25.
//

import SwiftUI
import Foundation

struct QueueNumberSystemView: View {
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.gray)
                .frame(width: 5, height: 20)
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray)
                    .frame(width: 100, height: 50)
                
                RoundedRectangle(cornerRadius: 5)
                    .fill(.black)
                    .frame(width: 90, height: 40)
                
                Text("\(Int.random(in: 1...999))")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    
            }
        }
        .background(.black)
        .padding()
    }
}

#Preview {
    QueueNumberSystemView()
}
