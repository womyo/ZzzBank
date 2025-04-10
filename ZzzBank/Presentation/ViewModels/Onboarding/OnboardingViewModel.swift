//
//  OnboardingViewModel.swift
//  ZzzBank
//
//  Created by wayblemac02 on 4/8/25.
//

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
