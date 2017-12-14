import Swift

struct Vector<Component: LinearStructureComponent> {
	var components: [Component]
	
	init(_ values: [Component]) {
		self.components = values
	}
	
	init(x: Component, y: Component) {
		components = [x, y]
	}
	
	init(x: Component, y: Component, z: Component) {
		components = [x, y, z]
	}
	
	init(_ values: Component...) {
		self.components = values
	}
	
	var x: Component {
		return self[0]
	}
	
	var y: Component {
		return self[1]
	}
	
	var z: Component {
		return self[2]
	}
	
	static func unitVector(ofDimension dimension: Int, onAxis axis: Int) -> Vector {
		var resultArray = [Component](repeating: Component.zero, count: dimension)
		resultArray[axis] = Component.one
		return Vector(resultArray)
	}
	
	func unitVector(onAxis axis: Int) -> Vector {
		var resultArray = [Component](repeating: Component.zero, count: dimension)
		resultArray[axis] = Component.one
		return Vector(resultArray)
	}
	
	static func zeroVector(ofDimension dimension: Int) -> Vector {
		return Vector([Component](repeating: .zero, count: dimension))
	}
	
	var zero: Vector {
		return Vector([Component](repeating: Component.zero, count: dimension))
	}
	
	var norm: Component {
		return components.reduce(Component.zero){ $0 + $1 * $1 }.squareRoot()
	}
	
	var dimension: Int {
		return components.count
	}
	
	func firstNonZero() -> Component? {
		for value in components {
			if value != Component.zero {
				return value
			}
		}
		return nil
	}
	
	func firstNonZeroIndex() -> Int? {
		for value in components {
			if value != Component.zero {
				return index(of: value)
			}
		}
		return nil
	}
}

extension Vector {
	func isParallel(to vector: Vector) -> Bool {
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
	
	static func isLinearIndependantSet(_ vs: Vector...) -> Bool? {
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
	
	func crossProduct(with v: Vector) -> Vector? {
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
	typealias Index = Int
	var startIndex: Index {
		return components.startIndex
	}
	
	var endIndex: Index {
		return components.endIndex
	}
	
	subscript(index: Index) -> Component {
		return components[index]
	}
	
	func index(after: Index) -> Index {
		return after + 1
	}
}

extension Vector : ExpressibleByArrayLiteral {
	typealias Element = Component
	
	init(arrayLiteral: Component...) {
		components = arrayLiteral
	}
}

extension Vector : CustomStringConvertible {
	var description: String {
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
	static func ==(lhs: Vector, rhs: Vector) -> Bool {
		guard lhs.count == rhs.count else {
			return false
		}
		
		for (idx, comp) in lhs.components.enumerated() {
			if comp != rhs[idx] {
				return false
			}
		}
		return true
	}
}

extension Int {
	mutating func intoIntegerSpace(of size: Int) {
		self = self >= 0 ? self % size : self + size * (-self / size + 1)
	}
	
	func integerSpaceRepresentation(of size: Int) -> Int {
		var x = self
		x.intoIntegerSpace(of: size)
		return x
	}
}

extension Vector {
	static func +(lhs: Vector, rhs: Vector) -> Vector {
		return Vector(zip(lhs, rhs).map { $0.0 + $0.1 })
	}
	
	static prefix func -(operand: Vector) -> Vector {
		return Vector(operand.map { -$0 })
	}
	
	static func -(lhs: Vector, rhs: Vector) -> Vector {
		return lhs + -rhs
	}
	
	static func *(lhs: Vector, rhs: Vector) -> Component {
		return zip(lhs, rhs)
			.map { $0.0 * $0.1 }
			.reduce(Component.zero, +)
	}
}

func *<T>(lhs: T, rhs: Vector<T>) -> Vector<T> {
	return Vector(rhs.map { $0 * lhs })
}

func *<T>(lhs: Vector<T>, rhs: T) -> Vector<T> {
	return Vector(lhs.map { $0 * rhs })
}

enum Intersection<I> {
	case none
	case equal
	case intersection(I)
}
