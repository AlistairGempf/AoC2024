//
//  main.swift
//  AoC2024
//
//  Created by Alistair Gempf on 13/12/2024.
//

import Foundation

private struct DampenedSafety {
    let isSafe: (Bool, Bool)
    let value: Int?
    let prevValue: Int?
}

private let safeUp: (Int?, Int) -> Bool = { (prevVal, currVal) in
    guard let prevVal = prevVal else { return true }
    return currVal > prevVal && currVal - prevVal <= 3
}
private let safeDown: (Int?, Int) -> Bool = { (prevVal, currVal) in
    guard let prevVal = prevVal else { return true }
    return currVal < prevVal && prevVal - currVal <= 3
}

private func checkDampenedSafety(prev: DampenedSafety, next: Int, safetyFunc: (Int?, Int) -> Bool) -> DampenedSafety {
    let naturalSafe = safetyFunc(prev.value, next)
    let dampenedSafe = safetyFunc(prev.prevValue, next)
    return DampenedSafety(
        isSafe: (naturalSafe, dampenedSafe),
        value: next,
        prevValue: prev.value
    )
}

private func checkReportSafetyDampened(acc: (safe: Bool, prevSafe: (Bool, Bool), hasBeenDampened: Bool), curr: DampenedSafety) -> (safe: Bool, prevSafe: (Bool, Bool), hasBeenDampened: Bool) {
    guard acc.safe else { return (safe: acc.safe, prevSafe: curr.isSafe, hasBeenDampened: acc.hasBeenDampened) }
    if !acc.hasBeenDampened {
        switch (acc.prevSafe, curr.isSafe) {
        case ((true, _), (_, _)): return (safe: acc.safe, prevSafe: curr.isSafe, hasBeenDampened: acc.hasBeenDampened)
        case ((false, true), (true, _)): return (safe: acc.safe, prevSafe: curr.isSafe, hasBeenDampened: true)
        case ((false, false), (_, true)): return (safe: acc.safe, prevSafe: curr.isSafe, hasBeenDampened: true)
            
        case ((false, true), (false, true)): return (safe: acc.safe, prevSafe: (true, true), hasBeenDampened: true)
            
        case ((false, false), (_, false)): return (safe: false, prevSafe: curr.isSafe, hasBeenDampened: true)
        case ((false, true), (false, false)): return (safe: false, prevSafe: curr.isSafe, hasBeenDampened: true)
        }
    } else {
        switch (acc.prevSafe, curr.isSafe) {
        case ((true, _), (true, _)): return (safe: acc.safe, prevSafe: curr.isSafe, hasBeenDampened: acc.hasBeenDampened)
        case ((_, true), (true, _)): return (safe: true, prevSafe: curr.isSafe, hasBeenDampened: true)
        case ((false, false), _): return (safe: false, prevSafe: curr.isSafe, hasBeenDampened: acc.hasBeenDampened)
        case ((false, _), (false, _)): return (safe: false, prevSafe: curr.isSafe, hasBeenDampened: acc.hasBeenDampened)
        case ((true, _), (false, _)): return (safe: false, prevSafe: curr.isSafe, hasBeenDampened: acc.hasBeenDampened)
        }
    }
}

func day2part1(_ inputVals: String) -> Int {
    let splitVals = inputVals.split(separator: "\n").map { $0.split(separator: " ").map { Int($0)! } }
    
    let safetyOfReports = splitVals.map { report in
        let initValue: (prevVal: Int?, isSafeUp: Bool, isSafeDown: Bool) = (prevVal: nil, isSafeUp: true, isSafeDown: true)
        return report.reduce(initValue, { (acc, curr) in (prevVal: curr, isSafeUp: acc.isSafeUp && safeUp(acc.prevVal, curr), acc.isSafeDown && safeDown(acc.prevVal, curr)) })
    }
    
    return safetyOfReports.filter({ $0.isSafeDown || $0.isSafeUp }).count
}

func day2part2(_ inputVals: String) -> Int {
    let splitVals = inputVals.split(separator: "\n").map { $0.split(separator: " ").map { Int($0)! } }
    
    let safetyOfReports = splitVals.map { report in
        let initValue = [(
            isSafeUp: DampenedSafety(isSafe: (true, true), value: nil, prevValue: nil),
            isSafeDown: DampenedSafety(isSafe: (true, true), value: nil, prevValue: nil)
        )]
        return report.reduce(initValue, { (acc, curr) in
            let isSafeUp = checkDampenedSafety(prev: acc.last!.isSafeUp, next: curr, safetyFunc: safeUp)
            let isSafeDown = checkDampenedSafety(prev: acc.last!.isSafeDown, next: curr, safetyFunc: safeDown)
            return acc + [(isSafeUp: isSafeUp, isSafeDown: isSafeDown)]
        })
    }
    
    let dampenedSafety = safetyOfReports.map { report in
        report.reduce((
                isSafeUp: (safe: true, prevSafe: (true, true), hasBeenDampened: false),
                isSafeDown: (safe: true, prevSafe: (true, true), hasBeenDampened: false)
            ) , { (acc, curr) in
            let isSafeUp = checkReportSafetyDampened(acc: acc.isSafeUp, curr: curr.isSafeUp)
            let isSafeDown = checkReportSafetyDampened(acc: acc.isSafeDown, curr: curr.isSafeDown)
            return (isSafeUp: isSafeUp, isSafeDown: isSafeDown)
        })
    }
    
    return dampenedSafety.filter({ $0.isSafeDown.safe || $0.isSafeUp.safe }).count
}
