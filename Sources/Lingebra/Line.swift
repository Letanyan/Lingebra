//
//  Line.swift
//  Lingebra
//
//  Created by Letanyan Arumugam on 2017/12/11.
//

import Swift

struct Line<Component: LinearStructureComponent> {
	let space: OffsetSubspace<Component>
	
	init(pointA: Vector<Component>, pointB: Vector<Component>) {
		let direction = pointA - pointB
		let subspace = Subspace(direction)
		space = OffsetSubspace(subspace: subspace, offset: pointA)
	}
	
	init(point: Vector<Component>, direction: Vector<Component>) {
		space = OffsetSubspace(subspace: Subspace(direction), offset: point)
	}
	
	init(gradient: Component, yIntercept: Component) {
		let o = Vector(Component.zero, yIntercept)
		
		let xIntercept = Vector(-yIntercept / gradient, Component.zero)
		
		let dir: Vector<Component>
		if xIntercept == o {
			dir = [gradient, 1] // ISNT THIS ALWAYS THE DIRECTION
		} else {
			dir = o - xIntercept
		}
		
		space = OffsetSubspace(subspace: Subspace(dir), offset: o)
	}
	
	init(x: Component) {
		let o = Vector(x, Component.zero)
		let d = Vector(Component.zero, Component.one)
		
		space = OffsetSubspace(subspace: Subspace(d), offset: o)
	}
	
	init(y: Component) {
		let o = Vector(Component.zero, y)
		let d = Vector(Component.one, Component.zero)
		
		space = OffsetSubspace(subspace: Subspace(d), offset: o)
	}
}
