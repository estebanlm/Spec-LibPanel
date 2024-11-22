Class {
	#name : 'DockPanelPosition',
	#superclass : 'Object',
	#instVars : [
		'area',
		'position',
		'column',
		'row'
	],
	#category : 'Spec-Panel-Presenter',
	#package : 'Spec-Panel',
	#tag : 'Presenter'
}

{ #category : 'instance creation' }
DockPanelPosition class >> newArea: aDockArea [

	^ self new 
		area: aDockArea;
		yourself
]

{ #category : 'accessing' }
DockPanelPosition >> area [

	^ area
]

{ #category : 'accessing' }
DockPanelPosition >> area: aDockArea [

	area := aDockArea
]

{ #category : 'accessing' }
DockPanelPosition >> column [

	^ column
]

{ #category : 'accessing' }
DockPanelPosition >> column: aNumber [

	column := aNumber
]

{ #category : 'accessing' }
DockPanelPosition >> row [

	^ row
]

{ #category : 'accessing' }
DockPanelPosition >> row: aNumber [

	row := aNumber
]

{ #category : 'converting' }
DockPanelPosition >> toPanelPosition [
	| panelPosition |

	panelPosition := self area toPanelPosition.
	self column ifNotNil: [ :c | panelPosition column: c - 1 ].
	self row ifNotNil: [ :r | panelPosition row: r - 1 ].
	^ panelPosition
]

{ #category : 'converting' }
DockPanelPosition >> toPosition [

	^ self
]
