//
//  day14functionality.swift
//  AoC2024
//
//  Created by Alistair Gempf on 03/01/2025.
//

import Foundation

//let MAX = (x: 11, y: 7)
let MAX = (x: 101, y: 103)

private extension Position {
    static func % (lhs: Position, rhs: (x: Int, y: Int)) -> Position {
        Position(x: lhs.x % rhs.x, y: lhs.y % rhs.y)
    }
}

private struct Robot {
    let startingPositon: Position
    let velocity: Velocity
    
    init(from startingString: Substring) {
        let split = startingString.split(separator: " ")
        let position = split[0].dropFirst(2).split(separator: ",").map { Int($0)! }
        let velo = split[1].dropFirst(2).split(separator: ",").map { Int($0)! }
        startingPositon = Position(x: position[0], y: position[1])
        velocity = Velocity(x: velo[0], y: velo[1])
    }
    
    func getPosition(at second: Int) -> Position {
        (((startingPositon + velocity * second) % MAX) + Position(x: MAX.x, y: MAX.y)) % MAX
    }
}

func day14part1(_ input: String) -> Int {
    let split = input.split(separator: "\n")
    let robots = split.map { Robot(from: $0) }
    let robotsAt100s = robots.map { $0.getPosition(at: 100) }
    let midX = (MAX.x - 1) / 2
    let midY = (MAX.y - 1) / 2
    
    let topRobots = robotsAt100s.filter { $0.y < midY }
    let bottomRobots = robotsAt100s.filter { $0.y > midY }
    
    let topRight = topRobots.filter { $0.x > midX }
    let topLeft = topRobots.filter { $0.x < midX }
    let bottomRight = bottomRobots.filter { $0.x > midX }
    let bottomLeft = bottomRobots.filter { $0.x < midX }
    
    return topRight.count * topLeft.count * bottomLeft.count * bottomRight.count
}

private func visualiseRobots(at positions: [Position]) {
    for y in 0..<MAX.y {
        for x in 0..<MAX.x {
            if positions.contains(Position(x: x, y: y)) { print("X", terminator: "") }
            else { print(".", terminator: "") }
        }
        print()
    }
}

private func findChristmasTree(of robots: [Robot], startingAt time: Int = 1) -> Int {
    let positions = robots.map { $0.getPosition(at: time) }
    let robotsWithNeighbours = positions.filter { position in
        let potentialNeighbouringPositions = Vector.allNonDiagonalDirections().map { position + $0 }
        return potentialNeighbouringPositions.contains { potentialNeighbour in positions.contains(potentialNeighbour) }
    }
    
    // Just in case I miss it
    if robotsWithNeighbours.count > 200 {
        print(time)
        print(robotsWithNeighbours.count)
        visualiseRobots(at: positions)
    } else if time % 100 == 0 {
        print(time)
    }
    
    // I imagine this counts as most
    if robotsWithNeighbours.count > 300 { return time }
    else { return findChristmasTree(of: robots, startingAt: time + 1) }
}

func day14part2(_ input: String) -> Int {
    let split = input.split(separator: "\n")
    let robots = split.map { Robot(from: $0) }
    return findChristmasTree(of: robots, startingAt: 2000)
}
