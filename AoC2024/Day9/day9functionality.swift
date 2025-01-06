//
//  day9functionality.swift
//  AoC2024
//
//  Created by Alistair Gempf on 29/12/2024.
//

import Foundation

struct OOMError: Error {}

private struct Chunk: Hashable {
    let id: Int
    let fileSize: Int
    let freeFollowing: Int
    
    init(id: Int, fileSize: Int, freeFollowing: Int) {
        self.id = id
        self.fileSize = fileSize
        self.freeFollowing = freeFollowing
    }
    
    static func moving(chunk: Chunk, following original: Chunk) throws -> (first: Chunk, second: Chunk) {
        guard chunk.fileSize <= original.freeFollowing else { throw OOMError() }
        return (first: Chunk(id: original.id, fileSize: original.fileSize, freeFollowing: 0), second: Chunk(id: chunk.id, fileSize: chunk.fileSize, freeFollowing: original.freeFollowing - chunk.fileSize))
    }
    
    func freeing(_ freeingAmount: Int) -> Chunk {
        Chunk(id: self.id, fileSize: self.fileSize, freeFollowing: self.freeFollowing + freeingAmount)
    }
}

private func fileChunk(_ string: String) -> [Chunk] {
    let elements = string.split(separator: "")
    let ints: [(Int, Int)] = stride(from: 0, to: elements.count, by: 2).map {
        let first = Int(elements[$0])!
        let second = elements.indices.contains($0 + 1) ? Int(elements[$0 + 1])! : 0
        return (first, second)
    }
    return ints.enumerated().map {
        Chunk(id: $0.offset, fileSize: $0.element.0, freeFollowing: $0.element.1)
    }
}

private enum Storage {
    case empty, taken(Int)
}

func day9part1(_ input: String) -> Int {
    let chunks = fileChunk(input)
    let totalFileSize = chunks.reduce(0, { $0 + $1.fileSize })
    
    let unmovedChecksum = chunks.reduce((index: 0, checksum: 0, unfilled: [Int]()), { acc, curr in
        guard acc.index < totalFileSize else { return acc }
        let checksumAddition = Array(acc.index ..< min(acc.index + curr.fileSize, totalFileSize)).reduce(0, { $0 + $1 * curr.id } )
        let willFinish = acc.index + curr.fileSize >= totalFileSize
        let unfilled = willFinish ? [] : Array(acc.index + curr.fileSize ..< min(acc.index + curr.fileSize + curr.freeFollowing, totalFileSize))
        return (index: acc.index + curr.fileSize + curr.freeFollowing, checksum: acc.checksum + checksumAddition, unfilled: acc.unfilled + unfilled)
    })
    
    let movedChecksum = unmovedChecksum.unfilled.reduce((checksum: 0, chunks: Array(chunks.reversed()), chunkUsed: 0), { acc, curr in
        let chunk = acc.chunks.first!
        let checksumAddition = chunk.id * curr
        let usedUpAllOfChunk = (chunk.fileSize == acc.chunkUsed + 1)
        return (checksum: acc.checksum + checksumAddition, chunks: usedUpAllOfChunk ? Array(acc.chunks.dropFirst()) : acc.chunks, chunkUsed: usedUpAllOfChunk ? 0 : acc.chunkUsed + 1)
    })
    
    return unmovedChecksum.checksum + movedChecksum.checksum
}

func day9part2(_ input: String) -> Int {
    let chunks = fileChunk(input)
    
    let unmovedChunkMap: (index: Int, chunkMap: [Int:Chunk]) = chunks.reduce((index: 0, chunkMap: [Int:Chunk]()), { acc, curr in
        let nextIndex: Int = acc.index + curr.fileSize + curr.freeFollowing
        let chunkValue = [acc.index: curr]
        return (index: nextIndex, chunkMap: acc.chunkMap.merging(chunkValue, uniquingKeysWith: { $1 }))
    })
    
    let movedChunkMap = chunks.reversed().reduce(unmovedChunkMap.chunkMap, { acc, curr in
        let currentIndex = acc.first { $0.value.id == curr.id }!.key
        let chunkToFollow = acc.sorted { $0.key < $1.key }.first { $0.value.freeFollowing >= curr.fileSize && $0.key < currentIndex }
        guard let chunkToFollow = chunkToFollow else { return acc }
        
        let newChunks = try! Chunk.moving(chunk: curr, following: chunkToFollow.value)
        
        let newMapValues = [chunkToFollow.key: newChunks.first, chunkToFollow.key + newChunks.first.fileSize: newChunks.second]
        return acc.filter { $0.value.id != curr.id }.merging(newMapValues, uniquingKeysWith: { $1 })
    })
    
    return movedChunkMap.reduce(0, { acc, curr in
        let (index, chunk) = curr
        let checksumAddition = Array(index ..< index + chunk.fileSize).reduce(0, { $0 + $1 * chunk.id } )
        return acc + checksumAddition
    })
}
