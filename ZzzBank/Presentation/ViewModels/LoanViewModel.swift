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
            loanLimit.limitTime -= Int(self.timeValue)
        }
    }
    
    func getLoanRecords() -> Results<LoanRecord> {
        return realm.read(LoanRecord.self)
    }
    
    func updateLoanRecords(index: Int, overdueDays: Int) {
        let loanRecord = realm.read(LoanRecord.self)[index]
        var overdueInterest: Double = 0
        
        realm.update(loanRecord) { loanRecord in
            for i in 1...overdueDays {
                overdueInterest += Double(loanRecord.loanTime) * Double(i) * 0.2
            }
            loanRecord.overdueInterest = overdueInterest
        }
    }
    
    func payLoad(index: Int, amount: Double) {
        let loanRecord = realm.read(LoanRecord.self)[index]
        var remainingAmount = amount
        
        realm.update(loanRecord) { loanRecord in
            if loanRecord.overdueInterest > 0 {
                if remainingAmount >= loanRecord.overdueInterest {
                    remainingAmount -= loanRecord.overdueInterest
                    loanRecord.overdueInterest = 0
                } else {
                    loanRecord.overdueInterest -= remainingAmount
                    remainingAmount = 0
                }
            }
            
            if remainingAmount > 0 && loanRecord.loanTime > 0 {
                if remainingAmount >= loanRecord.loanTime {
                    loanRecord.loanTime = 0
                } else {
                    loanRecord.loanTime -= remainingAmount
                }
            }
        }
    }
}
