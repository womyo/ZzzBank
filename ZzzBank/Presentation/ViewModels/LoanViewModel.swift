//
//  LoanViewModel.swift
//  ZzzBank
//
//  Created by 이인호 on 1/8/25.
//

import Foundation
import RealmSwift

enum RecordType: String {
    case all = "All"
    case borrowed = "Borrowed"
    case repaid = "Repaid"
}

enum RecordSort: String {
    case ascend = "Ascend"
    case descend = "Descend"
}

final class LoanViewModel: ObservableObject {
    private let realm = RealmManager.shared
    @Published var timeValue: CGFloat = 0.0
    @Published var loanRecords = []
    @Published var combinedRecords: [DateSortable] = []
    @Published var combinedRecordsForDict: [Date: [DateSortable]] = [:]
    var combinedRecordsCount: Int = 0
    @Published var keys: [Date] = []
    @Published var condition: Condition = .healthy
    
    var selectedPath1: IndexPath = IndexPath(row: 1, section: 0)
    var selectedPath2: IndexPath = IndexPath(row: 0, section: 0)
    var selectedPath3: IndexPath = IndexPath(row: 0, section: 0)
    
    var recordType: RecordType = .all
    var recordSort: RecordSort = .ascend
    
    func saveLoan() {
        let loan = LoanRecord()
        loan.loanTime = Int(timeValue)
        loan.loanTimeCP = Int(timeValue)
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
            let interest = Double(loanRecord.loanTimeCP) * Double(overdueDays) * 0.2
            let roundedInterest = Int(round(interest))
            loanRecord.overdueInterest += roundedInterest
        }
    }
    
    func getDebt() -> Int {
        let loanRecords = realm.read(LoanRecord.self)
        
        return loanRecords.reduce(0) { $0 + $1.overdueInterest }
    }
    
    func saveRepayment(_ amount: Int) {
        let repayment = RepayRecord()
        repayment.repayTime = amount
        realm.write(repayment)
    }
    
    func getRepaymentRecords() -> Results<RepayRecord> {
        return realm.read(RepayRecord.self)
    }
    
    func getCombinedRecords(type: RecordType) {
        switch type {
        case .all:
            let loanRecords = getLoanRecords()
            let repayRecords = getRepaymentRecords()
            
            combinedRecords = Array(loanRecords) + Array(repayRecords)
        case .borrowed:
            combinedRecords = Array(getLoanRecords())
        case .repaid:
            combinedRecords = Array(getRepaymentRecords())
        }
        combinedRecords = combinedRecords.sorted { $0.date > $1.date }
    }
    
    func changeCombinedRepaymentsToDict(type: RecordType, sort: RecordSort) {
        getCombinedRecords(type: type)
        
        combinedRecordsForDict.removeAll()
        combinedRecordsCount = 0
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        let monthAgo = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
        let today = Date()
        
        for record in combinedRecords {
            let recordDate = Calendar.current.startOfDay(for: record.date)
            
            if monthAgo < recordDate && recordDate < today {
                if !combinedRecordsForDict.keys.contains(recordDate) {
                    combinedRecordsForDict[recordDate] = []
                }
                combinedRecordsForDict[recordDate]?.append(record)
                combinedRecordsCount += 1
            }
        }
        
        switch sort {
        case .ascend:
            keys = Array(combinedRecordsForDict.keys).sorted(by: >)
        case .descend:
            keys = Array(combinedRecordsForDict.keys).sorted(by: <)
        }
    }
    func payLoad(amount: Int) {
        let loanLimit = realm.read(LoanLimit.self)[0]
        let loanRecords = realm.read(LoanRecord.self)
        var remainingAmount = amount
        
        saveRepayment(amount)
        
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
                if remainingAmount > 0 && loanRecord.loanTimeCP > 0 {
                    if remainingAmount >= loanRecord.loanTimeCP {
                        remainingAmount -= loanRecord.loanTimeCP
                        loanLimit.limitTime += loanRecord.loanTimeCP
                        loanRecord.loanTimeCP = 0
                        shouldDelete = true
                    } else {
                        loanRecord.loanTimeCP -= remainingAmount
                        loanLimit.limitTime += remainingAmount
                        remainingAmount = 0
                    }
                }
            }
            
            if shouldDelete {
                NotificationManager.shared.removeNotification(identifier: loanRecord.id) // 이미 갚은 대출은 알림 삭제
            }
        }
    }
}
