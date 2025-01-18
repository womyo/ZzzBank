//
//  RepayRecord.swift
//  ZzzBank
//
//  Created by 이인호 on 1/18/25.
//

import Foundation
import RealmSwift

final class RepayRecord: Object, DateSortable {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var repayTime: Double = 0.0
    @objc dynamic var date: Date = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
