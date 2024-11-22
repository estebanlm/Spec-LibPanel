Class {
	#name : 'DockArea',
	#superclass : 'Object',
	#classInstVars : [
		'uniqueInstance'
	],
	#category : 'Spec-Panel-Presenter',
	#package : 'Spec-Panel',
	#tag : 'Presenter'
}

{ #category : 'accessing' }
DockArea class >> bottom [

	^ DockAreaBottom uniqueInstance
]

{ #category : 'accessing' }
DockArea class >> center [

	^ DockAreaCenter uniqueInstance
]

{ #category : 'accessing' }
DockArea class >> end [

	^ DockAreaEnd uniqueInstance
]

{ #category : 'instance creation' }
DockArea class >> new [

	self error: 'Use #uniqueInstance'
]

{ #category : 'accessing' }
DockArea class >> start [

	^ DockAreaStart uniqueInstance
]

{ #category : 'accessing' }
DockArea class >> top [

	^ DockAreaTop uniqueInstance
]

{ #category : 'instance creation' }
DockArea class >> uniqueInstance [

	self = DockArea 
		ifTrue: [ self error: 'This is an abstract class, use one of my children' ].
	^ uniqueInstance ifNil: [ uniqueInstance := self basicNew initialize ]
]

{ #category : 'converting' }
DockArea >> asPanelArea [

	^ self subclassResponsibility
]

{ #category : 'converting' }
DockArea >> toPanelPosition [

	^ self subclassResponsibility
]

{ #category : 'converting' }
DockArea >> toPosition [

	^ DockPanelPosition newArea: self
]
