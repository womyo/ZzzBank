import SwiftUI

struct ChatListView: View {
    @StateObject var viewModel = ChatViewModel(api: GeminiAPI())
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State private var path = NavigationPath()
    @State private var isDataReady = false
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                if isDataReady {
                    if viewModel.chats.isEmpty {
                        Button("Start a new chat") {
                            path.append(Chat(title: "New Chat"))
                        }
                        .navigationDestination(for: Chat.self) { chat in
                            ChatView(viewModel: MessageViewModel(api: GeminiAPI(), chat: chat, speechRecognizer: speechRecognizer), speechRecognizer: speechRecognizer)
                        }
                    } else {
                        List(viewModel.chats) { chat in
                            NavigationLink(value: chat) {
                                Text(chat.title)
                            }
                        }
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button {
                                    path.append(Chat(title: "New Chat"))
                                } label: {
                                    Image(systemName: "plus")
                                }
                            }
                        }
                        .navigationDestination(for: Chat.self) { chat in
                            ChatView(viewModel: MessageViewModel(api: GeminiAPI(), chat: chat, speechRecognizer: speechRecognizer), speechRecognizer: speechRecognizer)
                        }
                    }
                }
            }
        }
        .task {
            await viewModel.fetchChats()
            withAnimation {
                isDataReady = true
            }
        }
        .onChange(of: path) { _, _ in
            Task {
                await viewModel.fetchChats()
            }
        }
    }
}

#Preview {
    ChatListView()
}
