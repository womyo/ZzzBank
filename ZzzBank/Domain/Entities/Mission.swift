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
    @objc dynamic var horizontal: Bool = false
    @objc dynamic var vertical: Bool = false
    @objc dynamic var diagonal: Bool = false
    @objc dynamic var reverseDiagonal: Bool = false
    
    override static func primaryKey() -> String? {
         return "id"
    }
    
    convenience init(title: String, content: String) {
        self.init()
        self.title = title
        self.content = content
    }
}
