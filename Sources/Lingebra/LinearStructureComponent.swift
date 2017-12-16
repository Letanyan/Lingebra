//
//  VectorComponent.swift
//  Lingebra
//
//  Created by Letanyan Arumugam on 2017/12/11.
//

import Swift

public protocol LinearStructureComponent : Comparable, SignedNumeric {
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
	public static func -(lhs: Self, rhs: Self) -> Self {
		return lhs + -rhs
	}
	
	public static func /(lhs: Self, rhs: Self) -> Self {
		return lhs * rhs.inverse()
	}
	
	public static func +=(lhs: inout Self, rhs: Self) {
		lhs = lhs + rhs
	}
	
	public static func -=(lhs: inout Self, rhs: Self) {
		lhs = lhs - rhs
	}
	
	public static func *=(lhs: inout Self, rhs: Self) {
		lhs = lhs * rhs
	}
	
	public static func /=(lhs: inout Self, rhs: Self) {
		lhs = lhs * rhs
	}
}

extension Float32 : LinearStructureComponent {
	public func inverse() -> Float32 {
		return 1 / self
	}
	
	public static var zero: Float32 {
		return 0
	}
	
	public static var one: Float32 {
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
	public func inverse() -> Float64 {
		return 1 / self
	}
	
	public static var zero: Float64 {
		return 0
	}
	
	public static var one: Float64 {
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
