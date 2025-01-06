//
//  day6input.swift
//  AoC2024
//
//  Created by Alistair Gempf on 20/12/2024.
//

import Foundation

let day6 = PuzzleInput(test: """
....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...
""", input: """
............#.............#......................#....#....................................................#..............#.......
..................................#...#......#.......#........#..................#....#...........................##....#.........
...........#...........#...........#...#...#...............................#.......................##....................#........
..................#.............#........#.....................#...........................................................#......
....#............................................................#..#...#......#.#......#...#..........#..#.....#....#...#........
.................................#......##.............................#..........................#...#.........#.................
.#.............#.........#..#..............................................................................##...........#..#......
....#..............#..........................##......#........#...#........#..........#........#.............#...................
.....#.......#..#......#..#..................................................................#.........................#..........
......................#...............................#......#................................#......#.....#......................
.......#.........#.....................................................................#....#.#.....................#.........#...
........................#......##..........#....#..........................#....................#...................#.........#...
................#..#............#...#.................................................................#...........#...............
.#.....#.....................#..........................................#................................#........................
.............#.##........#......#......#......................#..................................................#...#..........#.
.......#.........#.#..........#.............#.......#............#.....................#..........................................
.............................#.........................................................#.........#.........#.............#........
....#..#.#..................................................#...........#..................#....#.................................
...............#..........#.....#..............................................................#..................................
.......##.............................................................................#...............#.........#.................
....#.....#..........................#..........#................................#....................#...#.......................
.#.................................................#..#.....#.....................................................................
...........................#..............#.#...#..........................................#......#..........................#....
.#....#........#....................................................#...........................................#.................
...#..................#................##...#.............#..#....................#...............#...............................
..................................................#......#..........................................................#...#.........
#.#....................................#........#.............................................................#...................
...............................................#.......##...............................................#.........................
...#.............#................................................................................................................
.......................................#....#..#........#............#..........#.........#...#..................#................
........#.................................................#.........................................#...........#.................
...................#...........#...............................#..........................#................#..#..........#.....#..
...............#......#...............................................................#............................##..#.....##...
.........................................##.#..#..................#.......#.....................#.................................
...........#...................................................................#...#..................................#.....#.....
......#...............................#.......###..........................#....#.....................................#...........
.....##...............................#...................................................#................................#...#..
..................#....#.......#.......................................................................##.........................
.....#..#.................................................................................................#.......................
.#.................................#......................##....................................#..........................##.....
#.#................#......................................#...........................#.......#...................................
.................................#.......#.....#..............................................##..#....................#..........
............#...............................................................................#....#...........#..........#.........
................................................##...............................................#..#..........................#..
.................#.......#........................................................................#...............................
..#.........................#......#.............#.......................................#........................................
...............#.............#...........................................................#.....#..................................
.........#...............................................................................#...............................#........
.........................................#...................#.................#.........##........#.........#....................
............#..........#.....#................................................................#...##............................#.
........#...#....#..............................................#..............#........................#.........................
..#.....................................................................................................................#.........
.#....#.............................^................#..#...................#.........................#...........................
..........................................................................#.........#....#......#.................................
.........#................................#.#........................#.................#...................................#......
.............................................#.##............................................................#......#..#.........#
..........#............#...........#..#......#..........#.........................................................................
......................#....................................#....#.............##....#.............................................
......................#...#............#.......................................................................................#..
.##.................#.......................#...............#.............#......#..................................#.....#.#.....
....................#........#.......................#....................................#.......#...#.......#.......#......#....
.............................................................#.......................#..........................#.....#...........
...#.................#.......................................................#.......##...........#.......#.......................
...............##.........................#.........................................................#.....#.......#...............
.......................#.......................#.........#..............#....................#..........#........................#
...................................##..........#..........................................................#.........#.............
..................#...............................#...................................#.......#.......................#...........
.......................#..#...................................#........................#........#............#....................
...................................#....#............#..................#........................................#..........#.....
.............#...#...#......#.............##...............................................#..........................#....#......
....................#..........................................#....#......................................................#......
............#.........#...............#..#.....................................................................#.#................
.......................#..#..............................................................#.....#........#..#..................#...
.............#..#..............................#.....#.................#.............#.......................#................#...
...............#......#...........#............#.........#......................................#.................................
............................#.....#.........#.....#..#...........#................................................................
....#.......#.................#..............................................#.......#.#.............................#...#..#.....
..................................................#.#......#............................................................#.........
..................................#............#........................#.......#.........#...#...............#...................
............##....#.#......#..............................................................................#..............#........
.....#..........................................#.........................................................#........##.............
............#.....................#..#.#..............#........#......#.............................#....#...#....................
.......................#...........................................................................#..............................
......#.........................................#........#............#..#..............................#.#.......................
#.#......#..#...............#...........#....#.................................................#..................................
.........#...........#............................#..............#......................#.......................................#.
...#............#..................................#..............#............................#.........................#........
...##..#.....................................................................................#...........................#........
...............#......#.........#................................#...#............#....................#..........................
..........................#...........................#..............................................#................#....#......
.........#........#.#...........................................................................#..#..............................
.................#..............#........................................................................#.................#......
...#.........#.#.........#.#...........................................#........#........#.........#..............................
..........#............................................................#..........#.....#.........................................
..................................#.....#...........##........#......#..........#..........................#......................
...........................#....#.............#............................................................#......................
.............#.......#...................................#.....#............................................................##....
............#..............##.............#.....#...............#..........#........................#.........................#...
..##.....................................................................................................#........................
.............#.#...........#...................#....#...#......#................##................................................
.................#.#............#........................#.......##..#.........##.................................................
......................#.#...#................................................................#...............#.....#...........#..
#.................#..........................#.............................##.....#...........................................#...
..............#.........#.................#................................................................................#......
....#.#............#.......#.......................#.....#.......................#....................#.....#.............#.......
......................#..#....#.........................................#.#............##............#............................
.........#.#...#...#........................................#...............................................#....................#
.......................#...................#.............................................................#.......................#
................#............................#........#..........#.......................##....#..................................
.#...................#......................#.......................................#............................#................
..#..##.......#......#..........#..#..................................................#...........................................
..............#..........#...........................................#.........##.................................................
....#..............................#.........#...#.................#......#.#.......#.............................................
#.................................#........#.....................................#...##...................#..#...........#........
.......#.....#.............................................#..................#...................#...........#..#........#.......
.......................#................#.............#.#.........#..............................................................#
......................................................#....................#..........#................................#..........
#...............#...#.............#.................#.................................................#...........................
..................................................................#.........................#......#.........#............##......
#.................#........#.......#...#....................................#.#...................................................
.....................................#...#....#.........#................#.........................................#...#..........
............#............................#.............#.#........................................................................
......................................#.................................................#...............#.......#.................
.#.#..........#........#.......................#..................................................#....................#..........
....#...............................................................#...........#............#.......................#............
....#.......#.#..#...................#.........#..................................#....................................#..........
..............................................#...................................##.......#......................................
#...#.#............#...............................#.........#...........#..........#............................................#
..#...........#..#..........#.......................#..........##.................................................................
...#.....#..................................#................................................#....................................
""")