//
//  MissionViewModel.swift
//  ZzzBank
//
//  Created by wayblemac02 on 4/11/25.
//

import Foundation
import RealmSwift

enum Direction {
    case horizontal, vertical, diagonal, reverseDiagonal
}

final class MissionViewModel {
    private let realm = RealmManager.shared
    
    @Published var missions: [Mission] = []
    @Published var directionMap: [Int: Set<Direction>] = [:]
    
    var revealedLines: Set<[Int]> = []
    var didFindNewBingo = false
    
    var bingoLines: [[Int]] = [
        [0, 1, 2, 3, 4],
        [5, 6, 7, 8, 9],
        [10, 11, 12, 13, 14],
        [15, 16, 17, 18, 19],
        [20, 21, 22, 23, 24],
        
        [0, 5, 10, 15, 20],
        [1, 6, 11, 16, 21],
        [2, 7, 12, 17, 22],
        [3, 8, 13, 18, 23],
        [4, 9, 14, 19, 24],
        
        [0, 6, 12, 18, 24],
        [4, 8, 12, 16, 20]
    ]
    
    func initMissions() {
        let sampleMissions: [Mission] = [
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
        
        sampleMissions.forEach { mission in
            realm.write(mission)
        }
    }
    
    func loadMissions() {
        missions = Array(realm.read(Mission.self))
    }
    
    func loadMission(title: String) -> Results<Mission> {
        return realm.read(Mission.self).filter("title == %@", "\(title)")
    }
    
    func completeMission(title: String) {
        guard let mission = loadMission(title: title).first else {
            print("Cannot find mission")
            return
        }
        
        realm.update(mission) {
            $0.completed = true
        }
    }
    
    func setMissionDirections(_ title: String, _ horizontal: Bool, _ vertical: Bool, _ diagonal: Bool, _ reverseDiagonal: Bool) {
        guard let mission = loadMission(title: title).first else {
            print("Cannot find mission")
            return
        }
        
        realm.update(mission) {
            $0.horizontal = $0.horizontal || horizontal
            $0.vertical = $0.vertical || vertical
            $0.diagonal = $0.diagonal || diagonal
            $0.reverseDiagonal = $0.reverseDiagonal || reverseDiagonal
        }
    }
    
    func direction(for line: [Int]) -> Direction? {
        if line.allSatisfy({ $0 / 5 == line.first! / 5 }) {
            return .horizontal
        } else if line.allSatisfy({ $0 % 5 == line.first! % 5 }) {
            return .vertical
        } else if line == [0, 6, 12, 18, 24] {
            return .diagonal
        } else if line == [4, 8, 12, 16, 20] {
            return .reverseDiagonal
        } else {
            return nil
        }
    }
    
    func checkBingo(at index: Int) {
        didFindNewBingo = false
        
        for line in bingoLines {
            if line.contains(index),
               line.allSatisfy({ missions[$0].completed }),
               !revealedLines.contains(line),
               let dir = direction(for: line) {

                if (missions[index].horizontal && dir == .horizontal) ||
                    (missions[index].vertical && dir == .vertical) ||
                    (missions[index].diagonal && dir == .diagonal) ||
                    (missions[index].reverseDiagonal && dir == .reverseDiagonal) {
                    break
                }
                
                revealedLines.insert(line)
                didFindNewBingo = true
                
                for index in line {
                    directionMap[index, default: []].insert(dir)
                    
                    setMissionDirections(
                        missions[index].title,
                        dir == .horizontal,
                        dir == .vertical,
                        dir == .diagonal,
                        dir == .reverseDiagonal
                    )
                }
            }
        }
    }
    
    func completeMockMissions() {
        [
            "First Debt", "Reset Used", "Sleep Twice", "Debt Master", "Perfect Week",
            "First Repay", "Three Days Log", "No Delay", "Use a Coupon",
            "Early Bird", "5 Days Streak", "No Alarm Win"
        ].forEach { completeMission(title: $0) }
    }
}
