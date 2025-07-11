import Foundation
import SwiftData

struct Dreamon: Codable, Hashable {
    let id: String
    let name: String
    let type: String
    var hp: Int
    var attack: Int
    var defense: Int
    var speed: Int
    let imageURL: String
    
    static let typeEffectiveness: Dictionary<String, [String: Double]> = [
        "Calm": [
            "Storm": 2.0, "Focus": 0.5
        ],
        "Focus": [
            "Calm": 2.0, "Dream": 0.5
        ],
        "Dream": [
            "Focus": 2.0, "Awake": 0.5
        ],
        "Awake": [
            "Dream": 2.0, "Drowsy": 0.5
        ],
        "Drowsy": [
            "Awake": 2.0, "Storm": 0.5
        ],
        "Storm": [
            "Drowsy": 2.0, "Calm": 0.5
        ]
    ]
    
    static let placeholder = Dreamon(
        id: "placeholder",
        name: "Unknown",
        type: "None",
        hp: 0,
        attack: 0,
        defense: 0,
        speed: 0,
        imageURL: ""
    )
}
