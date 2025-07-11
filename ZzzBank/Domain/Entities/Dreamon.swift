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
        "Hunter": [
            "Phantom": 2.0, "Comfort": 0.5
        ],
        "Phantom": [
            "Dream": 2.0, "Snack": 0.5
        ],
        "Dream": [
            "Sleep": 2.0, "Hunter": 0.5
        ],
        "Sleep": [
            "Comfort": 2.0, "Snack": 0.5
        ],
        "Comfort": [
            "Snack": 2.0, "Hunter": 0.5
        ],
        "Snack": [
            "Hunter": 2.0, "Phantom": 0.5
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
