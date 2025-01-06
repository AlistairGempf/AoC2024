//
//  day11functionality.swift
//  AoC2024
//
//  Created by Alistair Gempf on 31/12/2024.
//

import Foundation

private struct Stone: Hashable {
    let value: Int
}

private typealias BlinkRule = (Stone) -> (modified: Bool, stone: [Stone])

private func zeroRule(original: Stone) -> (modified: Bool, stone: [Stone]) {
    guard original.value == 0 else { return (false, [original]) }
    return (true, [Stone(value: 1)])
}
private func evenDigitRule(original: Stone) -> (modified: Bool, stone: [Stone]) {
    let stringValue = String(original.value)
    guard stringValue.count % 2 == 0 else { return (false, [original]) }
    let halfSplit = stringValue.count / 2
    let firstHalf = Int(stringValue.dropLast(halfSplit))!
    let secondHalf = Int(stringValue.dropFirst(halfSplit))!
    return (true, [Stone(value: firstHalf), Stone(value: secondHalf)])
}
private func fallback(original: Stone) -> (modified: Bool, stone: [Stone]) {
    return (true, [Stone(value: original.value * 2024)])
}

private let rules = [zeroRule, evenDigitRule, fallback]

private func apply(_ rules: [BlinkRule], to stone: Stone) -> [Stone] {
    let result: (modified: Bool, stone: [Stone]) = rules.reduce((modified: false, stone: [stone]), { acc, curr in
        guard !acc.modified else { return acc }
        return curr(stone)
    })
    return result.stone
}

private func blink(stones: [Stone]) -> [Stone] {
    stones.flatMap { stone in
            apply(rules, to: stone)
    }
}

private func blink(times: Int, stones: [Stone]) -> [Stone] {
    guard times > 0 else { return stones }
    return blink(times: times - 1, stones: blink(stones: stones))
}

// This is using the slower implementation because it was quick enough for 25 iterations
func day11part1(_ input: String) -> Int {
    let stones = input.split(separator: " ").map { Stone(value: Int($0)!) }
    let finalStones = blink(times: 25, stones: stones)
    return finalStones.count
}

// These implementations are much quicker
private func blink(stones: [Stone:Int]) -> [Stone:Int] {
    return stones.map { stone in
        let res = apply(rules, to: stone.key)
        return res.reduce([Stone:Int](), { acc, curr in acc.merging([(curr, stone.value)], uniquingKeysWith: { first, last in first + last })})
    }.reduce([Stone:Int](), { acc, curr in acc.merging(curr, uniquingKeysWith: { first, last in first + last })})
}

private func blink(times: Int, stones: [Stone:Int]) -> [Stone:Int] {
    guard times > 0 else { return stones }
    return blink(times: times - 1, stones: blink(stones: stones))
}

func day11part2(_ input: String) -> Int {
    let stones = input.split(separator: " ").map { Stone(value: Int($0)!) }.reduce([Stone:Int](), { acc, curr in acc.merging([curr:1], uniquingKeysWith: { $0 + $1 }) })
    let finalStones = blink(times: 75, stones: stones)
    return finalStones.reduce(0, { acc, curr in acc + curr.value })
}
