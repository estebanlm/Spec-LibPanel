Class {
	#name : 'SpPanelArea',
	#superclass : 'Object',
	#classInstVars : [
		'uniqueInstance'
	],
	#category : 'Spec-Panel-Presenter',
	#package : 'Spec-Panel',
	#tag : 'Presenter'
}

{ #category : 'accessing' }
SpPanelArea class >> bottom [

	^ SpPanelAreaBottom uniqueInstance
]

{ #category : 'accessing' }
SpPanelArea class >> center [

	^ SpPanelAreaCenter uniqueInstance
]

{ #category : 'accessing' }
SpPanelArea class >> end [

	^ SpPanelAreaEnd uniqueInstance
]

{ #category : 'instance creation' }
SpPanelArea class >> fromPanelArea: aPanelArea [

	aPanelArea = PanelArea PANEL_AREA_END ifTrue: [ ^ self end ].
	aPanelArea = PanelArea PANEL_AREA_TOP ifTrue: [ ^ self top ].
	aPanelArea = PanelArea PANEL_AREA_CENTER ifTrue: [ ^ self center ].
	aPanelArea = PanelArea PANEL_AREA_BOTTOM ifTrue: [ ^ self bottom ].
	aPanelArea = PanelArea PANEL_AREA_START ifTrue: [ ^ self start ].
	
	self error: 'Should not arrive here'
	
]

{ #category : 'instance creation' }
SpPanelArea class >> new [

	self error: 'Use #uniqueInstance'
]

{ #category : 'accessing' }
SpPanelArea class >> start [

	^ SpPanelAreaStart uniqueInstance
]

{ #category : 'accessing' }
SpPanelArea class >> top [

	^ SpPanelAreaTop uniqueInstance
]

{ #category : 'instance creation' }
SpPanelArea class >> uniqueInstance [

	self = SpPanelArea 
		ifTrue: [ self error: 'This is an abstract class, use one of my children' ].
	^ uniqueInstance ifNil: [ uniqueInstance := self basicNew initialize ]
]

{ #category : 'visiting' }
SpPanelArea >> accept: aVisitor [

	self subclassResponsibility
]

{ #category : 'converting' }
SpPanelArea >> asPanelArea [

	^ self subclassResponsibility
]

{ #category : 'converting' }
SpPanelArea >> toPanelPosition [

	^ self subclassResponsibility
]

{ #category : 'converting' }
SpPanelArea >> toPosition [

	^ SpPanelPosition newArea: self
]
