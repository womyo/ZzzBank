//
//  MissionViewModel.swift
//  ZzzBank
//
//  Created by wayblemac02 on 4/11/25.
//

import Foundation
import RealmSwift

enum LineDirection {
    case horizontal, vertical, diagonal, reverseDiagonal
}

final class MissionViewModel {
    private let realm = RealmManager.shared
    @Published var missions: [Mission] = []
    var bingoIndexes = [[0,1,2,3,4], [0,6,12,18,24]]
    @Published var bingoLineMap: [Int: Set<LineDirection>] = [:]

    func initMissions() {
        let tempMissions: [Mission] = [
            Mission(title: "First Debt", content: ""),
            Mission(title: "First Repay", content: ""),
            Mission(title: "Three Days Log", content: ""),
            Mission(title: "No Delay", content: ""),
            Mission(title: "Use a Coupon", content: ""),
            Mission(title: "7 Hours Sleep", content: ""),
            Mission(title: "Reset Used", content: ""),
            Mission(title: "5AM Challenge", content: ""),
            Mission(title: "Early Bird", content: ""),
            Mission(title: "Sleep on Time", content: ""),
            Mission(title: "Weekend Saver", content: ""),
            Mission(title: "Zero Interest", content: ""),
            Mission(title: "Sleep Twice", content: ""),
            Mission(title: "5 Days Streak", content: ""),
            Mission(title: "Max Fatigue", content: ""),
            Mission(title: "Silent Night", content: ""),
            Mission(title: "Full Repay", content: ""),
            Mission(title: "Quick Nap", content: ""),
            Mission(title: "Debt Master", content: ""),
            Mission(title: "No Sleep Debt", content: ""),
            Mission(title: "One Line Bingo", content: ""),
            Mission(title: "Five Minutes More", content: ""),
            Mission(title: "Dream Keeper", content: ""),
            Mission(title: "No Alarm Win", content: ""),
            Mission(title: "Perfect Week", content: "")
        ]
        
        tempMissions.forEach { mission in
            realm.write(mission)
        }
    }
    
    func getMissions() {
        missions = Array(realm.read(Mission.self))
    }
    
    func getMission(_ title: String) -> Results<Mission> {
        let mission = realm.read(Mission.self).filter("title == %@", "\(title)")
        
        return mission
    }
    
    func completeMission(title: String) {
        if let mission = getMission(title).first {
            realm.update(mission) { mission in
                mission.completed = true
            }
        } else {
            print("Cannot find mission")
        }
    }
    
    func direction(for indexes: [Int]) -> LineDirection? {
        if indexes.allSatisfy({ $0 / 5 == indexes.first! / 5 }) {
            return .horizontal
        } else if indexes.allSatisfy({ $0 % 5 == indexes.first! % 5 }) {
            return .vertical
        } else if indexes == [0, 6, 12, 18, 24] {
            return .diagonal
        } else if indexes == [4, 8, 12, 16, 20] {
            return .reverseDiagonal
        } else {
            return nil
        }
    }
    
    func isBingo() {
        for bingo in bingoIndexes {
            if bingo.allSatisfy({ missions[$0].completed }), let dir = direction(for: bingo) {
                for index in bingo {
                    bingoLineMap[index, default: []].insert(dir)
                }
            }
        }
    }
}
