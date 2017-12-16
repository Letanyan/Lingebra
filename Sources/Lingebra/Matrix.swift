//
//  Matrix.swift
//  Lingebra
//
//  Created by Letanyan Arumugam on 2017/12/11.
//

import Swift

public struct Matrix<Component: LinearStructureComponent> : Grid {
	public typealias Cell = Component
	
	//MARK:- Initialisation
	public var cells: [Component] {
		didSet {
			var x = [Component]()
			_rows = [[Component]]()
			for (idx, cell) in zip(cells.startIndex..., cells) {
				if idx != 0 && idx % colCount == 0 {
					_rows.append(x)
					x.removeAll(keepingCapacity: true)
				}
				x.append(cell)
			}
			_rows.append(x)
		}
	}
	public var rowCount, colCount, count: Int
	private var _rows: [[Component]]
	
	public init(rows: [[Component]]) {
		cells = Array(rows.joined())
		self._rows = rows
		rowCount = rows.count
		colCount = rows.first?.count ?? 0
		count = rowCount * (colCount == 0 ? 1 : colCount)
	}
	
	public init(array: [Component], colCount: Int) {
		cells = array
		
		var x = [Component]()
		_rows = [[Component]]()
		for (idx, cell) in zip(cells.startIndex..., cells) {
			if idx != 0 && idx % colCount == 0 {
				_rows.append(x)
				x.removeAll(keepingCapacity: true)
			}
			x.append(cell)
		}
		_rows.append(x)
		
		rowCount = cells.count / colCount
		self.colCount = colCount
		count = array.count
	}
	
	public func rows() -> [[Component]] {
		return _rows
	}
	
	//MARK:- Get Matrix
	public func rowMatrix(at index: Int) -> Matrix {
		return Matrix(rows: [row(at: index)])
	}
	
	public func colMatrix(at index: Int) -> Matrix {
		return Matrix(array: col(at: index), colCount: 1)
	}
	
	public static func rectangularIdentityMatrix(ofRowSize n: Int, andColSize m: Int) -> Matrix {
		var result = [[Component]]()
		for i in 0..<n {
			var r = [Component](repeating: Component.zero, count: m)
			if i < m { r[i] = Component.one }
			result.append(r)
		}
		return Matrix(rows: result)
	}
	
	public static func identityMatrix(ofSize n: Int) -> Matrix {
		var result = [[Component]]()
		for i in 0..<n {
			var r = [Component](repeating: .zero, count: n)
			r[i] = Component.one
			result.append(r)
		}
		return Matrix(rows: result)
	}
	
	public func isIdentity() -> Bool {
		return self == .rectangularIdentityMatrix(ofRowSize: rowCount, andColSize: colCount)
	}
	
	public func augmented(with vector: Vector<Component>) -> AugmentedMatrix<Component> {
		return AugmentedMatrix(matrix: self, result: vector)
	}
	
	public func splitMatrix(atIndex index: Int) -> (left: Matrix, right: Matrix) {
		var left = [Component]()
		var right = [Component]()
		
		var count = 0
		for cell in cells {
			if count < index {
				left.append(cell)
			} else if count < colCount {
				right.append(cell)
			} else {
				count = 0
				left.append(cell)
			}
			count += 1
		}
		
		let l = Matrix(array: left, colCount: index)
		let r = Matrix(array: right, colCount: colCount - index)
		return (l, r)
	}
	
	public func coefficientsMatrix() -> Matrix {
		var result = [Component]()
		
		var count = 0
		for cell in cells {
			if count < colCount - 1 {
				result.append(cell)
				count += 1
			} else {
				count = 0
			}
		}
		
		return Matrix(array: result, colCount: colCount - 1)
	}

	public func constantsColoumn() -> Vector<Component> {
		var result = [Component]()
		
		var cnt = 0
		for cell in cells {
			if cnt == colCount - 1 {
				result.append(cell)
				cnt = 0
			} else {
				cnt += 1
			}
		}
		
		return Vector(result)
	}
	
	//MARK:- Get Minor
	public func minor(at coord: GridCoordinate) -> Matrix {
		var array = [Component]()
		
		for i in 0..<self.count {
			let coord_ = gridCoordinate(from: i)
			
			if coord.row != coord_.row && coord.col != coord_.col {
				let e = cells[i]
				array.append(e)
			}
		}
		
		return Matrix(array: array, colCount: colCount - 1)
	}
	
	public func minor(atRow row: Int, andCol col: Int) -> Matrix {
		return minor(at: GridCoordinate(row: row, col: col))
	}
	
