import SwiftUI
import SwiftData

struct ChatView: View {
    @ObservedObject var viewModel: MessageViewModel
    @ObservedObject var speechRecognizer: SpeechRecognizer
    
    @StateObject var keyboardInfo = KeyboardInfo.shared
    @FocusState var isFocused
    
    var body: some View {
        VStack {
            SearchBar(viewModel: viewModel)
                .opacity(viewModel.sortedMessages.isEmpty ? 0 : 1)
            
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.sortedMessages) { message in
                            MessageRow(message: message)
                        }
                        Color.clear
                            .frame(width: 0, height: 0, alignment: .bottom)
                            .onAppear {
                                viewModel.isEndOfScroll = true
                            }
                            .onDisappear {
                                viewModel.isEndOfScroll = false
                            }
                    }
                }
                .onChange(of: viewModel.sortedMessages.count) { _, _ in
                    guard !viewModel.isAwaitingGeminiResponse else { return }
                    if let last = viewModel.sortedMessages.last {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation {
                                proxy.scrollTo(last.id, anchor: .bottom)
                            }
                        }
                    }
                }
//                .onReceive(viewModel.$isTextInputFocused) { value in
//                    if viewModel.isEndOfScroll, let last = viewModel.sortedMessages.last {
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                            withAnimation {
//                                proxy.scrollTo(last.id, anchor: .bottom)
//                            }
//                        }
//                    }
//                }
                .onReceive(viewModel.$searchIndex) { index in
                    if !viewModel.searchedMessages.isEmpty {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation {
                                proxy.scrollTo(viewModel.searchedMessages[index].id, anchor: .center)
                            }
                        }
                    }
                }
                .onAppear {
                    if let last = viewModel.sortedMessages.last {
                        DispatchQueue.main.async {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
                
                TextInputView(viewModel: viewModel, speechRecognizer: speechRecognizer, chat: viewModel.chat)
                    .opacity(viewModel.isSearchFocused || !viewModel.searchText.isEmpty ? 0 : 1)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .toolbar {
            if viewModel.toolbarVisible {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        Button {
                            viewModel.searchIndex -= 1
                        } label: {
                            Image(systemName: "chevron.up")
                        }
                        .disabled(viewModel.searchIndex <= 0 ? true : false)
                        
                        Button {
                            viewModel.searchIndex += 1
                        } label: {
                            Image(systemName: "chevron.down")
                        }
                        .disabled(viewModel.searchIndex >= viewModel.searchedMessages.count - 1 ? true : false)
                    }
                }
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
        .background(.customBackground)
    }
}

#Preview {
    ChatView(viewModel: MessageViewModel(api: GeminiAPI(), chat: Chat(title: "New Chat"), speechRecognizer: SpeechRecognizer()), speechRecognizer: SpeechRecognizer())
}
