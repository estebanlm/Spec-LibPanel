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

{ #category : 'visiting' }
DockPanelWindowPresenter >> acceptVisitor: aVisitor [

	aVisitor visitPanelWindowPresenter: self
]

{ #category : 'api' }
DockPanelWindowPresenter >> close [
	"Close current window."

	self withAdapterDo: [ :anAdapter | 
		anAdapter close ]
]

{ #category : 'private' }
DockPanelWindowPresenter >> closeFromKeyboard [
	"a close signal has been triggered. I need to verify I am in a panel that is closable like that."

	"Just panels in the center can be closed with meta+w"
	self dockPosition area = DockArea center ifFalse: [ ^ self ].
	
	self close
]

{ #category : 'api - focus' }
DockPanelWindowPresenter >> defaultKeyboardFocus [

	^ self presenter
]

{ #category : 'accessing' }
DockPanelWindowPresenter >> dockArea [
	
	^ self dockPosition area
]

{ #category : 'initialization' }
DockPanelWindowPresenter >> initialize [

	super initialize.
	modified := false.
	self registerActions
]

{ #category : 'initialization' }
DockPanelWindowPresenter >> initializePrivateAnnouncements [

	self 
		property: #titleHolder 
		whenChangedDo: [ :aString | self withAdapterDo: [ :anAdapter | anAdapter title: aString ] ].
	"panel windows do not have layout"
	"self
		property: #layout 
		whenChangedDo: [ :newLayout | self replaceLayoutWith: newLayout ]"
]

{ #category : 'initialization' }
DockPanelWindowPresenter >> initializeWindow [

	super initializeWindow.
	self presenter initializePanelWindow: self
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

{ #category : 'private' }
DockPanelWindowPresenter >> nearWindowLike [

	^ self
]

{ #category : 'api' }
DockPanelWindowPresenter >> raise [

	self withAdapterDo: [ :anAdapter | anAdapter raise ]
]

{ #category : 'initialization' }
DockPanelWindowPresenter >> registerActions [

	self ensureInternalActions 
		addShortcutWith: [ :action | action
			shortcutKey: $w actionModifier;
			action: [ self closeFromKeyboard ] ]
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
DockPanelWindowPresenter >> whenFocusLostDo: aBlock [

	self announcer
		when: DockPanelWindowFocusLost
		do: aBlock
		for: aBlock receiver
]

{ #category : 'api - events' }
DockPanelWindowPresenter >> whenFocusReceivedDo: aBlock [

	self announcer
		when: DockPanelWindowFocusReceived 
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

{ #category : 'private' }
DockPanelWindowPresenter >> windowClosed [

	isClosed := true
]
