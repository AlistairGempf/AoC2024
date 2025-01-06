//
//  day10functionality.swift
//  AoC2024
//
//  Created by Alistair Gempf on 31/12/2024.
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
    
    static func from(vector: Vector) -> TravellingDirection? {
        switch vector {
        case Vector(x: 0, y: -1): .up
        case Vector(x: 1, y: 0): .right
        case Vector(x: 0, y: 1): .down
        case Vector(x: -1, y: 0): .left
        default: nil
        }
    }
}

private struct Location: Hashable {
    let position: Position
    let value: Int
}

private func findRoute(from location: Location, steppingTo value: Int, within locations: [Location]) -> Set<Location> {
    guard value < 10 else { return Set([location]) }
    
    let allDirections = Vector.allNonDiagonalDirections()
    
    let validLocations = allDirections.map { location.position + $0 }.compactMap { newPosition in locations.first { newPosition == $0.position } }.filter { $0.value == value }
    
    return validLocations.map { findRoute(from: $0, steppingTo: value + 1, within: locations) }.reduce(Set(), { acc, curr in acc.union(curr) })
}

private func findRating(from location: Location, steppingTo value: Int, within locations: [Location]) -> Int {
    guard value < 10 else { return 1 }
    
    let allDirections = Vector.allNonDiagonalDirections()
    
    let validLocations = allDirections.map { location.position + $0 }.compactMap { newPosition in locations.first { newPosition == $0.position } }.filter { $0.value == value }
    
    return validLocations.map { findRating(from: $0, steppingTo: value + 1, within: locations) }.reduce(0, +)
}

func day10part1(_ input: String) -> Int {
    let splitInput = input.split(separator: "\n").enumerated().flatMap({ (index, val) in
        val.enumerated().map { (index: index, offset: Int($0.offset), element: Int(String($0.element))!) }
    })
    let locations = splitInput.map { Location(position: Position(x: $0.offset, y: $0.index), value: $0.element) }
    
    let zeroes = locations.filter { $0.value == 0 }
    
    let trailheads = zeroes.map { findRoute(from: $0, steppingTo: 1, within: locations) }
    
    return trailheads.reduce(0, { $0 + $1.count })
}

func day10part2(_ input: String) -> Int {
    let splitInput = input.split(separator: "\n").enumerated().flatMap({ (index, val) in
        val.enumerated().map { (index: index, offset: Int($0.offset), element: Int(String($0.element))!) }
    })
    let locations = splitInput.map { Location(position: Position(x: $0.offset, y: $0.index), value: $0.element) }
    
    let zeroes = locations.filter { $0.value == 0 }
    
    let trailheads = zeroes.map { findRating(from: $0, steppingTo: 1, within: locations) }
    
    return trailheads.reduce(0, +)
}
