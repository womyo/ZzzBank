import Foundation

final class OnboardingViewModel {
    @Published var goal = 7
    
    func setPersonalSleepGoal() {
        UserDefaults.standard.setValue(goal, forKey: "personSleep")
    }
    
    func setLoanLimit() {
        RealmManager.shared.write(LoanLimit())
    }
}
