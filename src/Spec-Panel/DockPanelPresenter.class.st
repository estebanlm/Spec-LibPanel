Class {
	#name : 'DockPanelPresenter',
	#superclass : 'SpWindowPresenter',
	#instVars : [
		'#modified => ObservableSlot',
		'#dockPosition => ObservableSlot'
	],
	#category : 'Spec-Panel-Presenter',
	#package : 'Spec-Panel',
	#tag : 'Presenter'
}

{ #category : 'specs' }
DockPanelPresenter class >> adapterName [

	^ #DockPanelAdapter
]

{ #category : 'visiting' }
DockPanelPresenter >> acceptVisitor: aVisitor [

	aVisitor visitPanelWindowPresenter: self
]

{ #category : 'api' }
DockPanelPresenter >> close [
	"Close current window."

	self withAdapterDo: [ :anAdapter | 
		anAdapter close ]
]

{ #category : 'private' }
DockPanelPresenter >> closeFromKeyboard [
	"a close signal has been triggered. I need to verify I am in a panel that is closable like that."

	"Just panels in the center can be closed with meta+w"
	self dockPosition area = DockArea center ifFalse: [ ^ self ].
	
	self close
]

{ #category : 'api - focus' }
DockPanelPresenter >> defaultKeyboardFocus [

	^ self presenter
]

{ #category : 'accessing' }
DockPanelPresenter >> dockArea [
	
	^ self dockPosition area
]

{ #category : 'api' }
DockPanelPresenter >> dockPosition [

	^ dockPosition
]

{ #category : 'api' }
DockPanelPresenter >> dockPosition: aDockPosition [

	dockPosition := aDockPosition
]

{ #category : 'initialization' }
DockPanelPresenter >> initialize [

	super initialize.
	modified := false.
	self registerActions
]

{ #category : 'initialization' }
DockPanelPresenter >> initializePrivateAnnouncements [

	self 
		property: #titleHolder 
		whenChangedDo: [ :aString | self withAdapterDo: [ :anAdapter | anAdapter title: aString ] ].
	"panel windows do not have layout"
	"self
		property: #layout 
		whenChangedDo: [ :newLayout | self replaceLayoutWith: newLayout ]"
]

{ #category : 'initialization' }
DockPanelPresenter >> initializeWindow [

	super initializeWindow.
	self presenter initializePanelWindow: self
]

{ #category : 'testing' }
DockPanelPresenter >> isModified [

	^ modified
]

{ #category : 'testing' }
DockPanelPresenter >> isPanelWindow [

	^ true
]

{ #category : 'api' }
DockPanelPresenter >> maximize [

	self withAdapterDo: [ :anAdapter | anAdapter maximize ]
]

{ #category : 'api' }
DockPanelPresenter >> modified: aBoolean [

	modified := aBoolean
]

{ #category : 'private' }
DockPanelPresenter >> nearWindow [

	^ self owner ifNotNil: [ :anOwner | anOwner nearWindow ]
]

{ #category : 'private' }
DockPanelPresenter >> nearWindowLike [

	^ self
]

{ #category : 'api' }
DockPanelPresenter >> raise [

	self withAdapterDo: [ :anAdapter | anAdapter raise ]
]

{ #category : 'initialization' }
DockPanelPresenter >> registerActions [

	self ensureInternalActions 
		addShortcutWith: [ :action | action
			shortcutKey: $w actionModifier;
			action: [ self closeFromKeyboard ] ]
]

{ #category : 'api' }
DockPanelPresenter >> unmaximize [

	self withAdapterDo: [ :anAdapter | anAdapter unmaximize ]
]

{ #category : 'api - events' }
DockPanelPresenter >> whenDiscardDo: aBlock [ 

	self announcer 
		when: DockPanelWindowDiscard
		do: aBlock
		for: aBlock receiver
]

{ #category : 'api - events' }
DockPanelPresenter >> whenDockPositionChangedDo: aBlock [

	self property: #dockPosition whenChangedDo: aBlock
]

{ #category : 'api - events' }
DockPanelPresenter >> whenFocusLostDo: aBlock [

	self announcer
		when: DockPanelWindowFocusLost
		do: aBlock
		for: aBlock receiver
]

{ #category : 'api - events' }
DockPanelPresenter >> whenFocusReceivedDo: aBlock [

	self announcer
		when: DockPanelWindowFocusReceived 
		do: aBlock
		for: aBlock receiver
]

{ #category : 'api - events' }
DockPanelPresenter >> whenModifiedChangedDo: aBlock [

	self property: #modified whenChangedDo: aBlock
]

{ #category : 'api - events' }
DockPanelPresenter >> whenPresentedDo: aBlock [

	self announcer 
		when: DockPanelWindowPresented 
		do: aBlock 
		for: aBlock receiver
]

{ #category : 'api - events' }
DockPanelPresenter >> whenSaveDo: aBlock [
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
DockPanelPresenter >> window [
	"Answer window containing this composition (windows can be nested, so we 
	 need to answer the closest one)."
	
	^ self nearWindow
]

{ #category : 'private' }
DockPanelPresenter >> windowClosed [

	isClosed := true
]
