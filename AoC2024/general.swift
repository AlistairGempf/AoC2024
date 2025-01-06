//
//  general.swift
//  AoC2024
//
//  Created by Alistair Gempf on 13/12/2024.
//

import Foundation

struct PuzzleInput {
    let test: String
    let input: String
}

protocol VectorLike: Equatable, Hashable {
    var x: Int { get }
    var y: Int { get }
    
    static func +<V> (lhs: Self, rhs: V) -> Self where V: VectorLike
    static func -<V> (lhs: Self, rhs: V) -> Self where V: VectorLike
    
    init(x: Int, y: Int)
}

extension VectorLike {
    static func +<V> (lhs: Self, rhs: V) -> Self where V: VectorLike {
        Self(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    static func -<V> (lhs: Self, rhs: V) -> Self where V: VectorLike {
        Self(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y
    }
}

struct Vector: VectorLike {
    let x: Int
    let y: Int
    
    static func allDirections() -> [Vector] {
        [
            Vector(x: -1, y: -1), Vector(x: 0, y: -1), Vector(x: +1, y: -1),
            Vector(x: -1, y:  0),                      Vector(x: +1, y:  0),
            Vector(x: -1, y: +1), Vector(x: 0, y: +1), Vector(x: +1, y: +1),
        ]
    }
    
    static func allNonDiagonalDirections() -> [Vector] {
        [
                                  Vector(x: 0, y: -1),
            Vector(x: -1, y:  0),                      Vector(x: +1, y:  0),
                                  Vector(x: 0, y: +1),
        ]
    }
    
    static func * (lhs: Self, rhs: Int) -> Self {
        Self(x: lhs.x * rhs, y: lhs.y * rhs)
    }
    
    static func / (lhs: Self, rhs: Int) -> Self {
        Self(x: lhs.x / rhs, y: lhs.y / rhs)
    }
}

typealias Velocity = Vector
