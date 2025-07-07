import Foundation

@MainActor
final class GeminiViewModel: ObservableObject {
    @Published var text: String = ""
    private let api: GeminiAPI
    
    init(api: GeminiAPI) {
        self.api = api
    }
    
    func generateContent(prompt: String) async throws {
        text = try await api.generateContent(prompt: prompt)
    }
}