	public func minor(at linearPosition: Int) -> Matrix {
		return minor(at: gridCoordinate(from: linearPosition))
	}
	
	public func replace(coloumn: Int, with vector: Vector<Component>) -> Matrix {
		var new = cells
		
		for i in 0..<rowCount {
			new[i * colCount + coloumn] = vector[i]
		}
		
		return Matrix(array: new, colCount: colCount)
	}
	
	public func replace(row: Int, with vector: Vector<Component>) -> Matrix {
		var new = cells
		let start = row * colCount
		
		for i in start..<(start + colCount) {
			new[i] = vector[i - start]
		}
		
		return Matrix(array: new, colCount: colCount)
	}
	
	//MARK:- Arithmetic
	public static func determinateValue(of matrix: Matrix) -> Component {
		var result = Component.zero
		if matrix.colCount == 1 && matrix.rowCount == 1 {
			return matrix.cells[0]
		} else if matrix.colCount == 2 && matrix.rowCount == 2 {
			let a = matrix.cell(inRow: 0, andCol: 0) ?? .zero
			let d = matrix.cell(inRow: 1, andCol: 1) ?? .zero
			let b = matrix.cell(inRow: 0, andCol: 1) ?? .zero
			let c = matrix.cell(inRow: 1, andCol: 0) ?? .zero
			
			return a * d - b * c
		} else {
			for idx in 0..<matrix.colCount {
				let m = matrix.minor(at: idx).determinateValue()
				let e = matrix.cells[idx]
				result = result + (idx & 1 == 0 ? .one : -.one) * e * m
			}
			return result
		}
	}
	
	public func determinateValue() -> Component {
		let (f, m) = rowEchelonFormWithChanges()
		
		var result = Component.one
		for i in 0..<m.colCount {
			result *= m.cells[i * m.colCount + i]
		}
		
		return f ? -result : result
	}
	
	public func matrixOfMinorValues() -> Matrix {
		var result = [Component]()
		
		for i in 0..<count {
			let temp = self.minor(at: i)
			result.append(temp.determinateValue())
		}
		return Matrix(array: result, colCount: colCount)
	}
	
	public func adjugate() -> Matrix {
		var result = [Component]()
		
		for i in 0..<colCount {
			let temp = col(at: i)
			result.append(contentsOf: temp)
		}
		
		return Matrix(array: result, colCount: rowCount)
	}
	
	public func transposed() -> Matrix {
		return adjugate()
	}
	
	public func cofactor() -> Matrix {
		var result = [Component]()
		
		for i in 0..<rowCount {
			let temp = row(at: i)
			
			for k in 0..<temp.count {
				var sign = k % 2 == 0 ? Component.one : -.one
				sign *= i % 2 == 0 ? .one : -.one
				
				let value = temp[k]
				result.append(value * sign)
			}
		}
		
		return Matrix(array: result, colCount: colCount)
	}
	
	public func inverseMatrix() -> Matrix {
		var matrix = matrixOfMinorValues()
		matrix = matrix.cofactor()
		matrix = matrix.adjugate()
		
		let determinate = .one / determinateValue()
		
		return matrix * determinate
	}
	
	//MARK:- Solve
	public func solveFromInverse(for vector: Vector<Component>) -> Matrix {
		return inverseMatrix() * Matrix(array: vector.components, colCount: 1)
	}
	
	public func solve(for vector: Vector<Component>) -> Vector<Component> {
		let d = determinateValue()
		var result = [Component]()
		for i in 0..<colCount {
			let a1 = replace(coloumn: i, with: vector)
			let d1 = a1.determinateValue()
			result.append(d1 / d)
		}
		return Vector(result)
	}
	
	private func rowEchelonFormWithChanges() -> (Bool, Matrix) {
		var result = self
		var flip = false
		
		for r in 0..<result.rowCount - 1 {
			guard r < result.colCount else {
				break
			}
			
			let f = Vector(result.row(at: r))
			
			guard f != f.zero else {
				continue
			}
			
			for n in (r + 1)...(result.rowCount - 1) {
				let g = Vector(result.row(at: n))
				guard g != g.zero, g[r] != .zero, f[r] != .zero else {
					continue
				}
				let a = g[r] / f[r]
				result = result.replace(row: n, with: g - a * f)
			}
		}
		
		for i in 0..<result.rowCount {
			guard let (idx, row) = result.rows()
				.enumerated()
				.first(where: {
					Vector($0.1).firstNonZeroIndex() ?? -1 == i
				}) else {
					continue
			}
			
			if idx != i {
				result = result.replace(row: idx, with: Vector(result.row(at: i)))
				result = result.replace(row: i, with: Vector(row))
				flip = !flip
			}
		}
		
		return (flip, result)
	}
	
