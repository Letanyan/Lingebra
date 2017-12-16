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
	
	func testAugmentation() {
		let xs: Matrix<Double> = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
		let ys: Matrix<Double> = [[1, 2], [3, 4], [5, 6], [7, 8]]
		let zs: Matrix<Double> = [[1, 2, 3, 4], [5, 6, 7, 8]]
		
		let a = xs.augmented(with: [1, 2, 3])
		let b = ys.augmented(with: [1, 2, 3, 4])
		let c = zs.augmented(with: [1, 2])
		
		XCTAssertTrue(a.matrix.rows() == [[1, 2, 3, 1], [4, 5, 6, 2], [7, 8, 9, 3]])
		
		XCTAssertTrue(b.matrix.rows() == [[1, 2, 1], [3, 4, 2], [5, 6, 3], [7, 8, 4]])
		
		XCTAssertTrue(c.matrix.rows() == [[1, 2, 3, 4, 1], [5, 6, 7, 8, 2]])
	}
	
	func testSplitMatrix() {
		let xs: Matrix<Double> = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
		let ys: Matrix<Double> = [[1, 2], [3, 4], [5, 6], [7, 8]]
		let zs: Matrix<Double> = [[1, 2, 3, 4], [5, 6, 7, 8]]
		
		let a = xs.augmented(with: [1, 2, 3])
		let b = ys.augmented(with: [1, 2, 3, 4])
		let c = zs.augmented(with: [1, 2])
		
		XCTAssertTrue(xs == a.matrix.splitMatrix(atIndex: 3).left)
		XCTAssertTrue(ys == b.matrix.splitMatrix(atIndex: 2).left)
		XCTAssertTrue(zs == c.matrix.splitMatrix(atIndex: 4).left)
		
		XCTAssertTrue(xs.splitMatrix(atIndex: 2).left == [[1, 2], [4, 5], [7, 8]])
		XCTAssertTrue(xs.splitMatrix(atIndex: 1).left == [[1], [4], [7]])
		
		XCTAssertTrue(xs.splitMatrix(atIndex: 2).right == [[3], [6], [9]])
		XCTAssertTrue(xs.splitMatrix(atIndex: 1).right == [[2, 3], [5, 6], [8, 9]])
	}
	
	func testCoefficients() {
		let xs: Matrix<Double> = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
		let ys: Matrix<Double> = [[1, 2], [3, 4], [5, 6], [7, 8]]
		let zs: Matrix<Double> = [[1, 2, 3, 4], [5, 6, 7, 8]]
		
		let a = xs.augmented(with: [1, 2, 3])
		let b = ys.augmented(with: [1, 2, 3, 4])
		let c = zs.augmented(with: [1, 2])
		
		XCTAssertTrue(xs == a.matrix.coefficientsMatrix())
		XCTAssertTrue(ys == b.matrix.coefficientsMatrix())
		XCTAssertTrue(zs == c.matrix.coefficientsMatrix())
		
		XCTAssertTrue(xs.coefficientsMatrix() == [[1, 2], [4, 5], [7, 8]])
		XCTAssertTrue(ys.coefficientsMatrix() == [[1], [3], [5], [7]])
		XCTAssertTrue(zs.coefficientsMatrix() == [[1, 2, 3], [5, 6, 7]])
	}
	
	func testConstants() {
		let xs: Matrix<Double> = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
		let ys: Matrix<Double> = [[1, 2], [3, 4], [5, 6], [7, 8]]
		let zs: Matrix<Double> = [[1, 2, 3, 4], [5, 6, 7, 8]]
		
		let a = xs.augmented(with: [1, 2, 3])
		let b = ys.augmented(with: [1, 2, 3, 4])
		let c = zs.augmented(with: [1, 2])
		
		XCTAssertTrue(a.matrix.constantsColoumn() == [1, 2, 3])
		XCTAssertTrue(b.matrix.constantsColoumn() == [1, 2, 3, 4])
		XCTAssertTrue(c.matrix.constantsColoumn() == [1, 2])
		
		XCTAssertTrue(xs.constantsColoumn() == [3, 6, 9])
		XCTAssertTrue(ys.constantsColoumn() == [2, 4, 6, 8])
		XCTAssertTrue(zs.constantsColoumn() == [4, 8])
	}
	
	func testMinor() {
		let xs: Matrix<Double> = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
		let ys: Matrix<Double> = [[1, 2], [3, 4], [5, 6], [7, 8]]
		let zs: Matrix<Double> = [[1, 2, 3, 4], [5, 6, 7, 8]]
		
		let x00 = xs.minor(at: GridCoordinate(row: 0, col: 0))
		let x01 = xs.minor(at: GridCoordinate(row: 0, col: 1))
		let x02 = xs.minor(at: GridCoordinate(row: 0, col: 2))
		
		let x10 = xs.minor(at: GridCoordinate(row: 1, col: 0))
		let x11 = xs.minor(at: GridCoordinate(row: 1, col: 1))
		let x12 = xs.minor(at: GridCoordinate(row: 1, col: 2))
		
		let x20 = xs.minor(at: GridCoordinate(row: 2, col: 0))
		let x21 = xs.minor(at: GridCoordinate(row: 2, col: 1))
		let x22 = xs.minor(at: GridCoordinate(row: 2, col: 2))
		
		XCTAssertTrue(x00 == [[5, 6], [8, 9]])
		XCTAssertTrue(x01 == [[4, 6], [7, 9]])
		XCTAssertTrue(x02 == [[4, 5], [7, 8]])
		
		XCTAssertTrue(x10 == [[2, 3], [8, 9]])
		XCTAssertTrue(x11 == [[1, 3], [7, 9]])
		XCTAssertTrue(x12 == [[1, 2], [7, 8]])
		
		XCTAssertTrue(x20 == [[2, 3], [5, 6]])
		XCTAssertTrue(x21 == [[1, 3], [4, 6]])
		XCTAssertTrue(x22 == [[1, 2], [4, 5]])
		
		let y00 = ys.minor(at: 0)
		let y01 = ys.minor(at: 1)
		let y10 = ys.minor(at: 2)
		let y11 = ys.minor(at: 3)
		let y20 = ys.minor(at: 4)
		let y21 = ys.minor(at: 5)
		let y30 = ys.minor(at: 6)
		let y31 = ys.minor(at: 7)
		
		XCTAssertTrue(y00 == [[4], [6], [8]])
		XCTAssertTrue(y01 == [[3], [5], [7]])
		XCTAssertTrue(y10 == [[2], [6], [8]])
		XCTAssertTrue(y11 == [[1], [5], [7]])
		XCTAssertTrue(y20 == [[2], [4], [8]])
		XCTAssertTrue(y21 == [[1], [3], [7]])
		XCTAssertTrue(y30 == [[2], [4], [6]])
		XCTAssertTrue(y31 == [[1], [3], [5]])
		
		let z00 = zs.minor(atRow: 0, andCol: 0)
		let z01 = zs.minor(atRow: 0, andCol: 1)
		let z02 = zs.minor(atRow: 0, andCol: 2)
		let z03 = zs.minor(atRow: 0, andCol: 3)
		
		let z10 = zs.minor(atRow: 1, andCol: 0)
		let z11 = zs.minor(atRow: 1, andCol: 1)
		let z12 = zs.minor(atRow: 1, andCol: 2)
		let z13 = zs.minor(atRow: 1, andCol: 3)
		
		XCTAssertTrue(z00 == [[6, 7, 8]])
		XCTAssertTrue(z01 == [[5, 7, 8]])
		XCTAssertTrue(z02 == [[5, 6, 8]])
		XCTAssertTrue(z03 == [[5, 6, 7]])
		
		XCTAssertTrue(z10 == [[2, 3, 4]])
		XCTAssertTrue(z11 == [[1, 3, 4]])
		XCTAssertTrue(z12 == [[1, 2, 4]])
		XCTAssertTrue(z13 == [[1, 2, 3]])
	}
}
