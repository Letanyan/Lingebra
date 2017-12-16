import Swift

public struct Vector<Component: LinearStructureComponent> {
	public var components: [Component]
	
	public init(_ values: [Component]) {
		self.components = values
	}
	
	public init(x: Component, y: Component) {
		components = [x, y]
	}
	
	public init(x: Component, y: Component, z: Component) {
		components = [x, y, z]
	}
	
	public init(_ values: Component...) {
		self.components = values
	}
	
	public var x: Component {
		return self[0]
	}
	
	public var y: Component {
		return self[1]
	}
	
	public var z: Component {
		return self[2]
	}
	
	public static func unitVector(ofDimension dimension: Int, onAxis axis: Int) -> Vector {
		var resultArray = [Component](repeating: Component.zero, count: dimension)
		resultArray[axis] = Component.one
		return Vector(resultArray)
	}
	
	public func unitVector(onAxis axis: Int) -> Vector {
		var resultArray = [Component](repeating: Component.zero, count: dimension)
		resultArray[axis] = Component.one
		return Vector(resultArray)
	}
	
	public static func zeroVector(ofDimension dimension: Int) -> Vector {
		return Vector([Component](repeating: .zero, count: dimension))
	}
	
	public var zero: Vector {
		return Vector([Component](repeating: Component.zero, count: dimension))
	}
	
	public var norm: Component {
		return components.reduce(Component.zero){ $0 + $1 * $1 }.squareRoot()
	}
	
	public var dimension: Int {
		return components.count
	}
	
	public func firstNonZero() -> Component? {
		for value in components {
			if value != Component.zero {
				return value
			}
		}
		return nil
	}
	
	public func firstNonZeroIndex() -> Int? {
		for value in components {
			if value != Component.zero {
				return index(of: value)
			}
		}
		return nil
	}
	
	public func innerProduct(_ lhs: Vector) -> Component {
		var result = Component.zero
		
		for (idx, el) in self.enumerated() {
			result += el * lhs[idx]
		}
		
		return result
	}
}

extension Vector {
	public func isParallel(to vector: Vector) -> Bool {
		guard vector.dimension == dimension else {
			return false
		}
		guard dimension > 1 else {
			return true
		}
		
		let factor: Component = components[0] / vector[0]
		for i in 1..<dimension {
			let f = components[i] / vector[i]
			if f != factor {
				return false
			}
		}
		return true
	}
	
	public static func isLinearIndependantSet(_ vs: Vector...) -> Bool? {
		guard let fv = vs.first else {
			return true
		}
		
		for v in vs.dropFirst() {
			guard v.dimension == fv.dimension else {
				return nil
			}
		}
		
		let m = Matrix(rows: vs.map(Array.init))
			.transposed()
			.augmented(with: fv.zero)
		let s = m.solution()
		
		guard case let .point(p) = s else {
			return false
		}
		
		return p == p.zero
	}
	
	public func crossProduct(with v: Vector) -> Vector? {
		guard v.dimension == 3 && dimension == 3 else {
			return nil
		}
		
		let i = y * v.z - z * v.y
		let j = z * v.x - x * v.z
		let k = x * v.y - y * v.x
		
		return Vector(i, j, k)
	}
}

extension Vector : RandomAccessCollection {
	public typealias Index = Int
	public var startIndex: Index {
		return components.startIndex
	}
	
	public var endIndex: Index {
		return components.endIndex
	}
	
	public subscript(index: Index) -> Component {
		return components[index]
	}
	
	public func index(after: Index) -> Index {
		return after + 1
	}
}

extension Vector : ExpressibleByArrayLiteral {
	public typealias Element = Component
	
	public init(arrayLiteral: Component...) {
		components = arrayLiteral
	}
}

extension Vector : CustomStringConvertible {
	public var description: String {
		return "< " + reduce(""){ (t: String, e: Component) -> String in
			if t == "" {
				return "\(e)"
			} else {
				return t + "  " + "\(e)"
			}
			} + " >"
	}
}

extension Vector : Equatable {
	public static func ==(lhs: Vector, rhs: Vector) -> Bool {
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
}

extension Vector {
	public static func +(lhs: Vector, rhs: Vector) -> Vector {
		return Vector(zip(lhs, rhs).map { $0.0 + $0.1 })
	}
	
	public static prefix func -(operand: Vector) -> Vector {
		return Vector(operand.map { -$0 })
	}
	
	public static func -(lhs: Vector, rhs: Vector) -> Vector {
		return lhs + -rhs
	}
}

public func *<T>(lhs: T, rhs: Vector<T>) -> Vector<T> {
	return Vector(rhs.map { $0 * lhs })
}

public func *<T>(lhs: Vector<T>, rhs: T) -> Vector<T> {
	return Vector(lhs.map { $0 * rhs })
}
