//
//  OnboardingViewModel.swift
//  ZzzBank
//
//  Created by wayblemac02 on 4/8/25.
//

import Foundation

final class OnboardingViewModel {
    @Published var value = 7
    
    func setPersonalSleepGoal(_ goal: Int) {
        UserDefaults.standard.setValue(goal, forKey: "personSleep")
    }
}
