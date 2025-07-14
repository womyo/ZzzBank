//
//  DreamonImageView.swift
//  Swift6
//
//  Created by wayblemac02 on 7/8/25.
//

import SwiftUI
import Kingfisher

struct DreamonImageView: View {
    let dreamon: Dreamon
    var hp: Int
    var damage: Int?
    var showDamage: Bool
    @State private var isImageLoaded = false
    
    var body: some View {
        ZStack {
            VStack {
                ZStack(alignment: .topTrailing) {
                    KFImage(URL(string: "\(dreamon.imageURL)"))
                        .loadDiskFileSynchronously(true)
                        .cacheMemoryOnly()
                        .resizable()
                        .onSuccess { _ in
                            isImageLoaded = true
                        }
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .opacity(isImageLoaded ? 1 : 0)
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
                
                if isImageLoaded {
                    Text(dreamon.name)
                    HPBar(current: Double(hp), max: Double(dreamon.hp))
                }
            }
            
            if !isImageLoaded {
                ProgressView()
            }
        }
    }
}
