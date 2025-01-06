//
//  day15functionality.swift
//  AoC2024
//
//  Created by Alistair Gempf on 04/01/2025.
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
}

private extension Vector {
    static func | (lhs: Vector, rhs: Vector) -> Bool {
        if rhs == Vector(x: 0, y: 0) || lhs == Vector(x: 0, y: 0) { return lhs == rhs }
        if rhs.x == 0 { return lhs.x == 0 && lhs.y / abs(lhs.y) == rhs.y / abs(rhs.y) }
        if rhs.y == 0 { return lhs.y == 0 && lhs.x / abs(lhs.x) == rhs.x / abs(rhs.x) }
        let xMultiplier = Double(lhs.x) / Double(rhs.x)
        let yMultiplier = Double(lhs.y) / Double(rhs.y)
        return xMultiplier == yMultiplier && xMultiplier >= 0
    }
}

private protocol Boxy {
    var positions: Set<Position> { get }
    static func + (lhs: Self, rhs: Vector) -> Self
}

private protocol Positioned: Hashable {
    var position: Position { get }
}

private struct Wall: Positioned {
    let position: Position
}

private struct Robot {
    let position: Position
}

private struct Box: Positioned, Boxy {
    let position: Position
    var gpsScore: Int { position.y * 100 + position.x }
    var positions: Set<Position> { Set([position]) }
    
    static func + (lhs: Self, rhs: Vector) -> Self {
        return Box(position: lhs.position + rhs)
    }
}

private func getInDirection(from robot: Robot, travelling direction: Vector, in positioned: Set<Wall>) -> Set<Wall> {
    positioned.filter { ($0.position - robot.position) | direction  }
}

// I know this isn't correct, but one of the vector values is ALWAYS 0, so I'm utilising that
private func getDistance<P>(of positioned: P, from robot: Robot) -> Int where P: Positioned {
    let vector = positioned.position - robot.position
    return abs(vector.x + vector.y)
}

private func getClosestWallInDirection(from robot: Robot, travelling direction: Vector, in walls: Set<Wall>) -> Wall {
    let wallsInDirection = getInDirection(from: robot, travelling: direction, in: walls)
    return wallsInDirection.min { first, second in
        getDistance(of: first, from: robot) < getDistance(of: second, from: robot)
    }!
}

// Recursive version seems to ONLY work in release mode. I suspect this is because it does Tail Call Optimisation (TCO) which it doesn't (I guess?) in debug mode
// Oddly, it's _very_ fast in release mode
private func moveRecursion(robot: Robot, along instructions: [TravellingDirection], with boxes: Set<Box>, in walls: Set<Wall>) -> (robot: Robot, boxes: Set<Box>, walls: Set<Wall>) {
    guard let instruction = instructions.first?.getVector() else { return (robot, boxes, walls) }
    
    let remainingInstructions = Array(instructions.dropFirst())
    let nextPotentialRobotPosition = robot.position + instruction
    let closestWall = getClosestWallInDirection(from: robot, travelling: instruction, in: walls)
    guard nextPotentialRobotPosition != closestWall.position else { return moveRecursion(robot: robot, along: remainingInstructions, with: boxes, in: walls) }
    
    if !boxes.contains(Box(position: nextPotentialRobotPosition)) { return moveRecursion(robot: Robot(position: nextPotentialRobotPosition), along: remainingInstructions, with: boxes, in: walls) }
    
    let potentialBoxChain = Array(1..<getDistance(of: closestWall, from: robot)).map { robot.position + instruction * $0 }
    let firstChainBreak = potentialBoxChain.firstIndex { !boxes.contains(Box(position: $0)) }
    if let firstChainBreak = firstChainBreak {
        let actualBoxChain = potentialBoxChain.dropLast(potentialBoxChain.count - firstChainBreak)
        let newBoxes = boxes.subtracting([Box(position: nextPotentialRobotPosition)]).union([Box(position: actualBoxChain.last! + instruction)])
        return moveRecursion(robot: Robot(position: nextPotentialRobotPosition), along: remainingInstructions, with: newBoxes, in: walls)
    } else {
        return moveRecursion(robot: robot, along: remainingInstructions, with: boxes, in: walls)
    }
}

func day15part1(_ input: String) -> Int {
    let initialSplit = input.split(separator: "\n\n")
    let mapString = initialSplit[0]
    let instructionString = initialSplit[1].replacingOccurrences(of: "\n", with: "")
    
    let instructions = instructionString.map { TravellingDirection(rawValue: String($0))! }
    
    let splitInput = mapString.split(separator: "\n").enumerated().flatMap({ (index, val) in
        val.enumerated().map { (index: index, offset: Int($0.offset), element: String($0.element)) }
    }).map { (position: Position(x: $0.offset, y: $0.index), element: $0.element) }
    
    let walls = Set(splitInput.filter { $0.element == "#" }.map { Wall(position: $0.position) })
    let initBoxes = Set(splitInput.filter { $0.element == "O" }.map { Box(position: $0.position) })
    let robot = Robot(position: splitInput.first { $0.element == "@" }!.position)
    
    let (finalRobot, finalBoxes, finalWalls) = moveRecursionPart2(robot: robot, along: instructions, with: initBoxes, in: walls)
    visualise(robot: finalRobot, boxes: finalBoxes, walls: finalWalls)
    
    return finalBoxes.reduce(0, { $0 + $1.gpsScore })
}

