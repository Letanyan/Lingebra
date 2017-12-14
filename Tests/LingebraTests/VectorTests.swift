//
//  VectorTests.swift
//  LingebraTests
//
//  Created by Letanyan Arumugam on 2017/12/12.
//

import XCTest
@testable import Lingebra

class VectorTests: XCTestCase {
	
	func testInits() {
		let dim2 = Vector(x: 1, y: 2)
		let dim3 = Vector(x: 1, y: 2, z: 3)
		let dim4 = Vector(1, 2, 3, 4)
		
		XCTAssertEqual(Vector([1, 2]), dim2)
		XCTAssertEqual(Vector([1, 2, 3]), dim3)
		XCTAssertEqual(Vector([1, 2, 3, 4]), dim4)
	}
	
	func testUnitInit() {
		let dim1 = Vector<Double>.unitVector(ofDimension: 1, onAxis: 0)
		
		let dim21 = Vector<Double>.unitVector(ofDimension: 2, onAxis: 0)
		let dim22 = Vector<Double>.unitVector(ofDimension: 2, onAxis: 1)
		
		let dim31 = Vector<Double>.unitVector(ofDimension: 3, onAxis: 0)
		let dim32 = Vector<Double>.unitVector(ofDimension: 3, onAxis: 1)
		let dim33 = Vector<Double>.unitVector(ofDimension: 3, onAxis: 2)
		
		let dim41 = Vector<Double>.unitVector(ofDimension: 4, onAxis: 0)
		let dim42 = Vector<Double>.unitVector(ofDimension: 4, onAxis: 1)
		let dim43 = Vector<Double>.unitVector(ofDimension: 4, onAxis: 2)
		let dim44 = Vector<Double>.unitVector(ofDimension: 4, onAxis: 3)
		
		XCTAssertEqual(Vector([1]), dim1)
		
		XCTAssertEqual(Vector([1, 0]), dim21)
		XCTAssertEqual(Vector([0, 1]), dim22)
		
		XCTAssertEqual(Vector([1, 0, 0]), dim31)
		XCTAssertEqual(Vector([0, 1, 0]), dim32)
		XCTAssertEqual(Vector([0, 0, 1]), dim33)
		
		XCTAssertEqual(Vector([1, 0, 0, 0]), dim41)
		XCTAssertEqual(Vector([0, 1, 0, 0]), dim42)
		XCTAssertEqual(Vector([0, 0, 1, 0]), dim43)
		XCTAssertEqual(Vector([0, 0, 0, 1]), dim44)
	}
	
	func testUnitAxis() {
		let v1 = Vector([1])
		let v2 = Vector([1, 2])
		let v3 = Vector([1, 2, 3])
		let v4 = Vector([1, 2, 3, 4])
		
		let dim1 = v1.unitVector(onAxis: 0)
		
		let dim21 = v2.unitVector(onAxis: 0)
		let dim22 = v2.unitVector(onAxis: 1)
		
		let dim31 = v3.unitVector(onAxis: 0)
		let dim32 = v3.unitVector(onAxis: 1)
		let dim33 = v3.unitVector(onAxis: 2)
		
		let dim41 = v4.unitVector(onAxis: 0)
		let dim42 = v4.unitVector(onAxis: 1)
		let dim43 = v4.unitVector(onAxis: 2)
		let dim44 = v4.unitVector(onAxis: 3)
		
		XCTAssertEqual(Vector([1]), dim1)
		
		XCTAssertEqual(Vector([1, 0]), dim21)
		XCTAssertEqual(Vector([0, 1]), dim22)
		
		XCTAssertEqual(Vector([1, 0, 0]), dim31)
		XCTAssertEqual(Vector([0, 1, 0]), dim32)
		XCTAssertEqual(Vector([0, 0, 1]), dim33)
		
		XCTAssertEqual(Vector([1, 0, 0, 0]), dim41)
		XCTAssertEqual(Vector([0, 1, 0, 0]), dim42)
		XCTAssertEqual(Vector([0, 0, 1, 0]), dim43)
		XCTAssertEqual(Vector([0, 0, 0, 1]), dim44)
	}
	
	func testZeroInit() {
		let dim1 = Vector<Double>.zeroVector(ofDimension: 1)
		let dim2 = Vector<Double>.zeroVector(ofDimension: 2)
		let dim3 = Vector<Double>.zeroVector(ofDimension: 3)
		let dim4 = Vector<Double>.zeroVector(ofDimension: 4)
		
		XCTAssertEqual(Vector([0]), dim1)
		XCTAssertEqual(Vector([0, 0]), dim2)
		XCTAssertEqual(Vector([0, 0, 0]), dim3)
		XCTAssertEqual(Vector([0, 0, 0, 0]), dim4)
	}
	
	func testZeroVec() {
		let v1 = Vector([1])
		let v2 = Vector([1, 2])
		let v3 = Vector([1, 2, 3])
		let v4 = Vector([1, 2, 3, 4])
		let v8 = Vector([1, 2, 3, 4, 5, 6, 7, 8])
		
		let dim1 = v1.zero
		let dim2 = v2.zero
		let dim3 = v3.zero
		let dim4 = v4.zero
		let dim8 = v8.zero
		
		XCTAssertEqual(Vector([0]), dim1)
		XCTAssertEqual(Vector([0, 0]), dim2)
		XCTAssertEqual(Vector([0, 0, 0]), dim3)
		XCTAssertEqual(Vector([0, 0, 0, 0]), dim4)
		XCTAssertEqual(Vector([0, 0, 0, 0, 0, 0, 0, 0]), dim8)
	}
	
