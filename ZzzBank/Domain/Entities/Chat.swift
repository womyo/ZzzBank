//
//  Chat.swift
//  Swift6
//
//  Created by wayblemac02 on 6/23/25.
//

import Foundation
import SwiftData

@Model
class Chat {
    @Attribute(.unique) var id = UUID()
    var title: String
    var createdAt: Date
    
    @Relationship(deleteRule: .cascade)
    var messages: [Message] = []
    
    init(title: String, createdAt: Date = .now) {
        self.title = title
        self.createdAt = createdAt
    }
}
