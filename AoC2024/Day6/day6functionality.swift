//
//  day6functionality.swift
//  AoC2024
//
//  Created by Alistair Gempf on 20/12/2024.
//

import Foundation

private enum Content: String {
    case empty = ".", obstruction = "#"
}

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
    
    func next() -> TravellingDirection {
        switch self {
        case .up: .right
        case .right: .down
        case .down: .left
        case .left: .up
        }
    }
}

struct Position: VectorLike, Hashable, Equatable {
    let x: Int
    let y: Int
    
    static func + (lhs: Self, rhs: Self) -> Vector {
        Vector(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    static func - (lhs: Self, rhs: Self) -> Vector {
        Vector(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
}

private struct Location: Hashable {
    let position: Position
    let content: Content
    
    init(position: (x: Int, y: Int), content: String) {
        self.position = Position(x: position.x, y: position.y)
        self.content = switch content {
        case "#": .obstruction
        default: .empty
        }
    }
}

private struct Guard: Hashable {
    let location: Position
    let direction: TravellingDirection
    
    func distance(from pathLocation: Location) -> Int? {
        switch direction {
        case .up:
            guard pathLocation.position.x == location.x else { return nil }
            return (location - pathLocation.position).y
        case .right:
            guard pathLocation.position.y == location.y else { return nil }
            return (pathLocation.position - location).x
        case .down:
            guard pathLocation.position.x == location.x else { return nil }
            return (pathLocation.position - location).y
        case .left:
            guard pathLocation.position.y == location.y else { return nil }
            return (location - pathLocation.position).x
        }
    }
}

private func getGuard(from splitInput: [(index: Int, offset: Int, element: String)]) -> Guard {
    let guardInputValue = splitInput.first { input in TravellingDirection.allCases.map { $0.rawValue }.contains(input.element) }!
    return Guard(location: Position(x: guardInputValue.offset, y: guardInputValue.index), direction: TravellingDirection(rawValue: guardInputValue.element)!)
}

private func step(guardPerson: Guard, in locations: Dictionary<Position, Location>, visited: Set<Guard>) -> Set<Guard> {
    let nextPosition = guardPerson.location + guardPerson.direction.getVector()
    let nextLocation = locations[nextPosition]
    guard let nextLocation = nextLocation else { return visited }
    switch nextLocation.content {
    case .empty:
        let newVisited = visited.union([Guard(location: nextPosition, direction: guardPerson.direction)])
        return step(guardPerson: Guard(location: nextPosition, direction: guardPerson.direction), in: locations, visited: newVisited)
    case .obstruction:
        return step(guardPerson: Guard(location: guardPerson.location, direction: guardPerson.direction.next()), in: locations, visited: visited)
    }
}

private func stepInLoop(guardPerson: Guard, in locations: [Position:Location], visited: Set<Guard>) -> Bool {
    let obstructions = locations.filter { $0.value.content == .obstruction }.map { $0.value }
    let obstructionsInPath: [(Location, Int)] = obstructions.compactMap { obstruction in
        guard let distance = guardPerson.distance(from: obstruction), distance > 0 else { return nil }
        return (obstruction, distance)
    }
    let nextObstruction = obstructionsInPath.min { $0.1 < $1.1 }
    guard let nextObstruction = nextObstruction else { return false }
    let nextPosition = nextObstruction.0.position + guardPerson.direction.getVector() * -1
    let nextGuard = Guard(location: nextPosition, direction: guardPerson.direction.next())
    guard !visited.contains(nextGuard) else { return true }
    return stepInLoop(guardPerson: nextGuard, in: locations, visited: visited.union([nextGuard]))
}

func day6part1(_ input: String) -> Int {
    let splitInput = input.split(separator: "\n").enumerated().flatMap({ (index, val) in
        val.enumerated().map { (index: index, offset: Int($0.offset), element: String($0.element)) }
    })
    let locations = splitInput.map { Location(position: (x: $0.offset, y: $0.index), content: $0.element) }
    let locationsDict = Dictionary(uniqueKeysWithValues: locations.map { ($0.position, $0) })
    let initialGuard = getGuard(from: splitInput)
    
    return Set(step(guardPerson: initialGuard, in: locationsDict, visited: Set([initialGuard])).map { $0.location }).count
}

func day6part2(_ input: String) -> Int {
    let splitInput = input.split(separator: "\n").enumerated().flatMap({ (index, val) in
        val.enumerated().map { (index: index, offset: Int($0.offset), element: String($0.element)) }
    })
    let locations = splitInput.map { Location(position: (x: $0.offset, y: $0.index), content: $0.element) }
    let locationsDict = Dictionary(uniqueKeysWithValues: locations.map { ($0.position, $0) })
    let initialGuard = getGuard(from: splitInput)
    
    let usualPositions = Set(step(guardPerson: initialGuard, in: locationsDict, visited: Set()).map { $0.location })
    
    let results = usualPositions.map {
        (location: $0, looped: stepInLoop(
            guardPerson: initialGuard,
            in: locationsDict.merging([$0: Location(position: ($0.x, $0.y), content: "#")], uniquingKeysWith: { $1 }),
            visited: Set()))
    }
    
    let nonFirstGuardLoops = results.filter { $0.location != initialGuard.location }
    
    return nonFirstGuardLoops.filter { $0.looped }.count
}
