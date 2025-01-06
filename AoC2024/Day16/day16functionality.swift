//
//  day16functionality.swift
//  AoC2024
//
//  Created by Alistair Gempf on 05/01/2025.
//

import Foundation

private enum TravellingDirection: String, CaseIterable {
    case up = "^", right = ">", down = "v", left = "<"
    
    func getVector() -> Vector {
        switch self {
        case .up: Vector(x: 0, y: -1)
        case .right: Vector(x: 1, y: 0)
        case .down: Vector(x: 0, y: 1)
        case .left: Vector(x: -1, y: 0)
        }
    }
    
    func getAcceptableNext() -> Set<TravellingDirection> {
        switch self {
        case .up, .down: [.right, .left]
        case .left, .right: [.up, .down]
        }
    }
}

private struct Reindeer: Hashable {
    let position: Position
    let direction: TravellingDirection
}

private func depthFirst(reindeer: Reindeer, aimingFor target: Position, in walls: Set<Position>, previouslyVisiting: [Reindeer]) -> Set<[Reindeer]> {
    if reindeer.position == target { return [previouslyVisiting + [reindeer]] }
    if previouslyVisiting.contains(reindeer) { return Set([previouslyVisiting]) }
    
    let nextPosition = reindeer.position + reindeer.direction.getVector()
    if walls.contains(nextPosition) { return reindeer.direction.getAcceptableNext().map { depthFirst(reindeer: Reindeer(position: reindeer.position, direction: $0), aimingFor: target, in: walls, previouslyVisiting: previouslyVisiting + [reindeer]). }.map { $0 } }
}

func day16part1(_ input: String) -> Int {
    let splitInput = input.split(separator: "\n").enumerated().flatMap({ (index, val) in
        val.enumerated().map { (index: index, offset: Int($0.offset), element: String($0.element)) }
    }).map { (position: Position(x: $0.offset, y: $0.index), element: $0.element) }
    
    let walls = Set(splitInput.filter { $0.element == "#" }.map { $0.position })
    
    let startReindeer = Reindeer(position: splitInput.first { $0.element == "S" }!.position, direction: .right)
    let target = splitInput.first { $0.element == "E" }!.position
    
    return 0
}
