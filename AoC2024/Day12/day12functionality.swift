//
//  day12functionality.swift
//  AoC2024
//
//  Created by Alistair Gempf on 03/01/2025.
//

import Foundation

private struct Plot: Hashable {
    let position: Position
    let crop: String
}

private func getRegion(for plots: Set<Plot>, from allPlots: Set<Plot>) -> Set<Plot> {
    let allDirections = Vector.allNonDiagonalDirections()
    let neighbouring = plots.flatMap { plot in allPlots.filter { allDirections.contains(plot.position - $0.position) && !plots.contains($0) } }
    
    guard neighbouring.count > 0 else { return Set(plots) }
    
    let newRegion = plots.union(Set(neighbouring))
    return getRegion(for: newRegion, from: allPlots.subtracting(newRegion))
}

private func getRegions(plots: Set<Plot>, existing: Set<Set<Plot>>) -> Set<Set<Plot>> {
    let plotsInExisting = Set(existing.flatMap { $0 })
    let plotsNotInExisting = plots.subtracting(plotsInExisting)
    guard plotsNotInExisting.count > 0 else { return existing }
    
    let plotToSearch = plotsNotInExisting.first!
    let region = getRegion(for: Set([plotToSearch]), from: plots.filter { $0.crop == plotToSearch.crop })
    return getRegions(plots: plots, existing: existing.union(Set([region])))
}

private func perimeter(of region: Set<Plot>) -> Int {
    let allDirections = Vector.allNonDiagonalDirections()
    return region.map { plot in 4 - region.filter { allDirections.contains(plot.position - $0.position) }.count }.reduce(0, +)
}

private func area(of region: Set<Plot>) -> Int { region.count }

private func calculatePrice(for region: Set<Plot>) -> Int {
    area(of: region) * perimeter(of: region)
}

func day12part1(_ input: String) -> Int {
    let splitInput = input.split(separator: "\n").enumerated().flatMap({ (index, val) in
        val.enumerated().map { (index: index, offset: Int($0.offset), element: String($0.element)) }
    })
    let plots = splitInput.map { Plot(position: Position(x: $0.offset, y: $0.index), crop: $0.element) }
    
    let regions = getRegions(plots: Set(plots), existing: Set() )
    let prices = regions.map { calculatePrice(for: $0) }
    
    return prices.reduce(0, +)
}

private func straightSides(of region: Set<Plot>) -> Int {
    let allDirections = Vector.allNonDiagonalDirections()
    let positions = Set(region.map { $0.position })
    let walls = Dictionary(uniqueKeysWithValues: region.map { plot in
        (plot.position, allDirections.filter { !positions.contains(plot.position + $0) })
    })
    let neighbours = Dictionary(uniqueKeysWithValues: positions.map { plot in
        (plot, positions.filter { allDirections.contains(plot - $0) })
    })
    
    let combinedWalls = neighbours.reduce([(direction: Vector, on: Set<Position>)](), { acc, curr in
        let currWalls = walls[curr.key] ?? []
        
        let neighbourWalls = Dictionary().merging(acc.filter { wall in
            curr.value.contains { neighbour in wall.on.contains(neighbour) } && currWalls.contains(wall.direction)
        }.map { (key: $0.direction, value: $0.on) }, uniquingKeysWith: { $0.union($1) })
        
        let nonNeighbourWalls = acc.filter { wall in
            curr.value.allSatisfy { !wall.on.contains($0) } || !currWalls.contains(wall.direction)
        }
        
        let currWallsMapped = Dictionary(uniqueKeysWithValues: currWalls.map { wall in
            guard let existing = neighbourWalls[wall] else { return ( wall, Set([curr.key]) ) }
            return (wall, existing.union([curr.key]))
        })
        return nonNeighbourWalls + currWallsMapped.merging(neighbourWalls, uniquingKeysWith: { first, _ in first }).map { ($0.key, $0.value) }
    })
    
    return combinedWalls.count
}

private func calculateBulkPrice(for region: Set<Plot>) -> Int {
    area(of: region) * straightSides(of: region)
}

func day12part2(_ input: String) -> Int {
    let splitInput = input.split(separator: "\n").enumerated().flatMap({ (index, val) in
        val.enumerated().map { (index: index, offset: Int($0.offset), element: String($0.element)) }
    })
    let plots = splitInput.map { Plot(position: Position(x: $0.offset, y: $0.index), crop: $0.element) }
    
    let regions = getRegions(plots: Set(plots), existing: Set() )
    let prices = regions.map { calculateBulkPrice(for: $0) }
    
    return prices.reduce(0, +)
}
