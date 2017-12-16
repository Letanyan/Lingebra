//
//  Subspace.swift
//  Lingebra
//
//  Created by Letanyan Arumugam on 2017/12/11.
//

import Swift

public struct Subspace<Component: LinearStructureComponent> {
	public var directions: [Vector<Component>]
	
	public init(_ directions: Vector<Component>...) {
		self.directions = directions.filter { $0 != $0.zero }
	}
	
	public init(directions: [Vector<Component>]) {
		self.directions = directions.filter { $0 != $0.zero }
	}
	
	public func basis() -> [Vector<Component>] {
		let m = Matrix(rows: directions.map(Array.init)).rowEchelonForm()
		
		let rs = m.rows().filter({ Vector($0) != Vector($0).zero })
		
		return rs.map(Vector.init)
	}
}

extension Subspace : CustomStringConvertible {
	public var description: String {
		return "span" + directions.description
	}
}

extension Matrix {
	public func rowSpace() -> Subspace<Component> {
		let m = rowEchelonForm()
		let rs = m.rows().filter({ Vector($0) != Vector($0).zero })
		let vs = rs.map(Vector.init)

		return Subspace(directions: vs)
	}

	public func colSpace() -> Subspace<Component> {
		let src = reducedRowEchelonForm()

		var result = [[Component]]()
		for i in 0..<src.colCount {
			let c = src.col(at: i)
			if c.filter({ $0 == 1 }).count == 1 {
				result.append(col(at: i))
			}
		}

		let vs = result.map(Vector.init)

		return Subspace(directions: vs)
	}
}

public struct OffsetSubspace<Component: LinearStructureComponent> : CustomStringConvertible {
	public var subspace: Subspace<Component>
	public var offset: Vector<Component>
	
	public init(subspace: Subspace<Component>, offset: Vector<Component>) {
		(self.subspace, self.offset) = (subspace, offset)
	}
	
	public var description: String {
		return "\(offset) + \(subspace)"
	}
	
	public var augmentedMatrix: AugmentedMatrix<Component> {
		let rs = subspace.directions.map{ $0.components }
		let m = Matrix(rows: rs).adjugate()
		
		return AugmentedMatrix(matrix: m, result: offset)
	}
	
	public func intersection(with space: OffsetSubspace<Component>) -> Solution<Component> {
		let solutionSpace = (self - space).augmentedMatrix.solution()
		
		switch solutionSpace {
		case .none:
			return .none
			
		case let .point(p):
			var sub = [Vector<Component>]()
			for (idx, s) in subspace.directions.enumerated() {
				sub.append(s * p[idx])
			}
			let result = sub.reduce(offset, +)
			return .point(result)
			
		case let .space(vs):
			let p = vs.offset
			var sub = [Vector<Component>]()
			for (idx, s) in subspace.directions.enumerated() {
				sub.append(s * p[idx])
			}
			let roffset = sub.reduce(offset, +)
			
			
			let dir = vs.subspace
			var subdir = [Vector<Component>]()
			for s in dir.directions {
				var sub = [Vector<Component>]()
				for (i, ss) in subspace.directions.enumerated() {
					sub.append(ss * s[i])
				}
				guard let f = sub.first else {
					continue
				}
				subdir.append(sub.reduce(f.zero, +))
			}
			
			let rvs = OffsetSubspace(subspace: Subspace(directions: subdir), offset: roffset)
			return .space(rvs)
		}
	}
	
	public static func -(lhs: OffsetSubspace<Component>, rhs: OffsetSubspace<Component>) -> OffsetSubspace<Component> {
		let o = lhs.offset - rhs.offset
		
		let l = lhs.subspace.directions
		let r = rhs.subspace.directions
		
		var result = [Vector<Component>]()
		for d in l {
			result.append(d)
		}
		for d in r {
			result.append(-d)
		}
		
		return OffsetSubspace(subspace: Subspace(directions: result), offset: o)
	}
}
