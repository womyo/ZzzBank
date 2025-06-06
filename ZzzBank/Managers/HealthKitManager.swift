//
//  HealthKitService.swift
//  ZzzBank
//
//  Created by 이인호 on 1/7/25.
//

import HealthKit

class HealthKitManager {
    static let shared = HealthKitManager()
    let healthStore = HKHealthStore()
    
    let read = Set([HKCategoryType.categoryType(forIdentifier: .sleepAnalysis)!])
    let share = Set([HKCategoryType.categoryType(forIdentifier: .sleepAnalysis)!])
    
    private init() {}
    
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
    
    func getSleepData(completion: @escaping (Int) -> Void) {
        var totalSleep = 0.0
        if let sleepType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis) {
            let calander = Calendar.current
            let endDate = Date()
            let startDate = calander.date(byAdding: .day, value: -1, to: endDate)
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: 1000, sortDescriptors: [sortDescriptor]) { (query, tmpResult, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                if let result = tmpResult {
                    for item in result {
                        if let sample = item as? HKCategorySample, sample.value != 2 {
                            let timeInterval = sample.endDate.timeIntervalSince(sample.startDate)
                            totalSleep += timeInterval
                        }
                    }
                }
                
                let totalSleepToHour: Int = Int(round(totalSleep / 3600))
                completion(totalSleepToHour)
            }
            healthStore.execute(query)
        } else {
            completion(0)
        }
    }
}
