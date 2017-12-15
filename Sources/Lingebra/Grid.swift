//
//  Grid.swift
//  Lingebra
//
//  Created by Letanyan Arumugam on 2017/12/11.
//

import Swift

struct GridCoordinate {
	var col, row: Int
}

protocol Grid {
	associatedtype Cell
	
	var cells: [Cell] { get }
	var rowCount: Int { get }
	var colCount: Int { get }
	var count: Int { get }
	
	//MARK: -Conversion
	func linearPosition(fromCol col: Int, andRow row: Int) -> Int
	func gridCoordinate(from linearPosition: Int) -> GridCoordinate
	
	//MARK: -Get Element
	func cell(from coord: GridCoordinate) -> Cell?
	func cell(in row: Int, and col: Int) -> Cell?
	func cell(from linearPosition: Int) -> Cell?
	
	//MARK: -Get Vectors
	func row(at index: Int) -> [Cell]
	func col(at index: Int) -> [Cell]
	
	subscript(row: Int) -> [Cell] { get }
	subscript(col col: Int) -> [Cell] { get }
	subscript(row: Int, col: Int) -> Cell { get }
}

extension Grid {
	//MARK: -Conversion
	func linearPosition(fromCol col: Int, andRow row: Int) -> Int {
		return (row - 1) * colCount * (col - 1)
	}
	
	func gridCoordinate(from linearPosition: Int) -> GridCoordinate {
		return GridCoordinate(col: linearPosition % colCount, row: linearPosition / colCount)
	}
	
	//MARK: -Get Element
	func cell(from coord: GridCoordinate) -> Cell? {
		return cells[linearPosition(fromCol: coord.col, andRow: coord.row)]
	}
	
	func cell(in row: Int, and col: Int) -> Cell? {
		return cell(from: GridCoordinate(col: col, row: row))
	}
	
	func cell(from linearPosition: Int) -> Cell? {
		return cells[linearPosition]
	}
	
	//MARK: -Get Vectors
	func row(at index: Int) -> [Cell] {
		let start = index * colCount
		var result = [Cell]()
		for x in start..<(start + colCount) {
			result.append(cells[x])
		}
		
		return result
	}
	
	func col(at index: Int) -> [Cell] {
		var result = [Cell]()
		
		for x in 0..<rowCount {
			let idx = index + x * colCount
			result.append(cells[idx])
		}
		return result
	}
	
	func rows() -> [[Cell]] {
		var result = [[Cell]]()
		
		for i in 0..<rowCount {
			result.append(row(at: i))
		}
		return result
	}
	
	func cols() -> [[Cell]] {
		var result = [[Cell]]()
		for i in 0..<colCount {
			result.append(col(at: i))
		}
		return result
	}
	
	subscript(row: Int) -> [Cell] {
		return self.row(at: row)
	}
	
	subscript(col col: Int) -> [Cell] {
		return self.col(at: col)
	}
	
	subscript(row: Int, col: Int) -> Cell {
		return cells[linearPosition(fromCol: col, andRow: row)]
	}
}
