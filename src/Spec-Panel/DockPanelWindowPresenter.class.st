Class {
	#name : 'DockPanelWindowPresenter',
	#superclass : 'SpWindowPresenter',
	#traits : 'DockTPanelWindow',
	#classTraits : 'DockTPanelWindow classTrait',
	#instVars : [
		'#modified => ObservableSlot'
	],
	#category : 'Spec-Panel-Presenter',
	#package : 'Spec-Panel',
	#tag : 'Presenter'
}

{ #category : 'specs' }
DockPanelWindowPresenter class >> adapterName [

	^ #PanelWindowAdapter
]

{ #category : 'accessing' }
DockPanelWindowPresenter >> dockArea [
	
	^ self dockPosition area
]

{ #category : 'testing' }
DockPanelWindowPresenter >> initialize [

	super initialize.
	modified := false
]

{ #category : 'testing' }
DockPanelWindowPresenter >> isModified [

	^ modified
]

{ #category : 'testing' }
DockPanelWindowPresenter >> isPanelWindow [

	^ true
]

{ #category : 'api' }
DockPanelWindowPresenter >> maximize [

	self withAdapterDo: [ :anAdapter | anAdapter maximize ]
]

{ #category : 'api' }
DockPanelWindowPresenter >> modified: aBoolean [

	modified := aBoolean
]

{ #category : 'private' }
DockPanelWindowPresenter >> nearWindow [

	^ self owner ifNotNil: [ :anOwner | anOwner nearWindow ]
]

{ #category : 'api' }
DockPanelWindowPresenter >> raise [

	self withAdapterDo: [ :anAdapter | anAdapter raise ]
]

{ #category : 'api' }
DockPanelWindowPresenter >> unmaximize [

	self withAdapterDo: [ :anAdapter | anAdapter unmaximize ]
]

{ #category : 'api - events' }
DockPanelWindowPresenter >> whenDiscardDo: aBlock [ 

	self announcer 
		when: DockPanelWindowDiscard
		do: aBlock
		for: aBlock receiver
]

{ #category : 'api - events' }
DockPanelWindowPresenter >> whenModifiedChangedDo: aBlock [

	self property: #modified whenChangedDo: aBlock
]

{ #category : 'api - events' }
DockPanelWindowPresenter >> whenPresentedDo: aBlock [

	self announcer 
		when: DockPanelWindowPresented 
		do: aBlock 
		for: aBlock receiver
]

{ #category : 'api - events' }
DockPanelWindowPresenter >> whenSaveDo: aBlock [ 
	"Announces when the window is dirty (modified) and user wants to close it by pressing the 
	 close button (or with <meta+w>. 
	 DockPanelWindowSave ann needs to be setted to success (using beSuccess) for the window to
	 close effectible"

	self announcer 
		when: DockPanelWindowSave
		do: aBlock
		for: aBlock receiver
]

{ #category : 'private' }
DockPanelWindowPresenter >> window [
	"Answer window containing this composition (windows can be nested, so we 
	 need to answer the closest one)."
	
	^ self nearWindow
]
