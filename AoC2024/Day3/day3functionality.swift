//
//  day3functionality.swift
//  AoC2024
//
//  Created by Alistair Gempf on 13/12/2024.
//

import Foundation

func day3part1(_ inputValues: String) -> Int {
    let regex = /mul\(([0-9]+),([0-9]+)\)/
    return inputValues.matches(of: regex).map { Int($0.output.1)! * Int($0.output.2)! }.reduce(0, +)
}

func day3part2(_ inputValues: String) -> Int {
    let regex = /mul\([0-9]+,[0-9]+\)|don't|do/
    
    return inputValues.matches(of: regex).reduce((0, true), { (acc, curr) in
        guard curr.output != "don't" else { return (acc.0, false) }
        guard curr.output != "do" else { return (acc.0, true) }
        guard acc.1 else { return acc }
        let ints = curr.output.dropFirst(4).dropLast().split(separator: ",").map{ Int($0)! }
        return (acc.0 + ints[0] * ints[1], acc.1)
    }).0
}
