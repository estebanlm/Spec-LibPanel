Class {
	#name : 'SpPanelPosition',
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
SpPanelPosition class >> newArea: aDockArea [

	^ self new 
		area: aDockArea;
		yourself
]

{ #category : 'accessing' }
SpPanelPosition >> area [

	^ area
]

{ #category : 'accessing' }
SpPanelPosition >> area: aDockArea [

	area := aDockArea
]

{ #category : 'accessing' }
SpPanelPosition >> column [

	^ column
]

{ #category : 'accessing' }
SpPanelPosition >> column: aNumber [

	column := aNumber
]

{ #category : 'accessing' }
SpPanelPosition >> row [

	^ row
]

{ #category : 'accessing' }
SpPanelPosition >> row: aNumber [

	row := aNumber
]

{ #category : 'converting' }
SpPanelPosition >> toPanelPosition [
	| panelPosition |

	panelPosition := self area toPanelPosition.
	self column ifNotNil: [ :c | panelPosition column: c - 1 ].
	self row ifNotNil: [ :r | panelPosition row: r - 1 ].
	^ panelPosition
]

{ #category : 'converting' }
SpPanelPosition >> toPosition [

	^ self
]
