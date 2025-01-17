//
//  LoanViewModel.swift
//  ZzzBank
//
//  Created by 이인호 on 1/8/25.
//

import Foundation
import RealmSwift

final class LoanViewModel: ObservableObject {
    private let realm = RealmManager.shared
    @Published var timeValue: CGFloat = 0.0
    @Published var loanRecords = []
    
    func saveLoan() {
        let loan = LoanRecord()
        loan.loanTime = Int(timeValue)
        realm.write(loan)
        
        NotificationManager.shared.scheduleNotification(id: loan.id, endDate: loan.date) // 대출 마감 당일에 알람 등록
    }

    func getLoanLimit() -> Int {
        let loanLimit = realm.read(LoanLimit.self)[0]
        
        return loanLimit.limitTime
    }
    
    func updateLoanLimit() {
        let loanLimit = realm.read(LoanLimit.self)[0]
        
        realm.update(loanLimit) { loanLimit in
            loanLimit.limitTime -= Int(self.timeValue)
        }
    }
    
    func getLoanRecords() -> Results<LoanRecord> {
        return realm.read(LoanRecord.self)
    }
    
    func updateLoanRecords(index: Int, overdueDays: Int) {
        let loanRecord = realm.read(LoanRecord.self)[index]
        
        realm.update(loanRecord) { loanRecord in
            let interest = Double(loanRecord.loanTime) * Double(overdueDays) * 0.2
            let roundedInterest = round(interest * 10) / 10
            loanRecord.overdueInterest += roundedInterest
        }
    }
    
    func getDebt() -> Double {
        let loanRecords = realm.read(LoanRecord.self)
        
        return loanRecords.reduce(0.0) { $0 + $1.overdueInterest }
    }
    
    func payLoad(amount: Double) {
        let loanLimit = realm.read(LoanLimit.self)[0]
        let loanRecords = realm.read(LoanRecord.self)
        var remainingAmount = amount
        
        for loanRecord in loanRecords {
            var shouldDelete = false
            guard remainingAmount > 0 else { return }
            
            realm.update(loanRecord) { loanRecord in
                // 연체 이자 상환
                if loanRecord.overdueInterest > 0 {
                    if remainingAmount >= loanRecord.overdueInterest {
                        remainingAmount = round((remainingAmount - loanRecord.overdueInterest) * 10) / 10
                        loanRecord.overdueInterest = 0
                    } else {
                        loanRecord.overdueInterest = round((loanRecord.overdueInterest - remainingAmount) * 10) / 10
                        remainingAmount = 0
                    }
                }
                
                // 원금(잠) 상환
                if remainingAmount > 0 && loanRecord.loanTime > 0 {
                    if remainingAmount >= Double(loanRecord.loanTime) {
                        remainingAmount -= Double(loanRecord.loanTime)
                        loanLimit.limitTime += loanRecord.loanTime
                        loanRecord.loanTime = 0
                        shouldDelete = true
                    } else {
                        loanRecord.loanTime -= Int(round(remainingAmount))
                        loanLimit.limitTime += Int(round(remainingAmount))
                        remainingAmount = 0
                    }
                }
            }
            
            if shouldDelete {
                self.realm.delete(loanRecord)
                NotificationManager.shared.removeNotification(identifier: loanRecord.id) // 이미 갚은 대출은 알림 삭제
            }
        }
    }
}
