import SwiftUI

struct TextInputView: View {
    @ObservedObject var viewModel: MessageViewModel
    @ObservedObject var speechRecognizer: SpeechRecognizer
    let chat: Chat
    @FocusState var isFocused
    
    var body: some View {
        HStack {
            TextField("Ask anything...", text: $viewModel.inputText, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .focused($isFocused)
                .onChange(of: isFocused) { oldValue, newValue in
                    viewModel.isTextInputFocused = newValue
                }
                
            Button {
                Task {
                    speechRecognizer.startTranscribing()
                }
            } label: {
                Image(systemName: "microphone.fill")
                    .tint(.main)
            }
            
            Button {
                Task {
                    do {
                        let userInputText: String = viewModel.inputText
                        
                        speechRecognizer.stopTranscribing()
                        viewModel.inputText = ""
                        speechRecognizer.transcript = ""
                        
                        let questionToGemini = """
                        You are a chat assistant.
                        Respond in a natural, friendly, and clear tone — like a smart teammate.
                        Give answers that are informative and useful.
                        Keep responses concise and clear, but include enough detail to be helpful.
                        Always reply in the same language as the user's **Latest question**, regardless of previous messages.

                        Recent messages: \(viewModel.sortedMessages.suffix(4).map { $0.body })  
                        Latest question: \(userInputText)
                        """
                        
                        viewModel.isAwaitingGeminiResponse = true
                        try await viewModel.saveUserInput(inputText: userInputText)
                        try await viewModel.saveAnswerFromGemini(inputText: questionToGemini)
                        viewModel.isAwaitingGeminiResponse = false
                    } catch {
                        print(error)
                    }
                }
                
                hideKeyboard()
            } label: {
                Text("Send")
                    .foregroundColor(
                        viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                        ? .gray
                        : .main
                    )
            }
            .disabled(viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? true : false)
        }
        .padding([.horizontal, .bottom])
    }
}
