//
//  RealmManager.swift
//  ZzzBank
//
//  Created by 이인호 on 1/8/25.
//

import UIKit
import RealmSwift

protocol DataBase {
    func read<T: Object>(_ object: T.Type) -> Results<T>
    func write<T: Object>(_ object: T)
    func delete<T: Object>(_ object: T)
    func sort<T: Object>(_ object: T.Type, by keyPath: String, ascending: Bool) -> Results<T>
}

final class RealmManager: DataBase {
    static let shared = RealmManager()
    private let realm = try! Realm()
    
    private init() {}
    func read<T: Object>(_ object: T.Type) -> RealmSwift.Results<T> {
        return realm.objects(object)
    }
    
    func write<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.add(object, update: .modified)
            }
        } catch let error {
            print("데이터 저장 시 에러 \(error.localizedDescription)")
        }
    }
    
    func update<T: Object>(_ object: T, completion: @escaping ((T) -> ())) {
        do {
            try realm.write {
                completion(object)
            }
        } catch let error {
            print("데이터 수정 시 에러 \(error.localizedDescription)")
        }
    }
    
    func delete<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch let error {
            print("데이터 삭제 시 에러 \(error.localizedDescription)")
        }
    }
    
    func sort<T: Object>(_ object: T.Type, by keyPath: String, ascending: Bool) -> RealmSwift.Results<T> {
        return realm.objects(object).sorted(byKeyPath: keyPath, ascending: ascending)
    }
    
    func getLocationOfDefaultRealm() {
        print("Realm is located at:", realm.configuration.fileURL!)
    }
}
