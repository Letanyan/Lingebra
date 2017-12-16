//
//  Grid.swift
//  Lingebra
//
//  Created by Letanyan Arumugam on 2017/12/11.
//

import Swift

public struct GridCoordinate {
	var row, col: Int
}

public protocol Grid {
	associatedtype Cell
	
	var cells: [Cell] { get }
	var rowCount: Int { get }
	var colCount: Int { get }
	var count: Int { get }
	
	//MARK: -Conversion
	func linearPosition(fromRow row: Int, andCol col: Int) -> Int
	func gridCoordinate(from linearPosition: Int) -> GridCoordinate
	
	//MARK: -Get Element
	func cell(from coord: GridCoordinate) -> Cell?
	func cell(inRow row: Int, andCol col: Int) -> Cell?
	func cell(from linearPosition: Int) -> Cell?
	
	//MARK: -Get Vectors
	func row(at index: Int) -> [Cell]
	func col(at index: Int) -> [Cell]
	
	subscript(row row: Int) -> [Cell] { get }
	subscript(col col: Int) -> [Cell] { get }
	subscript(row: Int, col: Int) -> Cell { get }
}

extension Grid {
	//MARK: -Conversion
	public func linearPosition(fromRow row: Int, andCol col: Int) -> Int {
		return row * colCount + col
	}
	
	public func gridCoordinate(from linearPosition: Int) -> GridCoordinate {
		return GridCoordinate(row: linearPosition / colCount, col: linearPosition % colCount)
	}
	
	//MARK: -Get Element
	public func cell(from coord: GridCoordinate) -> Cell? {
		return cells[linearPosition(fromRow: coord.row, andCol: coord.col)]
	}
	
	public func cell(inRow row: Int, andCol col: Int) -> Cell? {
		return cells[linearPosition(fromRow: row, andCol: col)]
	}
	
	public func cell(from linearPosition: Int) -> Cell? {
		return cells[linearPosition]
	}
	
	//MARK: -Get Vectors
	public func row(at index: Int) -> [Cell] {
		let start = index * colCount
		var result = [Cell]()
		for x in start..<(start + colCount) {
			result.append(cells[x])
		}
		
		return result
	}
	
	public func col(at index: Int) -> [Cell] {
		var result = [Cell]()
		
		for x in 0..<rowCount {
			let idx = index + x * colCount
			result.append(cells[idx])
		}
		return result
	}
	
	public func rows() -> [[Cell]] {
		var result = [[Cell]]()
		
		for i in 0..<rowCount {
			result.append(row(at: i))
		}
		return result
	}
	
	public func cols() -> [[Cell]] {
		var result = [[Cell]]()
		for i in 0..<colCount {
			result.append(col(at: i))
		}
		return result
	}
	
	public subscript(row row: Int) -> [Cell] {
		return self.row(at: row)
	}
	
	public subscript(col col: Int) -> [Cell] {
		return self.col(at: col)
	}
	
	public subscript(row: Int, col: Int) -> Cell {
		return cells[linearPosition(fromRow: row, andCol: col)]
	}
}
