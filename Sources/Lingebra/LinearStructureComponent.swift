//
//  VectorComponent.swift
//  Lingebra
//
//  Created by Letanyan Arumugam on 2017/12/11.
//

import Swift

protocol LinearStructureComponent : Comparable, SignedNumeric {
	static func +(lhs: Self, rhs: Self) -> Self
	static func -(lhs: Self, rhs: Self) -> Self
	static func *(lhs: Self, rhs: Self) -> Self
	static func /(lhs: Self, rhs: Self) -> Self
	
	static func +=(lhs: inout Self, rhs: Self)
	static func -=(lhs: inout Self, rhs: Self)
	static func *=(lhs: inout Self, rhs: Self)
	static func /=(lhs: inout Self, rhs: Self)
	
	static prefix func -(rhs: Self) -> Self
	
	func inverse() -> Self
	func squareRoot() -> Self
	
	static var zero: Self { get }
	static var one: Self { get }
}

extension LinearStructureComponent {
	static func -(lhs: Self, rhs: Self) -> Self {
		return lhs + -rhs
	}
	
	static func /(lhs: Self, rhs: Self) -> Self {
		return lhs * rhs.inverse()
	}
	
	static func +=(lhs: inout Self, rhs: Self) {
		lhs = lhs + rhs
	}
	
	static func -=(lhs: inout Self, rhs: Self) {
		lhs = lhs - rhs
	}
	
	static func *=(lhs: inout Self, rhs: Self) {
		lhs = lhs * rhs
	}
	
	static func /=(lhs: inout Self, rhs: Self) {
		lhs = lhs * rhs
	}
}

extension Float32 : LinearStructureComponent {
	func inverse() -> Float32 {
		return 1 / self
	}
	
	static var zero: Float32 {
		return 0
	}
	
	static var one: Float32 {
		return 1
	}
	
	static func ==(lhs: Float32, rhs: Float32) -> Bool {
		if lhs.isZero && rhs.isZero {
			return true
		} else {
			return lhs == rhs
		}
	}
}

extension Float64 : LinearStructureComponent {
	func inverse() -> Float64 {
		return 1 / self
	}
	
	static var zero: Float64 {
		return 0
	}
	
	static var one: Float64 {
		return 1
	}
	
	static func ==(lhs: Float64, rhs: Float64) -> Bool {
		if lhs.isZero && rhs.isZero {
			return true
		} else {
			return lhs == rhs
		}
	}
}

extension Float80 : LinearStructureComponent {
	func inverse() -> Float80 {
		return 1 / self
	}
	
	static var zero: Float80 {
		return 0
	}
	
	static var one: Float80 {
		return 1
	}
	
	static func ==(lhs: Float80, rhs: Float80) -> Bool {
		if lhs.isZero && rhs.isZero {
			return true
		} else {
			return lhs == rhs
		}
	}
}
