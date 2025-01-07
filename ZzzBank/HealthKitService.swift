//
//  HealthKitService.swift
//  ZzzBank
//
//  Created by 이인호 on 1/7/25.
//

import HealthKit

class HealthKitService {
    let healthStore = HKHealthStore()
    
    let read = Set([HKCategoryType.categoryType(forIdentifier: .sleepAnalysis)!])
    let share = Set([HKCategoryType.categoryType(forIdentifier: .sleepAnalysis)!])
    
    func configure() {
        if HKHealthStore.isHealthDataAvailable() {
            requestAuthorization()
        }
    }
    
    func requestAuthorization() {
        self.healthStore.requestAuthorization(toShare: share, read: read) { success, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if success {
                    print("Authorized")
                } else {
                    print("Not Authorized")
                }
            }
        }
    }
}
