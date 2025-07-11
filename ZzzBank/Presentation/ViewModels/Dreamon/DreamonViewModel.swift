import Foundation

@MainActor
final class DreamonViewModel: ObservableObject {
    private let usecase: DreamonUseCase
    private let api: GeminiAPI
    
    @Published var dreamonList: [Dreamon] = []
    
    @Published var dreamon: Dreamon?
    @Published var hp = 0
    @Published var damage: Int?
    @Published var showDamage = false
    
    @Published var enemyDreamon: Dreamon?
    @Published var enemyHp = 0
    @Published var enemyDamage: Int?
    @Published var showEnemyDamage = false
    
    @Published var showBattleResult: Bool = false
    @Published var isInBattle: Bool = false
    @Published var didUsePass: Bool = false
    
    @Published var isSheetPresented: Bool = false
    @Published var selectedIndex = 0
    
    @Published var battleResultText: String = ""
    @Published var isLoadingForBattleResult = false
    
    init(usecase: DreamonUseCase, api: GeminiAPI) {
        self.usecase = usecase
        self.api = api
    }
    
    func getDreamonList() async {
        do {
            dreamonList = try await usecase.getDreamonList()
            dreamon = dreamonList.first
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getDreamon() async throws -> Dreamon {
        return try await usecase.getRandomDreamon()
    }
    
    func battle() async {
        do {
            var isTurn = true
            if enemyDreamon == nil || enemyHp == 0 {
                enemyDreamon = try await getDreamon()
                enemyHp = enemyDreamon!.hp
            }
            
            guard let dreamon = dreamon, let enemyDreamon = enemyDreamon else { return }
            
            if dreamon.speed > enemyDreamon.speed {
                isTurn = true
            } else {
                isTurn = false
            }
            
            isInBattle = true
            var turns = [hp]
            var enemyTurns = [enemyHp]
            
            while true {
                if Task.isCancelled {
                    isInBattle = false
                    break
                }
                
                if hp <= 0 {
                    let prompt = """
                    Based on the following Pokémon battle result, generate a concise and analytical one-line summary.

                    - Winner: \(enemyDreamon.name)
                    - Loser: \(dreamon.name)

                    [Battle Info]
                    - \(enemyDreamon.name): HP \(enemyDreamon.hp), Attack \(enemyDreamon.attack), Defense \(enemyDreamon.defense), Type \(enemyDreamon.type)
                    - \(dreamon.name): HP \(dreamon.hp), Attack \(dreamon.attack), Defense \(dreamon.defense), Type \(dreamon.type)
                    - \(enemyDreamon.name)’s HP progression: \(enemyTurns.map { String($0) }.joined(separator: " → "))
                    - \(dreamon.name)’s HP progression: \(turns.map { String($0) }.joined(separator: " → "))

                    Requirements:
                    - Write in **one single sentence with 25 words or fewer**
                    - Use an **objective and analytical tone**
                    - Highlight the **key reason or tactical difference** that determined the outcome
                    - Include both "\(enemyDreamon.name)" and "\(dreamon.name)" by name in the sentence
                    - Do **not** use bullet points, explanations, or additional context outside the sentence
                    """
                    
                    do {
                        isLoadingForBattleResult = true
                        try await generateContent(prompt: prompt)
                        isLoadingForBattleResult = false
                    } catch {
                        print("Error while generating content: \(error.localizedDescription)")
                    }
                    
                    showBattleResult = true
                    isInBattle = false
                    
                    if turns.count != enemyTurns.count {
                        enemyTurns.append(enemyHp)
                    }
                    break
                }
                
                if enemyHp <= 0 {
                    let prompt = """
                    Based on the following Pokémon battle result, generate a concise and analytical one-line summary.

                    - Winner: \(dreamon.name)
                    - Loser: \(enemyDreamon.name)

                    [Battle Info]
                    - \(dreamon.name): HP \(dreamon.hp), Attack \(dreamon.attack), Defense \(dreamon.defense), Type \(dreamon.type)
                    - \(enemyDreamon.name): HP \(enemyDreamon.hp), Attack \(enemyDreamon.attack), Defense \(enemyDreamon.defense), Type \(enemyDreamon.type)
                    - \(dreamon.name)’s HP progression: \(turns.map { String($0) }.joined(separator: " → "))
                    - \(enemyDreamon.name)’s HP progression: \(enemyTurns.map { String($0) }.joined(separator: " → "))

                    Requirements:
                    - Write in **one single sentence with 25 words or fewer**
                    - Use an **objective and analytical tone**
                    - Highlight the **key reason or tactical difference** that determined the outcome
                    - Include both "\(dreamon.name)" and "\(enemyDreamon.name)" by name in the sentence
                    - Do **not** use bullet points, explanations, or additional context outside the sentence
                    """
                    
                    do {
                        isLoadingForBattleResult = true
                        try await generateContent(prompt: prompt)
                        isLoadingForBattleResult = false
                    } catch {
                        print("Error while generating content: \(error.localizedDescription)")
                    }
                    
                    showBattleResult = true
                    isInBattle = false
                    
                    if turns.count != enemyTurns.count {
                        turns.append(hp)
                    }
                    break
                }
                
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                
                if isTurn {
                    damage = calculateDamage(attack: dreamon.attack, defense: enemyDreamon.defense, defenderHP: enemyDreamon.hp, typeMultiplier: Dreamon.typeEffectiveness[dreamon.type]?[enemyDreamon.type] ?? 1.0)
                    enemyDamage = nil
                    showDamage = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.showDamage = false
                    }
                    
                    enemyHp = max(0, enemyHp - damage!)
                    enemyTurns.append(enemyHp)
                } else {
                    enemyDamage = calculateDamage(attack: enemyDreamon.attack, defense: dreamon.defense, defenderHP: dreamon.hp, typeMultiplier: Dreamon.typeEffectiveness[enemyDreamon.type]?[dreamon.type] ?? 1.0)
                    damage = nil
                    showEnemyDamage = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.showEnemyDamage = false
                    }
                    
                    hp = max(0, hp - enemyDamage!)
                    turns.append(hp)
                }
                
                isTurn = !isTurn
            }
        } catch {
            print("Error while in battle: \(error.localizedDescription)")
        }
    }
    
    func calculateDamage(attack: Int, defense: Int, defenderHP: Int, typeMultiplier: Double) -> Int {
        let attack = Double(attack)
        let defense = Double(defense)
        
        var damage = (attack / defense) * 20
        
        let randomFactor = Double.random(in: 0.9...1.1)
        damage *= randomFactor
        
        damage *= typeMultiplier
        
        let minDamage = Double(defenderHP) * 0.1
        damage = max(damage, minDamage)
        
        return Int(damage.rounded())
    }
    
    func generateContent(prompt: String) async throws {
        battleResultText = try await api.generateContent(prompt: prompt)
    }
}
