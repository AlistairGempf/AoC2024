//
//  main.swift
//  AoC2024
//
//  Created by Alistair Gempf on 13/12/2024.
//

import Foundation

private func split(values: String) -> [(Int, Int)] {
    values.split(separator: "\n").map{$0.split(separator: "   ")}.map{(Int($0[0])!, Int($0[1])!)}
}

func day1part1(_ inputVals: String) -> Int {
    let splitValues = split(values: inputVals)
    let firstValues = splitValues.map { $0.0 }.sorted()
    let secondValues = splitValues.map { $0.1 }.sorted()
    return zip(firstValues, secondValues).reduce(0, { (acc, val) in acc + abs(val.0 - val.1)})
}

func day1part2(_ inputVals: String) -> Int {
    let splitValues = split(values: inputVals)
    let firstValues = splitValues.map { $0.0 }
    let secondValues = splitValues.map { $0.1 }
    
    return firstValues.reduce(0, { (acc, curr) in acc + curr * secondValues.filter { $0 == curr }.count})
}
