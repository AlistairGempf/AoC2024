//
//  day5functionality.swift
//  AoC2024
//
//  Created by Alistair Gempf on 20/12/2024.
//

import Foundation

struct PageOrderingRule {
    let first: Int
    let second: Int
    
    init(from rule: Substring) {
        let vals = rule.split(separator: "|")
        first = Int(vals[0])!
        second = Int(vals[1])!
    }
    
    func test(manualUpdate: ManualUpdate) -> Bool {
        let firstIndex = manualUpdate.pagesOrdered.firstIndex(of: first)
        let secondIndex = manualUpdate.pagesOrdered.firstIndex(of: second)
        guard let firstIndex = firstIndex, let secondIndex = secondIndex else { return true }
        
        return firstIndex < secondIndex
    }
}

struct ManualUpdate {
    let pagesOrdered: [Int]
    var middleElement: Int {
        pagesOrdered[pagesOrdered.count / 2]
    }
    
    init(from input: Substring) {
        pagesOrdered = input.split(separator: ",").map { Int($0)! }
    }
    
    init(pagesOrdered: [Int]) {
        self.pagesOrdered = pagesOrdered
    }
}

struct FirstElementError: Error {}

private func order(update: [Int], using rules: [PageOrderingRule]) -> [Int]? {
    guard update.count > 1 else { return update }
    let firstElement = update.first { val in !rules.contains { $0.second == val } }
    guard let firstElement = firstElement else { return update }
    guard let recursiveArray = order(update: update.filter { $0 != firstElement }, using: rules.filter { $0.first != firstElement }) else { return nil }
    
    return [firstElement] + recursiveArray
}

func day5part1(_ input: String) -> Int {
    let splitSections = input.split(separator: "\n\n")
    let rules = splitSections[0].split(separator: "\n").map(PageOrderingRule.init)
    let manualUpdates = splitSections[1].split(separator: "\n").map(ManualUpdate.init)
    let correctOrdered = manualUpdates.filter { update in rules.allSatisfy { rule in rule.test(manualUpdate: update) } }
    
    return correctOrdered.reduce(0, { acc, curr in acc + curr.middleElement })
}

func day5part2(_ input: String) -> Int {
    let splitSections = input.split(separator: "\n\n")
    let rules = splitSections[0].split(separator: "\n").map(PageOrderingRule.init)
    let manualUpdates = splitSections[1].split(separator: "\n").map(ManualUpdate.init)
    let incorrectOrdered = manualUpdates.filter { update in !rules.allSatisfy { rule in rule.test(manualUpdate: update) } }
    
    let updatesWithRelevantRules = incorrectOrdered.map { update in
        (update, rules.filter { rule in
            update.pagesOrdered.contains(rule.first) && update.pagesOrdered.contains(rule.second)
        })
    }
    
    let ordered = updatesWithRelevantRules.compactMap { order(update: $0.0.pagesOrdered, using: $0.1) }.map { ManualUpdate(pagesOrdered: $0) }
    
    return ordered.reduce(0, { acc, curr in acc + curr.middleElement })
}
