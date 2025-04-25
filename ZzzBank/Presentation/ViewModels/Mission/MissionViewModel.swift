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
    static let shared = MissionViewModel()
    private let realm = RealmManager.shared

    @Published var missions: [Mission] = []
    @Published var directionMap: [Int: Set<Direction>] = [:]
    
    var revealedLines: Set<[Int]> = []
    var didFindNewBingo = false
    
    var bingoLines: [[Int]] = [
        [0, 1, 2, 3],
        [4, 5, 6, 7],
        [8, 9, 10, 11],
        [12, 13, 14, 15],
        
        [0, 4, 8, 12],
        [1, 5, 9, 13],
        [2, 6, 10, 14],
        [3, 7, 11, 15],
        
        [0, 5, 10, 15],
        [3, 6, 9, 12]
    ]
    
    private init() {}
    
    func initMissions() {
        let sampleMissions: [Mission] = [
            Mission(title: "Use a Coupon", content: ""),
            Mission(title: "Morning Champion", content: ""),
            Mission(title: "Repayment Rookie", content: ""),
            Mission(title: "Pebble Rescuer", content: ""),
            
            Mission(title: "Big Sleeper Loan", content: ""),
            Mission(title: "3 Days Login", content: ""),
            Mission(title: "Goal Setter", content: ""),
            Mission(title: "Bedtime Pro", content: ""),
            
            Mission(title: "Early Bird", content: ""),
            Mission(title: "7+ Hours Sleep", content: ""),
            Mission(title: "Sleep Loaner", content: ""),
            Mission(title: "Bingo Master", content: ""),
            
            Mission(title: "Midnight Curfew", content: ""),
            Mission(title: "Pebble in Trouble", content: ""),
            Mission(title: "Zero Interest", content: ""),
            Mission(title: "One Line Bingo", content: "")
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
        
        if !mission.completed {
            realm.update(mission) {
                $0.completed = true
            }
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
        if line.allSatisfy({ $0 / 4 == line.first! / 4 }) {
            return .horizontal
        } else if line.allSatisfy({ $0 % 4 == line.first! % 4 }) {
            return .vertical
        } else if line == [0, 5, 10, 15] {
            return .diagonal
        } else if line == [3, 6, 9, 12] {
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
            "Use a Coupon", "Morning Champion", "Repayment Rookie", "Pebble Rescuer", "3 Days Login",
            "Sleep Loaner", "One Line Bingo", "Goal Setter", "Sleep Loaner",
            "Zero Interest"
        ].forEach { completeMission(title: $0) }
    }
}
