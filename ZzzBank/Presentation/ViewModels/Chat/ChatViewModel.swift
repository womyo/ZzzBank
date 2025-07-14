import Foundation
import SwiftData

@MainActor
final class ChatViewModel: ObservableObject {
    private let api: GeminiAPI
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    @Published var chats: [Chat] = []
    
    init(api: GeminiAPI) {
        self.api = api
        self.modelContainer = try! ModelContainer(
            for: Message.self, configurations: ModelConfiguration(isStoredInMemoryOnly: false)
        )
        self.modelContext = modelContainer.mainContext
    }

    func fetchChats() async {
        do {
            chats = try modelContext.fetch(FetchDescriptor<Chat>())
            chats = chats.sorted(by: { $0.createdAt > $1.createdAt })
        } catch {
            fatalError("fetch failed: \(error.localizedDescription)")
        }
    }
    
    func deleteChat(chat: Chat) {
        do {
            modelContext.delete(chat)
            try modelContext.save()
            
            chats.removeAll { $0.id == chat.id }
        } catch {
            fatalError("delete failed: \(error.localizedDescription)")
        }
    }
}