private struct WideBox: Hashable, Boxy {
    let positions: Set<Position>
    var gpsScore: Int { positions.min { $0.y < $1.y }!.y * 100 + positions.min { $0.x < $1.x }!.x }
    var leftEdge: Position { positions.min { $0.x < $1.x }! }
    
    init(position: Position) {
        let leftEdge = position
        let rightEdge = position + Vector(x: 1, y: 0)
        self.positions = [leftEdge, rightEdge]
    }
    
    private init(positions: Set<Position>) {
        self.positions = positions
    }
    
    static func + (box: WideBox, _ direction: Vector) -> WideBox {
        WideBox(positions: Set(box.positions.map { $0 + direction }))
    }
}

private func visualise<B>(robot: Robot, boxes: Set<B>, walls: Set<Wall>) where B: Boxy {
    for y in walls.min(by: { $0.position.y < $1.position.y })!.position.y ... walls.max(by: { $0.position.y < $1.position.y })!.position.y {
        for x in walls.min(by: { $0.position.x < $1.position.x })!.position.x ... walls.max(by: { $0.position.x < $1.position.x })!.position.x {
            if walls.contains(Wall(position: Position(x: x, y: y))) { print("#", terminator: "") }
            else if boxes.contains(where: { $0.positions.contains(Position(x: x, y: y)) }) { print("O", terminator: "")}
            else if robot.position == Position(x: x, y: y) { print("@", terminator: "") }
            else { print(".", terminator: "") }
        }
        print()
    }
    print()
}

private func canMove<B>(box: B, in direction: Vector, within walls: Set<Wall>, otherBoxes: Set<B>) -> (canMove: Bool, alsoMoving: Set<B>) where B: Boxy {
    let nextBox = box + direction
    guard !nextBox.positions.contains(where: { nextBoxPosition in walls.contains(Wall(position: nextBoxPosition)) }) else { return (false, Set()) }
    
    let chainedBoxes = Set(nextBox.positions.compactMap { nextBoxPosition in
        otherBoxes.first { $0.positions.contains(nextBoxPosition) }
    }).subtracting([box])
    
    let isMovable = chainedBoxes.map { canMove(box: $0, in: direction, within: walls, otherBoxes: otherBoxes) }
    
    return isMovable.reduce((canMove: true, alsoMoving: Set([box])), { acc, curr in
        guard acc.canMove else { return (false, Set()) }
        return (acc.canMove && curr.canMove, acc.alsoMoving.union(curr.alsoMoving))
    })
}

private func canMove<B>(robot: Robot, in direction: Vector, with boxes: Set<B>, within walls: Set<Wall>) -> (canMove: Bool, alsoMoving: Set<B>) where B: Boxy {
    let nextPosition = robot.position + direction
    guard !walls.contains(Wall(position: nextPosition)) else { return (false, Set()) }
    
    let nextBox = boxes.first(where: { $0.positions.contains(nextPosition) })
    guard let nextBox = nextBox else { return (true, Set()) }
    return canMove(box: nextBox, in: direction, within: walls, otherBoxes: boxes)
}

// See comment about part 1
private func moveRecursionPart2<B>(robot: Robot, along instructions: [TravellingDirection], with boxes: Set<B>, in walls: Set<Wall>) -> (robot: Robot, boxes: Set<B>, walls: Set<Wall>) where B: Boxy {
    guard let instruction = instructions.first?.getVector() else { return (robot, boxes, walls) }
    let remainingInstructions = Array(instructions.dropFirst())
    
    let (robotCanMove, movingBoxes) = canMove(robot: robot, in: instruction, with: boxes, within: walls)
    
    guard robotCanMove else { return moveRecursionPart2(robot: robot, along: remainingInstructions, with: boxes, in: walls) }
    let newBoxes = boxes.subtracting(movingBoxes).union(movingBoxes.map { $0 + instruction })
    let newRobot = Robot(position: robot.position + instruction)
    return moveRecursionPart2(robot: newRobot, along: remainingInstructions, with: newBoxes, in: walls)
}

func day15part2(_ input: String) -> Int {
    let initialSplit = input.split(separator: "\n\n")
    let mapString = initialSplit[0]
    let instructionString = initialSplit[1].replacingOccurrences(of: "\n", with: "")
    
    let instructions = instructionString.map { TravellingDirection(rawValue: String($0))! }
    
    let splitInput = mapString.split(separator: "\n").enumerated().flatMap({ (index, val) in
        val.enumerated().map { (index: index, offset: Int($0.offset), element: String($0.element)) }
    }).map { (position: Position(x: $0.offset * 2, y: $0.index), element: $0.element) }
    
    let walls = Set(splitInput.filter { $0.element == "#" }.flatMap { [Wall(position: Position(x: $0.position.x, y: $0.position.y)), Wall(position: Position(x: $0.position.x + 1, y: $0.position.y))] })
    let initBoxes = Set(splitInput.filter { $0.element == "O" }.map { WideBox(position: $0.position) })
    let robot = Robot(position: splitInput.first { $0.element == "@" }!.position)
    
    let (finalRobot, finalBoxes, finalWalls) = moveRecursionPart2(robot: robot, along: instructions, with: initBoxes, in: walls)
    visualise(robot: finalRobot, boxes: finalBoxes, walls: finalWalls)
    
    return finalBoxes.reduce(0, { $0 + $1.gpsScore })
}
