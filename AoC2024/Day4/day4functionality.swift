//
//  day4functionality.swift
//  AoC2024
//
//  Created by Alistair Gempf on 13/12/2024.
//

import Foundation

struct Search {
    let initialPoint: (x: Int, y: Int)
    let direction: SearchVector
}

struct SearchVector {
    let x: Int
    let y: Int
    static func allDirections() -> [SearchVector] {
        [
            SearchVector(x: -1, y: -1), SearchVector(x: 0, y: -1), SearchVector(x: +1, y: -1),
            SearchVector(x: -1, y:  0),                            SearchVector(x: +1, y:  0),
            SearchVector(x: -1, y: +1), SearchVector(x: 0, y: +1), SearchVector(x: +1, y: +1),
        ]
    }
    
    static func * (lhs: SearchVector, rhs: Int) -> SearchVector { SearchVector(x: lhs.x * rhs, y: lhs.y * rhs) }
}

enum LetterValue {
    case X, M, A, S, other
    
    static func from(character: Character) -> LetterValue {
        switch character {
        case "X", "x": return LetterValue.X
        case "M", "m": return LetterValue.M
        case "A", "a": return LetterValue.A
        case "S", "s": return LetterValue.S
        case _: return LetterValue.other
        }
    }
}

struct Letter {
    let position: (x: Int, y: Int)
    let letterValue: LetterValue
    
    init(position: (x: Int, y: Int), letterValue: Character) {
        self.position = position
        self.letterValue = LetterValue.from(character: letterValue)
    }
    
    static func + (lhs: Letter, rhs: SearchVector) -> (x: Int, y: Int) { (x: lhs.position.x + rhs.x, y: lhs.position.y + rhs.y) }
    static func == (lhs: Letter, rhs: (x: Int, y: Int)) -> Bool { lhs.position.x == rhs.x && lhs.position.y == rhs.y }
}

let xmas = [LetterValue.X, LetterValue.M, LetterValue.A, LetterValue.S]

private func doSearch(in letters: [Letter], on search: Search, index: Int) -> Bool {
    guard index < 4 else { return true }
    let vector = search.direction * index
    let nextPosition = (x: search.initialPoint.x + vector.x, y: search.initialPoint.y + vector.y)
    let nextValueExists = letters.contains { $0.letterValue == xmas[index] && $0.position == nextPosition }
    if nextValueExists { return doSearch(in: letters, on: search, index: index + 1) } else { return false }
}

private func doCrossSearch(in letters: [Letter], from letter: Letter) -> Int {
    let nextLetterPositions = SearchVector.allDirections().map { ((x: letter.position.x + $0.x, y: letter.position.y + $0.y), (x: letter.position.x - $0.x, y: letter.position.y - $0.y)) }
    
    let nextLetters = nextLetterPositions.map { nextLetter in (letters.first { nextLetter.0.x == $0.position.x && nextLetter.0.y == $0.position.y }, letters.first { nextLetter.1.x == $0.position.x && nextLetter.1.y == $0.position.y }) }
    
    let filteredNextLetters = nextLetters.filter { calcedLetter in
        calcedLetter.0?.letterValue == .M && calcedLetter.1?.letterValue == .S
    }
    
    let crossLetters = filteredNextLetters.filter { nextLetter in
        filteredNextLetters.contains { $0.0! == nextLetter.0! + SearchVector(x: 2, y: 0) || $0.0! == nextLetter.0! + SearchVector(x: -2, y: 0) || $0.0! == nextLetter.0! + SearchVector(x: 0, y: 2) || $0.0! == nextLetter.0! + SearchVector(x: 0, y: -2) }
    }
    
    return (crossLetters.count / 2)
}

func day4part1(_ inputValues: String) -> Int {
    let letters = inputValues.split(separator: "\n").enumerated().flatMap({ (index, val) in
        val.enumerated().map { Letter(position: (x: $0.offset, y: index), letterValue: $0.element) }
    })
    
    let searches = letters.filter { $0.letterValue == .X }.flatMap { x in SearchVector.allDirections().map { Search(initialPoint: x.position, direction: $0) } }
    return searches.map { doSearch(in: letters, on: $0, index: 0) }.filter { $0 }.count
}

func day4part2(_ inputValues: String) -> Int {
    let letters = inputValues.split(separator: "\n").enumerated().flatMap({ (index, val) in
        val.enumerated().map { Letter(position: (x: $0.offset, y: index), letterValue: $0.element) }
    })
    
    let letterAs = letters.filter { $0.letterValue == .A }
    return letterAs.map { a in doCrossSearch(in: letters, from: a) }.reduce(0, +)
}
