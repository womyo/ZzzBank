//
//  Mission.swift
//  ZzzBank
//
//  Created by wayblemac02 on 4/11/25.
//

import Foundation
import RealmSwift

final class Mission: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var title: String = ""
    @objc dynamic var content: String = ""
    @objc dynamic var completed: Bool = false
    
    override static func primaryKey() -> String? {
         return "id"
    }
    
    convenience init(title: String, content: String) {
        self.init()
        self.title = title
        self.content = content
    }
}
