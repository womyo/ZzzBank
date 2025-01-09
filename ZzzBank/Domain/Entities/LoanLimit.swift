//
//  LoanLimit.swift
//  ZzzBank
//
//  Created by 이인호 on 1/9/25.
//

import Foundation
import RealmSwift

final class LoanLimit: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var limitTime: Int = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
