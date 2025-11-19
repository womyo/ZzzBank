import Foundation
import SwiftData
import Combine
import WidgetKit
import FoundationModels

@MainActor
final class MessageViewModel: ObservableObject {
    private let api: GeminiAPI
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    @Published var messages: [Message] = []
    @Published var inputText: String = ""
    @Published var chat: Chat
    @Published var searchText: String = ""
    @Published var searchIndex: Int = 0
    @Published var searchedMessages: [Message] = []
    var toolbarVisible = false
    @Published var isSearchFocused = false
    @Published var isTextInputFocused = false
    @Published var isEndOfScroll = true
    @Published var isAwaitingGeminiResponse = false
    
    private var cancellables = Set<AnyCancellable>()
    
    var sortedMessages: [Message] {
        chat.messages.sorted(by: { $0.createdAt < $1.createdAt })
    }
    
    init(api: GeminiAPI, chat: Chat, speechRecognizer: SpeechRecognizer) {
        self.api = api
        self.chat = chat
        self.modelContainer = try! ModelContainer(
            for: Message.self, configurations: ModelConfiguration(isStoredInMemoryOnly: false)
        )
        self.modelContext = modelContainer.mainContext
        
        speechRecognizer.$transcript
            .receive(on: DispatchQueue.main)
            .assign(to: \.inputText, on: self)
            .store(in: &cancellables)
    }
    
    func saveAnswerFromGemini(inputText: String) async throws {
        let message = Message(body: "", isFromUser: false, chat: chat)
        messages.append(message)
        
        if #available(iOS 26.0, *) {
            let session = LanguageModelSession()
            let stream = session.streamResponse(to: inputText)
            
            for try await streamData in stream {
                try await Task.sleep(nanoseconds: 50_000_000)
                message.body = streamData.content
            }
        } else {
            message.body = "This feature is only available on iOS 26 or later. Please update your device to use it."
        }
        
        modelContext.insert(message)
        saveContext()
    }
    
    func saveUserInput(inputText: String) async throws {
        let message = Message(body: inputText, isFromUser: true, chat: chat)
        
        if !chatExists(id: chat.id) {
            let title = try await createChatTitle(inputText: inputText)
            chat.title = title
            
            modelContext.insert(chat)
            
            WidgetCenter.shared.reloadTimelines(ofKind: "ZzzBankWidget")
        }
        
        messages.append(message)
        modelContext.insert(message)
        
        saveContext()
    }
    
    func saveContext() {
        do {
            try modelContext.save()
            print("save success")
        } catch {
            fatalError("save failed: \(error.localizedDescription)")
        }
    }
    
    func chatExists(id: UUID) -> Bool {
        let predicate = #Predicate<Chat> { $0.id == id }
        let descriptor = FetchDescriptor<Chat>(predicate: predicate)
        
        do {
            return try modelContext.fetchCount(descriptor) > 0
        } catch {
            print("Fetch error: \(error)")
            return false
        }
    }
    
    func searchMessageByText() {
        searchedMessages = sortedMessages.filter { $0.body.lowercased().contains(searchText.lowercased()) }
        let searchedMessagesLength = searchedMessages.count

        searchIndex = searchedMessagesLength > 0 ? searchedMessagesLength - 1 : 0
        toolbarVisible = searchedMessagesLength > 0 ? true : false
    }
    
    func clearSearch() {
        searchText = ""
        searchedMessages = []
        toolbarVisible = false
    }
    
    func createChatTitle(inputText: String) async throws -> String {
        if #available(iOS 26.0, *) {
            let session = LanguageModelSession()
            
            let prompt = """
                The following sentence is a user-generated question.  
                Detect the **language** of this sentence, and create a natural **chat room title** in **that exact language only**.
                
                **Follow these rules:**
                - The output language must match the question’s language. For example, if the question is in Japanese, the title must also be in Japanese. If it’s in English, then the title must be in English.
                - Do not translate. **Preserve the original input language.**
                - It should be a **short, one-line title** that looks like a chat title. Don’t make it too long.
                - Output **only one title**, with **no explanation**.
                - Give the title as **plain text** (no quotes, no asterisks, no formatting).
                
                Question:  
                \(inputText)
                """
            
            return try await session.respond(to: prompt).content
        }
        
        return "New Chat"
    }
    
//    func readMessages() {
//        do {
//            let chatPID = chat.persistentModelID
//            
//            let predicate = #Predicate<Message> { msg in
//                msg.chat?.persistentModelID == chatPID
//            }
//            
//            let descriptor = FetchDescriptor<Message>(predicate: predicate)
//            
//            messages = try modelContext.fetch(descriptor)
//            
//            print(messages)
//        } catch {
//            fatalError("read failed: \(error.localizedDescription)")
//        }
//    }
}
