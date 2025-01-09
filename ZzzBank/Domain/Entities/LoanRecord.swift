//
//  LoanTime.swift
//  ZzzBank
//
//  Created by 이인호 on 1/8/25.
//

import Foundation
import RealmSwift

final class LoanRecord: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var loanTime: Int = 0
    @objc dynamic var date: Date = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

