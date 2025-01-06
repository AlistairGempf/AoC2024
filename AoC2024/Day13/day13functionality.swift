//
//  day13functionality.swift
//  AoC2024
//
//  Created by Alistair Gempf on 03/01/2025.
//

import Foundation

private extension Position {
    static func /<V> (lhs: Self, rhs: V) -> Self where V: VectorLike {
        Self(x: lhs.x / rhs.x, y: lhs.y / rhs.y)
    }
    
    static func %<V> (lhs: Self, rhs: V) -> Self where V: VectorLike {
        Self(x: lhs.x % rhs.x, y: lhs.y % rhs.y)
    }
}

private struct ClawMachine {
    let buttonA: Vector
    let buttonB: Vector
    let target: Position
    
    static func getButtonVector(from buttonString: Substring) -> Vector {
        let buttonX = Int(buttonString.split(separator: "X+")[1].split(separator: ",")[0])!
        let buttonY = Int(buttonString.split(separator: "Y+")[1])!
        return Vector(x: buttonX, y: buttonY)
    }
    
    static func getTargetPosition(from targetString: Substring) -> Position {
        let targetX = Int(targetString.split(separator: "X=")[1].split(separator: ",")[0])!
        let targetY = Int(targetString.split(separator: "Y=")[1])!
        return Position(x: targetX, y: targetY)
    }
    
    static func getPart2TargetPosition(from targetString: Substring) -> Position {
        let targetX = Int(targetString.split(separator: "X=")[1].split(separator: ",")[0])!
        let targetY = Int(targetString.split(separator: "Y=")[1])!
        return Position(x: targetX + 10000000000000, y: targetY + 10000000000000)
    }
    
    init(from machineString: Substring) {
        let info = machineString.split(separator: "\n")
        buttonA = Self.getButtonVector(from: info[0])
        buttonB = Self.getButtonVector(from: info[1])
        target = Self.getTargetPosition(from: info[2])
    }
    
    init(fromPart2 machineString: Substring) {
        let info = machineString.split(separator: "\n")
        buttonA = Self.getButtonVector(from: info[0])
        buttonB = Self.getButtonVector(from: info[1])
        target = Self.getPart2TargetPosition(from: info[2])
    }
}

private func findMaxBPresses(for machine: ClawMachine) -> Int {
    let maxBPressesVec = (machine.target / machine.buttonB)
    return min(maxBPressesVec.x, maxBPressesVec.y)
}

private func canCompleteGivenNumberOfB(pressingB times: Int, for machine: ClawMachine) -> Int? {
    let aTarget = machine.target - (machine.buttonB * times)
    guard aTarget % machine.buttonA == Position(x: 0, y: 0) else { return nil }
    let aPresses = aTarget / machine.buttonA
    guard aPresses.x == aPresses.y else { return nil }
    return aPresses.x
}

private func getNumberPresses(for machine: ClawMachine, pressingB times: Int) -> (a: Int, b: Int)? {
    guard times > -1 else { return nil }
    let aPresses = canCompleteGivenNumberOfB(pressingB: times, for: machine)
    guard let aPresses = aPresses else { return getNumberPresses(for: machine, pressingB: times - 1) }
    return (aPresses, times)
}

private func getNumberPresses(for machine: ClawMachine) -> (a: Int, b: Int)? {
    getNumberPresses(for: machine, pressingB: findMaxBPresses(for: machine))
}

func day13part1(_ input: String) -> Int {
    let unparsedMachines = input.split(separator: "\n\n")
    let machines = unparsedMachines.map { ClawMachine(from: $0) }
    let winnableMachines = machines.compactMap(getNumberPresses)
    
    return winnableMachines.reduce(0, { $0 + $1.a * 3 + $1.b })
}

private func substitution(for machine: ClawMachine) -> (a: Int, b: Int)? {
    let b = Double(machine.target.x * machine.buttonA.y - machine.target.y * machine.buttonA.x) / Double(machine.buttonB.x * machine.buttonA.y - machine.buttonB.y * machine.buttonA.x)
    let a = (Double(machine.target.x) - b * Double(machine.buttonB.x)) / Double(machine.buttonA.x)
    let res = (Int(exactly: a), Int(exactly: b))
    switch res {
    case (nil, _): return nil
    case (_, nil): return nil
    case (let a, let b):
        guard a! >= 0, b! >= 0 else { return nil }
        return (a!, b!)
    }
}

func day13part2(_ input: String) -> Int {
    let unparsedMachines = input.split(separator: "\n\n")
    let machines = unparsedMachines.map { ClawMachine(fromPart2: $0) }
    let winnableMachines = machines.compactMap(substitution)
    
    return winnableMachines.reduce(0, { $0 + $1.a * 3 + $1.b })
}
