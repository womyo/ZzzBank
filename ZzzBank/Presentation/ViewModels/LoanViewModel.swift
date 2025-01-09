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
}
