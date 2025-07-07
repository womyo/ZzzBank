//
//  GeminiAPI.swift
//  Swift6
//
//  Created by wayblemac02 on 6/10/25.
//

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
        
        return response.text ?? "No content generated"
    }
}
