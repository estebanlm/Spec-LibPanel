Class {
	#name : 'DockPosition',
	#superclass : 'Object',
	#instVars : [
		'area',
		'position',
		'column',
		'row'
	],
	#category : 'Spec-Panel-Base',
	#package : 'Spec-Panel',
	#tag : 'Base'
}

{ #category : 'instance creation' }
DockPosition class >> newArea: aDockArea [

	^ self new 
		area: aDockArea;
		yourself
]

{ #category : 'accessing' }
DockPosition >> area [

	^ area
]

{ #category : 'accessing' }
DockPosition >> area: aDockArea [

	area := aDockArea
]

{ #category : 'accessing' }
DockPosition >> column [

	^ column
]

{ #category : 'accessing' }
DockPosition >> column: aNumber [

	column := aNumber
]

{ #category : 'accessing' }
DockPosition >> row [

	^ row
]

{ #category : 'accessing' }
DockPosition >> row: aNumber [

	row := aNumber
]

{ #category : 'converting' }
DockPosition >> toPanelPosition [
	| panelPosition |

	panelPosition := self area toPanelPosition.
	self column ifNotNil: [ :c | panelPosition column: c - 1 ].
	self row ifNotNil: [ :r | panelPosition row: r - 1 ].
	^ panelPosition
]

{ #category : 'converting' }
DockPosition >> toPosition [

	^ self
]
