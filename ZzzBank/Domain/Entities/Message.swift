import Foundation
import SwiftData

@Model
class Message {
    @Attribute(.unique) var id = UUID()
    var body: String
    var isFromUser: Bool
    var createdAt: Date
    
    @Relationship(inverse: \Chat.messages)
    var chat: Chat?
    
    init(body: String, isFromUser: Bool, createdAt: Date = .now, chat: Chat) {
        self.body = body
        self.isFromUser = isFromUser
        self.createdAt = createdAt
        self.chat = chat
    }
}
