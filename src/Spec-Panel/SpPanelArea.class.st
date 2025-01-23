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
