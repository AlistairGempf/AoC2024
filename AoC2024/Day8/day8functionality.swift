//
//  day8functionality.swift
//  AoC2024
//
//  Created by Alistair Gempf on 29/12/2024.
//

import Foundation

private enum Antenna {
    case empty, antenna(String)
}

private struct Location: Equatable {
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.position == rhs.position
    }
    
    let position: Position
    let content: Antenna
    var frequency: String? {
        switch content {
        case .empty: nil
        case .antenna(let freq): freq
        }
    }
    
    init(position: (x: Int, y: Int), content: String) {
        self.position = Position(x: position.x, y: position.y)
        self.content = switch content {
        case ".": .empty
        default: .antenna(content)
        }
    }
}

private func getAntinodePosition(for antenna: Location, past matching: Location) -> Position? {
    switch (antenna.content, matching.content) {
    case (.antenna(let freqL), .antenna(let freqR)):
        guard freqL == freqR else { return nil }
        return antenna.position + (matching.position - antenna.position) * 2
    default: return nil
    }
}

private func getResonantAntinodePositions(for antenna: Location, past matching: Location, at distance: Int, in positions: Set<Position>, including previous: [Position]) -> [Position] {
    switch (antenna.content, matching.content) {
    case (.antenna(let freqL), .antenna(let freqR)):
        guard freqL == freqR else { return [] }
        let newPosition = antenna.position + (matching.position - antenna.position) * distance
        guard positions.contains(newPosition) else { return previous }
        return getResonantAntinodePositions(
            for: antenna,
            past: matching,
            at: distance + 1,
            in: positions,
            including: previous + [newPosition]
        )
    default: return []
    }
}

func day8part1(_ input: String) -> Int {
    let splitInput = input.split(separator: "\n").enumerated().flatMap({ (index, val) in
        val.enumerated().map { (index: index, offset: Int($0.offset), element: String($0.element)) }
    })
    let locations = splitInput.map { Location(position: (x: $0.offset, y: $0.index), content: $0.element) }
    let validPositions = Set(locations.map { $0.position })
    
    let antennas = locations.filter({ $0.frequency != nil })
    
    let antinodes = antennas.flatMap { antenna in
        let otherAntennas = antennas.filter { $0.frequency == antenna.frequency && $0.position != antenna.position }
        return otherAntennas.compactMap { getAntinodePosition(for: antenna, past: $0) }
    }
    
    let validAntinodes = Set(antinodes).intersection(validPositions)
    
    return validAntinodes.count
}

func day8part2(_ input: String) -> Int {
    let splitInput = input.split(separator: "\n").enumerated().flatMap({ (index, val) in
        val.enumerated().map { (index: index, offset: Int($0.offset), element: String($0.element)) }
    })
    let locations = splitInput.map { Location(position: (x: $0.offset, y: $0.index), content: $0.element) }
    let validPositions = Set(locations.map { $0.position })
    let antennas = locations.filter({ $0.frequency != nil })
    
    let antinodes = antennas.flatMap { antenna in
        let otherAntennas = antennas.filter { $0.frequency == antenna.frequency && $0.position != antenna.position }
        return otherAntennas.flatMap { getResonantAntinodePositions(for: antenna, past: $0, at: 1, in: validPositions, including: []) }
    }
    
    let validAntinodes = Set(antinodes)
    return validAntinodes.count
}
