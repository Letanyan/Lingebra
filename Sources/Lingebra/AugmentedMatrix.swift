//
//  AugmentedMatrix.swift
//  Lingebra
//
//  Created by Letanyan Arumugam on 2017/12/11.
//

import Swift

public enum Solution<Component: LinearStructureComponent> : CustomStringConvertible {
	case none
	case point(Vector<Component>)
	case space(OffsetSubspace<Component>)
	
	public var description: String {
		switch self {
		case .none: return "no solution"
		case let .point(p): return p.description
		case let .space(vs): return vs.description
		}
	}
}

public struct AugmentedMatrix<Component: LinearStructureComponent> : CustomStringConvertible {
	public var matrix: Matrix<Component>
	
	public var description: String {
		var result = ""
		for row in matrix.rows() {
			for v in row.dropLast() {
				result +=  "\(v) "
			}
			result += "| \(row.last!)\n"
		}
		return result
	}
	
	struct SolutionComponent : CustomStringConvertible {
		enum Result : CustomStringConvertible {
			case variable(Int, Component)
			case value(Component)
			
			func multiplied(with value: Component) -> Result {
				switch self {
				case let .variable(id, v): return .variable(id, v * value)
				case let .value(v): return .value(v * value)
				}
			}
			
			mutating func changeTo(value: Component) {
				switch self {
				case let .variable(id, _): self = .variable(id, value)
				case .value(_): self = .value(value)
				}
			}
			
			var description: String {
				switch self {
				case let .variable(i, v): return "\(v)x[\(i)]"
				case let .value(v): return "\(v)"
				}
			}
			
			var value: Component {
				switch self {
				case let .variable(_, v): return v
				case let .value(v): return v
				}
			}
			
			var variable: String {
				switch self {
				case let .variable(i, _): return "x[\(i)]"
				default: return ""
				}
			}
			
			func matches(condition: Condition) -> Bool {
				switch condition {
				case let .variable(i):
					switch self {
					case let .variable(id, _): return id == i
					default: return false
					}
				case .value:
					switch self {
					case .value(_): return true
					default: return false
					}
				}
			}
		}
		enum Condition {
			case variable(Int)
			case value
			
			var id: Int {
				switch self {
				case let .variable(i): return i
				default: return -1
				}
			}
		}
		
		var results: [Result]
		
		init() {
			results = []
		}
		
		init(variableID: Int, value: Component = Component.one) {
			results = [.variable(variableID, value)]
		}
		
		init(results: [Result]) {
			self.results = results
		}
		
		mutating func append(variableID: Int, value: Component) {
			results.append(.variable(variableID, value))
		}
		
		mutating func append(solutionComponent: SolutionComponent) {
			for res in solutionComponent.results {
				if res.value != .zero {
					results.append(res)
				}
			}
		}
		
		func multiplied(with value: Component) -> SolutionComponent {
			return SolutionComponent(results: results.map { $0.multiplied(with: value) })
		}
		
		func values(where condition: Condition) -> Component {
			return results
				.filter { $0.matches(condition: condition) }
				.map { $0.value }
				.reduce(.zero) { $0 + $1 }
		}
		
		public var description: String {
			var result = (results.first ?? .value(.zero)).description
			for r in results.dropFirst() {
				let sign = r.value < .zero ? "-" : "+"
				result += " \(sign) \(abs(r.value))\(r.variable)"
			}
			return result
		}
	}
	
	public init(matrix: Matrix<Component>, result: Vector<Component>) {
		self.matrix = Matrix(rows: matrix.rows().enumerated().map { $0.element + [result[$0.offset]] })
	}
	
	public init(matrix: Matrix<Component>) {
		self.matrix = matrix
	}
	
	
	func solutionExists() -> Bool {
		let rref = matrix.reducedRowEchelonForm()
		let a = rref.coefficientsMatrix()
		let x = rref.constantsColoumn()
		
		for (idx, row) in a.rows().enumerated() {
			let v = Vector(row)
			if v == v.zero && x[idx] != .zero {
				return false
			}
		}
		return true
	}
	
	public func solution() -> Solution<Component> {
		let rref = matrix.reducedRowEchelonForm()
		
		let a = rref.coefficientsMatrix()
		let x = rref.constantsColoumn()
		
		guard solutionExists() else {
			return .none
		}
		
		guard !a.isIdentity() else {
			return .point(x)
		}
		
		var result = [SolutionComponent]()
		for i in 0..<a.colCount {
			result.append(SolutionComponent(variableID: i))
		}
		
		for row in a.rows().reversed() {
			let v = Vector(row)
			guard let idx = v.firstNonZeroIndex(), idx < x.count else {
				continue
			}
			
			result[idx].results[0] = .value(x[idx])
			
			
			guard idx != a.colCount - 1 else {
				continue
			}
			
			for i in (idx + 1)...(a.colCount - 1) {
				let vi = v[i]
				let va = result[i].multiplied(with: -vi)
				result[idx].append(solutionComponent: va)
			}
		}
		
		let zero = [Component](repeating: Component.zero, count: a.colCount)
		let offset = Vector(result.map { $0.values(where: .value) })
		
		
		var collections = [result.map { $0.values(where: .variable(0)) }]
		if let f = collections.first, f == zero {
			collections.removeFirst()
		}
		
		for i in 1...(a.colCount - 1) {
			let r = result.map { $0.values(where: .variable(i)) }
			if r != zero {
				collections.append(r)
			}
		}
		
		let s = Subspace(directions: collections.map(Vector.init))
		
		// if s is empty (ie {0}) then it is included in the result
		// not sure if this is valid for a point
		// p + {0} = p ??????
		let vs = OffsetSubspace(subspace: s, offset: offset)
		
		return .space(vs)
	}
}