	public func rowEchelonForm() -> Matrix {
		var result = self
		
		for r in 0..<result.rowCount - 1 {
			guard r < result.colCount else {
				break
			}
			
			let f = Vector(result.row(at: r))
			
			guard f != f.zero else {
				continue
			}
			
			for n in (r + 1)...(result.rowCount - 1) {
				//			for n in 0...(result.rowCount - 1) {
				//				guard n != r else {
				//					continue
				//				}
				let g = Vector(result.row(at: n))
				guard g != g.zero, g[r] != .zero, f[r] != .zero else {
					continue
				}
				let a = f[r] / g[r]
				result = result.replace(row: n, with: f - (a * g))
				//				print(a)
				//				print(result)
			}
		}
		
		for i in 0..<result.rowCount {
			guard let (idx, row) = result.rows().enumerated()
				.first(where: { Vector($0.1).firstNonZeroIndex() ?? -1 == i }) else {
					continue
			}
			
			if idx != i {
				result = result.replace(row: idx, with: Vector(result.row(at: i)))
				result = result.replace(row: i, with: Vector(row))
			}
		}
		
		return result
	}
	
	public func reducedRowEchelonForm() -> Matrix {
		var result = rowEchelonForm()
		
		for i in 0..<result.rowCount {
			let f = Vector(result.row(at: i))
			guard let x = f.firstNonZero() else {
				continue
			}
			
			let a = x.inverse()
			result = result.replace(row: i, with: f * a)
		}
		
		for i in (0...result.rowCount - 1).reversed() {
			let f = Vector(result.row(at: i))
			
			guard f != f.zero else {
				continue
			}
			
			for j in 0..<result.rowCount {
				let g = Vector(result.row(at: j))
				guard j != i, g != g.zero, let fa = f.firstNonZeroIndex() else {
					continue
				}
				
				guard f[fa] != .zero else {
					continue
				}
				let a = g[fa] / f[fa]
				result = result.replace(row: j, with: g - (a * f))
			}
		}
		
		
		return result
	}
}

extension Matrix : CustomStringConvertible {
	public var description: String {
		get {
			var result = ""
			
			for i in 0..<count {
				if i % colCount == 0 {
					result += "\n"
				}
				result += " \(cell(from: i)!)"
			}
			
			return result
		}
	}
}


//Operators
extension Matrix : Equatable {
	public static func ==(lhs: Matrix, rhs: Matrix) -> Bool {
		return lhs.colCount == rhs.colCount && lhs.cells == rhs.cells
	}
	
	public static func +(lhs: Matrix, rhs: Matrix) -> Matrix {
		var array = [Component]()
		
		for i in 0..<lhs.count {
			array.append((lhs.cell(from: i) ?? .zero) + (rhs.cell(from: i) ?? .zero))
		}
		
		return Matrix(array: array, colCount: lhs.colCount)
	}
	
	public static func -(lhs: Matrix, rhs: Matrix) -> Matrix {
		var array = [Component]()
		
		for i in 0..<lhs.count {
			array.append((lhs.cell(from: i) ?? .zero) - (rhs.cell(from: i) ?? .zero))
		}
		
		return Matrix(array: array, colCount: lhs.colCount)
	}
	
	public static func *(lhs: Matrix, rhs: Matrix) -> Matrix {
		var array = [Component]()
		
		for i in 0..<lhs.rowCount {
			let row = lhs.row(at: i)
			
			for k in 0..<rhs.colCount {
				let col = rhs.col(at: k)
				let ans = (Vector(row).innerProduct(Vector(col)))
				array.append(ans)
			}
			
		}
		
		return Matrix(array: array, colCount: rhs.colCount)
	}
}

public func *<Component>(lhs: Matrix<Component>, rhs: Component) -> Matrix<Component> {
	var array = lhs
	
	for (idx, cell) in zip(array.cells.startIndex..., array.cells) {
		array.cells[idx] = cell * rhs
	}
	
	return array
}

public func *<Component>(lhs: Component, rhs: Matrix<Component>) -> Matrix<Component> {
	var array = rhs
	
	for (idx, cell) in zip(array.cells.startIndex..., array.cells) {
		array.cells[idx] = cell * lhs
	}
	
	return array
}

extension Matrix : ExpressibleByArrayLiteral {
	public typealias ArrayLiteralElement = [Component]
	
	public init(arrayLiteral elements: [Component]...) {
		self = Matrix(rows: elements)
	}
}
