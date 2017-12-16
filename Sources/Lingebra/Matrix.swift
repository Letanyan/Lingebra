//
//  Matrix.swift
//  Lingebra
//
//  Created by Letanyan Arumugam on 2017/12/11.
//

import Swift

struct Matrix<Component: LinearStructureComponent> : Grid {
	typealias Cell = Component
	
	//MARK:- Initialisation
	var cells: [Component] {
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
	var rowCount, colCount, count: Int
	private var _rows: [[Component]]
	
	init(rows: [[Component]]) {
		cells = Array(rows.joined())
		self._rows = rows
		rowCount = rows.count
		colCount = rows.first?.count ?? 0
		count = rowCount * (colCount == 0 ? 1 : colCount)
	}
	
	init(array: [Component], colCount: Int) {
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
	
	func rows() -> [[Component]] {
		return _rows
	}
	
	//MARK:- Get Matrix
	func rowMatrix(at index: Int) -> Matrix {
		return Matrix(rows: [row(at: index)])
	}
	
	func colMatrix(at index: Int) -> Matrix {
		return Matrix(array: col(at: index), colCount: 1)
	}
	
	static func rectangularIdentityMatrix(ofRowSize n: Int, andColSize m: Int) -> Matrix {
		var result = [[Component]]()
		for i in 0..<n {
			var r = [Component](repeating: Component.zero, count: m)
			if i < m { r[i] = Component.one }
			result.append(r)
		}
		return Matrix(rows: result)
	}
	
	static func identityMatrix(ofSize n: Int) -> Matrix {
		var result = [[Component]]()
		for i in 0..<n {
			var r = [Component](repeating: .zero, count: n)
			r[i] = Component.one
			result.append(r)
		}
		return Matrix(rows: result)
	}
	
	func isIdentity() -> Bool {
		return self == .rectangularIdentityMatrix(ofRowSize: rowCount, andColSize: colCount)
	}
	
	func augmented(with vector: Vector<Component>) -> AugmentedMatrix<Component> {
		return AugmentedMatrix(matrix: self, result: vector)
	}
	
	func splitMatrix(atIndex index: Int) -> (left: Matrix, right: Matrix) {
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
	
	func coefficientsMatrix() -> Matrix {
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

	func constantsColoumn() -> Vector<Component> {
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
	func minor(at coord: GridCoordinate) -> Matrix {
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
	
	func minor(atRow row: Int, andCol col: Int) -> Matrix {
		return minor(at: GridCoordinate(row: row, col: col))
	}
	
	func minor(at linearPosition: Int) -> Matrix {
		return minor(at: gridCoordinate(from: linearPosition))
	}
	
	func replace(coloumn: Int, with vector: Vector<Component>) -> Matrix {
		var new = cells
		
		for idx in new.startIndex... {
			if idx % coloumn == 0 {
				new[idx] = vector[idx / coloumn]
			}
		}
		
		return Matrix(array: new, colCount: colCount)
	}
	
	func replace(row: Int, with vector: Vector<Component>) -> Matrix {
		var new = cells
		let start = row * colCount
		
		for i in start..<(start + colCount) {
			new[i] = vector[i - start]
		}
		
		return Matrix(array: new, colCount: colCount)
	}
	
	//MARK:- Arithmetic
	func determinateValue(of minor: Matrix) -> Component {
		var result = Component.zero
		if minor.colCount < 2 && minor.rowCount < 2 {
			return .one
		} else if minor.colCount == 2 && minor.rowCount == 2 {
			let a = minor.cell(in: 0, and: 0) ?? .zero
			let d = minor.cell(in: 1, and: 1) ?? .zero
			let b = minor.cell(in: 0, and: 1) ?? .zero
			let c = minor.cell(in: 1, and: 0) ?? .zero
			
			return a * d - b * c
		} else {
			for (idx, element) in minor.row(at: 0).enumerated() {
				let mino = minor.minor(at: idx)
				result = result + (idx % 2 == 0 ? .one : -.one) * element * determinateValue(of: mino)
			}
			return result
		}
	}
	
	func determinateValue() -> Component {
		return determinateValue(of: self)
	}
	
	func matrixOfMinorValues() -> Matrix {
		var result = [Component]()
		
		for i in 0..<count {
			let temp = self.minor(at: i)
			result.append(temp.determinateValue())
		}
		return Matrix(array: result, colCount: colCount)
	}
	
	func adjugate() -> Matrix {
		var result = [Component]()
		
		for i in 0..<colCount {
			let temp = col(at: i)
			result.append(contentsOf: temp)
		}
		
		return Matrix(array: result, colCount: rowCount)
	}
	
	func transposed() -> Matrix {
		return adjugate()
	}
	
	func cofactor() -> Matrix {
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
	
	func inverseMatrix() -> Matrix {
		var matrix = matrixOfMinorValues()
		matrix = matrix.cofactor()
		matrix = matrix.adjugate()
		
		let determinate = .one / determinateValue()
		
		return matrix * determinate
	}
	
	//MARK:- Solve
	func solveFromInverse(for vector: Vector<Component>) -> Matrix {
		return inverseMatrix() * Matrix(array: vector.components, colCount: 1)
	}
	
	func solve(for vector: Vector<Component>) -> Vector<Component> {
		let d = determinateValue()
		var result = [Component]()
		for i in 0..<colCount {
			let a1 = replace(coloumn: i, with: vector)
			let d1 = a1.determinateValue()
			result.append(d1 / d)
		}
		return Vector(result)
	}
	
	func rowEchelonForm() -> Matrix {
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
	
	func reducedRowEchelonForm() -> Matrix {
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
	var description: String {
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
	static func ==(lhs: Matrix, rhs: Matrix) -> Bool {
		return lhs.colCount == rhs.colCount && lhs.cells == rhs.cells
	}
	
	static func +(lhs: Matrix, rhs: Matrix) -> Matrix {
		var array = [Component]()
		
		for i in 0..<lhs.count {
			array.append((lhs.cell(from: i) ?? .zero) + (rhs.cell(from: i) ?? .zero))
		}
		
		return Matrix(array: array, colCount: lhs.colCount)
	}
	
	static func -(lhs: Matrix, rhs: Matrix) -> Matrix {
		var array = [Component]()
		
		for i in 0..<lhs.count {
			array.append((lhs.cell(from: i) ?? .zero) - (rhs.cell(from: i) ?? .zero))
		}
		
		return Matrix(array: array, colCount: lhs.colCount)
	}
	
	static func *(lhs: Matrix, rhs: Matrix) -> Matrix {
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

func *<Component>(lhs: Matrix<Component>, rhs: Component) -> Matrix<Component> {
	var array = lhs
	
	for (idx, cell) in zip(array.cells.startIndex..., array.cells) {
		array.cells[idx] = cell * rhs
	}
	
	return array
}

func *<Component>(lhs: Component, rhs: Matrix<Component>) -> Matrix<Component> {
	var array = rhs
	
	for (idx, cell) in zip(array.cells.startIndex..., array.cells) {
		array.cells[idx] = cell * lhs
	}
	
	return array
}

extension Matrix : ExpressibleByArrayLiteral {
	typealias ArrayLiteralElement = [Component]
	
	init(arrayLiteral elements: [Component]...) {
		self = Matrix(rows: elements)
	}
}
