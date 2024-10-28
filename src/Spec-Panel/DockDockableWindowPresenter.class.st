Class {
	#name : 'DockDockableWindowPresenter',
	#superclass : 'SpWindowPresenter',
	#traits : 'DockTDockableWindow',
	#classTraits : 'DockTDockableWindow classTrait',
	#category : 'Spec-Panel-Base',
	#package : 'Spec-Panel',
	#tag : 'Base'
}

{ #category : 'specs' }
DockDockableWindowPresenter class >> adapterName [

	^ #DockableWindowAdapter
]

{ #category : 'testing' }
DockDockableWindowPresenter >> isDockable [

	^ true
]