	func testExpressibleByArrayLiteral() {
		let v1: Vector = [1]
		let v2: Vector = [4, 3]
		let v3: Vector = [2, 6, 4]
		let v4: Vector = [1, 2, 6, 7]
		let v8: Vector = [2, 3, 4, 5, 1, 2, 3, 4]
		
		XCTAssertEqual(Vector([1]), v1)
		XCTAssertEqual(Vector([4, 3]), v2)
		XCTAssertEqual(Vector([2, 6, 4]), v3)
		XCTAssertEqual(Vector([1, 2, 6, 7]), v4)
		XCTAssertEqual(Vector([2, 3, 4, 5, 1, 2, 3, 4]), v8)
	}
	
	func testNorm() {
		let v1: Vector = [3]
		let v2: Vector = [4, 3]
		let v3: Vector = [2, 6, 3]
		let v4: Vector = [2, 4, 3, 5]
		
		XCTAssertEqual(3, v1.norm)
		XCTAssertEqual(5, v2.norm)
		XCTAssertEqual(7, v3.norm)
		XCTAssertEqual(54.squareRoot(), v4.norm)
	}
	
	func testDimension() {
		let v1: Vector = [1]
		let v2: Vector = [1, 2]
		let v3: Vector = [1, 2, 3]
		let v4: Vector = [1, 2, 3, 4]
		let v8: Vector = [1, 2, 3, 4, 5, 6, 7, 8]
		
		XCTAssertEqual(1, v1.dimension)
		XCTAssertEqual(2, v2.dimension)
		XCTAssertEqual(3, v3.dimension)
		XCTAssertEqual(4, v4.dimension)
		XCTAssertEqual(8, v8.dimension)
	}
	
	func testFirstNonZero() {
		let v1: Vector = [1]
		let v2: Vector = [0, 3.4]
		let v3: Vector = [0, 1, 2]
		let v4: Vector = [0, 0, 5.3, 0]
		let v8: Vector = [0, 0, 0, 0, 8.3, 4, 1, 2]
		
		XCTAssertEqual(1, v1.firstNonZero())
		XCTAssertEqual(3.4, v2.firstNonZero())
		XCTAssertEqual(1, v3.firstNonZero())
		XCTAssertEqual(5.3, v4.firstNonZero())
		XCTAssertEqual(8.3, v8.firstNonZero())
	}
	
	func testFirstNonZeroIndex() {
		let v1: Vector = [1]
		let v2: Vector = [0, 3.4]
		let v3: Vector = [0, 1, 2]
		let v4: Vector = [0, 0, 5.3, 0]
		let v8: Vector = [0, 0, 0, 0, 8.3, 4, 1, 2]
		
		XCTAssertEqual(0, v1.firstNonZeroIndex())
		XCTAssertEqual(1, v2.firstNonZeroIndex())
		XCTAssertEqual(1, v3.firstNonZeroIndex())
		XCTAssertEqual(2, v4.firstNonZeroIndex())
		XCTAssertEqual(4, v8.firstNonZeroIndex())
	}

	func testIsParallel() {
		let v1: Vector = [1, 2, 3]
		let v2: Vector = [3, 6, 9]
		let v3: Vector = [1, 2, -3]
		
		XCTAssertTrue(v1.isParallel(to: v2))
		XCTAssertFalse(v1.isParallel(to: v3))
	}
	
	func testLinearIndependance() {
		let v1: Vector = [1, 2, 3]
		let v2: Vector = [3, 6, 9]
		let v3: Vector = [1, 2, -3]
		
		measure {
			XCTAssertFalse(Vector.isLinearIndependantSet(v1, v2, v3)!)
			XCTAssertTrue(Vector.isLinearIndependantSet(v1, v3)!)
		}
	}
	
	func testCrossProduct() {
		let v1 = Vector<Double>.unitVector(ofDimension: 3, onAxis: 0)
		let v2 = Vector<Double>.unitVector(ofDimension: 3, onAxis: 1)
		
		let x = v1.crossProduct(with: v2)
		let y = v2.crossProduct(with: v1)
		
		XCTAssertEqual(x, [0, 0, 1])
		XCTAssertEqual(y, [0, 0, -1])
	}
	
	func testDescription() {
		let v1: Vector = [1, 2, 3]
		let v2: Vector = [2, 3, 0]
		
		XCTAssertEqual(v1.description, "< 1.0  2.0  3.0 >")
		XCTAssertEqual(v2.description, "< 2.0  3.0  0.0 >")
	}
	
	func testOperators() {
		let v1: Vector = [1, 2, 3]
		let v2: Vector = [2, 3, 0]
		
		XCTAssertEqual(v1 + v2, [3, 5, 3])
		XCTAssertEqual(-v1, [-1, -2, -3])
		XCTAssertEqual(v1 - v2, [-1, -1, 3])
		
		XCTAssertEqual(3 * v1, [3, 6, 9])
		XCTAssertEqual(v1 * 3, 3 * v1)
	}
	
}
