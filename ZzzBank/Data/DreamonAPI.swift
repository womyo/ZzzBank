import Foundation
import FirebaseCore
@preconcurrency import FirebaseFirestore

final class DreamonAPI: DreamonUseCase {
    private let db = Firestore.firestore()
    
    func getDreamonList() async throws -> [Dreamon] {
        let querySnapshot = try await db.collection("Dreamon").getDocuments()
        
        let dreamonList = try querySnapshot.documents.map { document in
            return try document.data(as: Dreamon.self)
        }
//        let dreamonList = try querySnapshot.documents.map { try $0.data(as: Dreamon.self) }
        
        return Array(dreamonList.shuffled().prefix(6))
    }
    
    func getDreamon(name: String) async throws -> Dreamon? {
        let querySnapshot = try await db.collection("Dreamon")
            .whereField("name", isEqualTo: name)
            .limit(to: 1)
            .getDocuments()
        
        guard let doc = querySnapshot.documents.first else {
            print("Cannot find dreamon")
            return nil
        }
        
        return try doc.data(as: Dreamon.self)
    }
    
    func getRandomDreamon() async throws -> Dreamon {
        let querySnapshot = try await db.collection("Dreamon").getDocuments()
        
        let dreamonList = try querySnapshot.documents.map { document in
            return try document.data(as: Dreamon.self)
        }
        
        return dreamonList.randomElement()!
    }
}
