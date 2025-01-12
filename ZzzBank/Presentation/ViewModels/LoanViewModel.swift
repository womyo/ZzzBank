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
        loan.loanTime = timeValue
        realm.write(loan)
    }

    func getLoanLimit() -> CGFloat {
        let loanLimit = realm.read(LoanLimit.self)[0]
        
        return CGFloat(loanLimit.limitTime)
    }
    
    func updateLoanLimit() {
        let loanLimit = realm.read(LoanLimit.self)[0]
        
        realm.update(loanLimit) { loanLimit in
            loanLimit.limitTime -= self.timeValue
        }
    }
    
    func getLoanRecords() -> Results<LoanRecord> {
        return realm.read(LoanRecord.self)
    }
    
    func updateLoanRecords(index: Int, overdueDays: Int) {
        let loanRecord = realm.read(LoanRecord.self)[index]
        
        realm.update(loanRecord) { loanRecord in
            loanRecord.overdueInterest += Double(loanRecord.loanTime) * Double(overdueDays) * 0.2
        }
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
                        remainingAmount -= loanRecord.overdueInterest
                        loanRecord.overdueInterest = 0
                    } else {
                        loanRecord.overdueInterest -= remainingAmount
                        remainingAmount = 0
                    }
                }
                
                // 원금(잠) 상환
                if remainingAmount > 0 && loanRecord.loanTime > 0 {
                    if remainingAmount >= loanRecord.loanTime {
                        remainingAmount -= loanRecord.loanTime
                        loanLimit.limitTime += loanRecord.loanTime
                        loanRecord.loanTime = 0
                        shouldDelete = true
                    } else {
                        loanRecord.loanTime -= remainingAmount
                        loanLimit.limitTime += remainingAmount
                        remainingAmount = 0
                    }
                }
            }
            
            if shouldDelete {
                self.realm.delete(loanRecord)
            }
        }
    }
}
