//
//  DreamonImageView.swift
//  Swift6
//
//  Created by wayblemac02 on 7/8/25.
//

import SwiftUI

struct DreamonImageView: View {
    let dreamon: Dreamon
    var hp: Int
    var damage: Int?
    var showDamage: Bool
    
    var body: some View {
        AsyncImage(url: URL(string: "\(dreamon.imageURL)")) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                VStack {
                    ZStack(alignment: .topTrailing) {
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .rotationEffect(.degrees(Double(showDamage ? -Int(damage ?? 0) : 0)))
                            .scaleEffect(showDamage ? 0.95 : 1.0)
                            .animation(.easeOut(duration: 0.3), value: showDamage)
                        
                        if let damage = damage {
                            Text(showDamage ? "\(damage)" : "")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(damage >= 50 ? .yellow : damage <= 10 ? .gray : .red)
                                .shadow(color: .black.opacity(0.6), radius: 1, x: 1, y: 1)
                                .padding(4)
                                .offset(x: 20, y: 0)
                        }
                    }
                    .offset(y: hp > 0 ? 0 : 40)
                    .opacity(hp > 0 ? 1 : 0)
                    .animation(.easeInOut(duration: 0.3), value: hp)
                    
                    Text(dreamon.name)
                    HPBar(current: Double(hp), max: Double(dreamon.hp))
                }
            case .failure:
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
                
                Text(dreamon.name)
                HPBar(current: Double(hp), max: Double(dreamon.hp))
            @unknown default:
                EmptyView()
            }
        }
    }
}
