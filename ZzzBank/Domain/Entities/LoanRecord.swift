//
//  LoanTime.swift
//  ZzzBank
//
//  Created by 이인호 on 1/8/25.
//

import Foundation
import RealmSwift

protocol DateSortable {
    var date: Date { get }
}

final class LoanRecord: Object, DateSortable {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var loanTime: Int = 0
    @objc dynamic var loanTimeCP: Int = 0
    @objc dynamic var overdueInterest: Int = 0
    @objc dynamic var date = Date()
    @objc dynamic var repaymentDate: Date = {
        let current = Date()
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: 0, to: current)!
    }()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

