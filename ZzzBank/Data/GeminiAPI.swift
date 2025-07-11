import Foundation
import FirebaseAI

final class GeminiAPI: Sendable {
    private let ai = FirebaseAI.firebaseAI(backend: .googleAI())
    private let model: GenerativeModel
    
    init() {
        self.model = ai.generativeModel(modelName: "gemini-2.0-flash")
    }
    
    func generateContent(prompt: String) async throws -> String {
        let response = try await model.generateContent(prompt)
        
        return response.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "No content generated"
    }
}
