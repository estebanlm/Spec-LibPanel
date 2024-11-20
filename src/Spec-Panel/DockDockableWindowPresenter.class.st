Class {
	#name : 'DockDockableWindowPresenter',
	#superclass : 'SpWindowPresenter',
	#traits : 'DockTDockableWindow',
	#classTraits : 'DockTDockableWindow classTrait',
	#instVars : [
		'#modified => ObservableSlot'
	],
	#category : 'Spec-Panel-Base',
	#package : 'Spec-Panel',
	#tag : 'Base'
}

{ #category : 'specs' }
DockDockableWindowPresenter class >> adapterName [

	^ #DockableWindowAdapter
]

{ #category : 'accessing' }
DockDockableWindowPresenter >> dockArea [
	
	^ self dockPosition area
]

{ #category : 'testing' }
DockDockableWindowPresenter >> initialize [

	super initialize.
	modified := false
]

{ #category : 'testing' }
DockDockableWindowPresenter >> isDockableWindow [

	^ true
]

{ #category : 'testing' }
DockDockableWindowPresenter >> isModified [

	^ modified
]

{ #category : 'api' }
DockDockableWindowPresenter >> modified: aBoolean [

	modified := aBoolean
]

{ #category : 'private' }
DockDockableWindowPresenter >> nearWindow [

	^ self owner ifNotNil: [ :anOwner | anOwner nearWindow ]
]

{ #category : 'api - events' }
DockDockableWindowPresenter >> whenModifiedChangedDo: aBlock [

	self property: #modified whenChangedDo: aBlock
]

{ #category : 'api - events' }
DockDockableWindowPresenter >> whenPresentedDo: aBlock [

	self announcer 
		when: DockDockableWindowPresented 
		do: aBlock 
		for: aBlock receiver
]

{ #category : 'private' }
DockDockableWindowPresenter >> window [
	"Answer window containing this composition (windows can be nested, so we 
	 need to answer the closest one)."
	
	^ self nearWindow
]
