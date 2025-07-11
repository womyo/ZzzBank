import Foundation

protocol DreamonUseCase: Sendable {
    func getDreamonList() async throws -> [Dreamon]
    func getDreamon(name: String) async throws -> Dreamon?
    func getRandomDreamon() async throws -> Dreamon
}
