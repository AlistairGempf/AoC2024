//
//  day7functionality.swift
//  AoC2024
//
//  Created by Alistair Gempf on 29/12/2024.
//

import Foundation

private struct Calibration {
    let target: Int
    let values: [Int]
    
    init(from line: Substring) {
        let splitLine = line.split(separator: ": ")
        target = Int(splitLine[0])!
        values = splitLine[1].split(separator: " ").map { Int($0)! }
    }
}

private func operate(on calibration: Calibration) -> Bool {
    let head = calibration.values.first!
    let tail = calibration.values.dropFirst()
    let possibleResults = tail.reduce([head], { acc, curr in
        acc.flatMap { [ $0 + curr, $0 * curr ] }.filter { $0 <= calibration.target }
    })
    return possibleResults.contains(calibration.target)
}

private func operate2(on calibration: Calibration) -> Bool {
    let head = calibration.values.first!
    let tail = calibration.values.dropFirst()
    let possibleResults = tail.reduce([head], { acc, curr in
        acc.flatMap { [ $0 + curr, $0 * curr, Int("\(String($0))\(String(curr))")! ] }.filter { $0 <= calibration.target }
    })
    return possibleResults.contains(calibration.target)
}

func day7part1(_ input: String) -> Int {
    let calibrations = input.split(separator: "\n").map { Calibration(from: $0) }
    let operated = calibrations.map { ($0.target, operate(on: $0)) }
    return operated.reduce(0, { acc, curr in
        switch curr.1 {
        case true: acc + curr.0
        case false: acc
        }
    })
}

func day7part2(_ input: String) -> Int {
    let calibrations = input.split(separator: "\n").map { Calibration(from: $0) }
    let operated = calibrations.map { ($0.target, operate2(on: $0)) }
    return operated.reduce(0, { acc, curr in
        switch curr.1 {
        case true: acc + curr.0
        case false: acc
        }
    })
}
