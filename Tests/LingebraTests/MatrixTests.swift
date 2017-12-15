//
//  MatrixTests.swift
//  LingebraTests
//
//  Created by Letanyan Arumugam on 2017/12/14.
//

import XCTest
@testable import Lingebra

func ==<T: Equatable>(lhs: [[T]], rhs: [[T]]) -> Bool {
	guard lhs.count == rhs.count else {
		return false
	}
	
	for (idx, el) in lhs.enumerated() {
		if el != rhs[idx] {
			return false
		}
	}
	return true
}

class MatrixTests: XCTestCase {
	func testInits() {
		let xs: [[Double]] = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
		
		let a = Matrix(rows: xs)
		
		XCTAssertTrue(a.rows() == xs)
		XCTAssertEqual(a.cells, xs.flatMap { $0 })
		XCTAssertEqual(a.rowCount, 3)
		XCTAssertEqual(a.colCount, 3)
		XCTAssertEqual(a.count, 9)
		
		
		let ys: [[Double]] = [[1, 2, 3, 4], [5, 6, 7, 8]]
		
		let b = Matrix(rows: ys)
		
		XCTAssertTrue(b.rows() == ys)
		XCTAssertEqual(b.cells, ys.flatMap { $0 })
		XCTAssertEqual(b.rowCount, 2)
		XCTAssertEqual(b.colCount, 4)
		XCTAssertEqual(b.count, 8)
		
		
		let zs: [Double] = [1, 2, 3, 4, 5, 6, 7, 8, 9]
		
		let a2 = Matrix(array: zs, colCount: 3)
		
		XCTAssertTrue(a2.rows() == xs)
		XCTAssertEqual(a2.cells, xs.flatMap { $0 })
		XCTAssertEqual(a2.rowCount, 3)
		XCTAssertEqual(a2.colCount, 3)
		XCTAssertEqual(a2.count, 9)
		
		let ws: [Double] = [1, 2, 3, 4, 5, 6, 7, 8]
		
		let b2 = Matrix(array: ws, colCount: 4)
		
		XCTAssertTrue(b2.rows() == ys)
		XCTAssertEqual(b2.cells, ys.flatMap { $0 })
		XCTAssertEqual(b2.rowCount, 2)
		XCTAssertEqual(b2.colCount, 4)
		XCTAssertEqual(b2.count, 8)
	}

	func testGetRows() {
		let xs: [[Double]] = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
		
		let a = Matrix(rows: xs)
		
		let x = a.row(at: 0)
		let y = a.row(at: 1)
		let z = a.row(at: 2)
		
		XCTAssertEqual(x, [1, 2, 3])
		XCTAssertEqual(y, [4, 5, 6])
		XCTAssertEqual(z, [7, 8, 9])
		
		let mx = a.rowMatrix(at: 0)
		let my = a.rowMatrix(at: 1)
		let mz = a.rowMatrix(at: 2)
		
		XCTAssertEqual(mx, [[1, 2, 3]])
		XCTAssertEqual(my, [[4, 5, 6]])
		XCTAssertEqual(mz, [[7, 8, 9]])
	}
	
	func testGetCols() {
		let xs: [[Double]] = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
		
		let a = Matrix(rows: xs)
		
		let x = a.col(at: 0)
		let y = a.col(at: 1)
		let z = a.col(at: 2)
		
		XCTAssertEqual(x, [1, 4, 7])
		XCTAssertEqual(y, [2, 5, 8])
		XCTAssertEqual(z, [3, 6, 9])
		
		let mx = a.colMatrix(at: 0)
		let my = a.colMatrix(at: 1)
		let mz = a.colMatrix(at: 2)
		
		XCTAssertEqual(mx, [[1], [4], [7]])
		XCTAssertEqual(my, [[2], [5], [8]])
		XCTAssertEqual(mz, [[3], [6], [9]])
	}
	
	func testIdentity() {
		let i1 = Matrix<Double>.identityMatrix(ofSize: 1)
		let i2 = Matrix<Double>.identityMatrix(ofSize: 2)
		let i3 = Matrix<Double>.identityMatrix(ofSize: 3)
		
		XCTAssertEqual(i1, [[1]])
		XCTAssertEqual(i2, [[1, 0], [0, 1]])
		XCTAssertEqual(i3, [[1, 0, 0], [0, 1, 0], [0, 0, 1]])
	}
	
	func testRectangularIdentity() {
		let i31 = Matrix<Double>.rectangularIdentityMatrix(ofRowSize: 3, andColSize: 1)
		
		let i13 = Matrix<Double>.rectangularIdentityMatrix(ofRowSize: 1, andColSize: 3)
		
		let i23 = Matrix<Double>.rectangularIdentityMatrix(ofRowSize: 2, andColSize: 3)
		
		let i35 = Matrix<Double>.rectangularIdentityMatrix(ofRowSize: 3, andColSize: 5)
		
		XCTAssertEqual(i31, [[1], [0], [0]])
		XCTAssertEqual(i13, [[1, 0, 0]])
		
		XCTAssertEqual(i23, [[1, 0, 0], [0, 1, 0]])
		XCTAssertEqual(i35, [[1, 0, 0, 0, 0], [0, 1, 0, 0, 0], [0, 0, 1, 0, 0]])
	}
	
	func testIsIdentity() {
		let i31 = Matrix<Double>.rectangularIdentityMatrix(ofRowSize: 3, andColSize: 1)
		
		let i13 = Matrix<Double>.rectangularIdentityMatrix(ofRowSize: 1, andColSize: 3)
		
		let i23 = Matrix<Double>.rectangularIdentityMatrix(ofRowSize: 2, andColSize: 3)
		
		let i35 = Matrix<Double>.rectangularIdentityMatrix(ofRowSize: 3, andColSize: 5)
		
		let i1 = Matrix<Double>.identityMatrix(ofSize: 1)
		let i2 = Matrix<Double>.identityMatrix(ofSize: 2)
		let i3 = Matrix<Double>.identityMatrix(ofSize: 3)
		
		XCTAssertTrue(i31.isIdentity())
		XCTAssertTrue(i13.isIdentity())
		XCTAssertTrue(i23.isIdentity())
		XCTAssertTrue(i35.isIdentity())
		XCTAssertTrue(i1.isIdentity())
		XCTAssertTrue(i2.isIdentity())
		XCTAssertTrue(i3.isIdentity())
		
		let a: Matrix<Double> = [[1, 0, 0], [0, 1, 0], [0, 0, 2]]
		let b: Matrix<Double> = [[0, 0, 0], [2, 1, 0], [1, 3, 2]]
		let c: Matrix<Double> = [[1, 0, 0], [1, 0, 0], [1, 0, 0]]
		
		XCTAssertFalse(a.isIdentity())
		XCTAssertFalse(b.isIdentity())
		XCTAssertFalse(c.isIdentity())
	}
	
}
