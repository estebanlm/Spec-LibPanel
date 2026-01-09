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

{ #category : 'accessing' }
SpPanelPosition class >> bottomArea [

	^ self newArea: SpPanelArea bottom
]

{ #category : 'accessing' }
SpPanelPosition class >> centerArea [

	^ self newArea: SpPanelArea center
]

{ #category : 'accessing' }
SpPanelPosition class >> endArea [

	^ self newArea: SpPanelArea end
]

{ #category : 'instance creation' }
SpPanelPosition class >> newArea: aDockArea [

	^ self new 
		area: aDockArea;
		yourself
]

{ #category : 'instance creation' }
SpPanelPosition class >> newArea: aDockArea position: aPoint [

	^ self new 
		area: aDockArea;
		column: aPoint x;
		row: aPoint y;
		yourself
]

{ #category : 'accessing' }
SpPanelPosition class >> startArea [

	^ self newArea: SpPanelArea start
]

{ #category : 'accessing' }
SpPanelPosition class >> topArea [

	^ self newArea: SpPanelArea top
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

{ #category : 'instance creation' }
SpPanelPosition >> fromPanelPosition: aPanelPosition [

	self 
		area: (SpPanelArea fromPanelArea: aPanelPosition area);
		column: aPanelPosition column + 1;
		row: aPanelPosition row + 1
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
