Class {
	#name : 'SpPanelWidgetPresenter',
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
SpPanelWidgetPresenter class >> adapterName [

	^ #PanelWidgetAdapter
]

{ #category : 'visiting' }
SpPanelWidgetPresenter >> acceptVisitor: aVisitor [

	aVisitor visitPanelWindowPresenter: self
]

{ #category : 'api' }
SpPanelWidgetPresenter >> close [
	"Close current window."

	self withAdapterDo: [ :anAdapter | 
		anAdapter close ]
]

{ #category : 'private' }
SpPanelWidgetPresenter >> closeFromKeyboard [
	"a close signal has been triggered. I need to verify I am in a panel that is closable like that."

	"Just panels in the center can be closed with meta+w"
	self panelPosition area = SpPanelArea center ifFalse: [ ^ self ].
	
	self close
]

{ #category : 'api - focus' }
SpPanelWidgetPresenter >> defaultKeyboardFocus [

	^ self presenter
]

{ #category : 'api' }
SpPanelWidgetPresenter >> forceClose [
	"Force close current window (if is dirty, it closes it anyway)."

	self withAdapterDo: [ :anAdapter | 
		anAdapter forceClose ]
]

{ #category : 'initialization' }
SpPanelWidgetPresenter >> initialize [

	super initialize.
	modified := false.
	self registerActions
]

{ #category : 'initialization' }
SpPanelWidgetPresenter >> initializePrivateAnnouncements [

	self 
		property: #titleHolder 
		whenChangedDo: [ :aString | self withAdapterDo: [ :anAdapter | anAdapter title: aString ] ].
	"panel windows do not have layout"
	"self
		property: #layout 
		whenChangedDo: [ :newLayout | self replaceLayoutWith: newLayout ]"
]

{ #category : 'initialization' }
SpPanelWidgetPresenter >> initializeWindow [

	super initializeWindow.
	self presenter initializePanelWindow: self
]

{ #category : 'testing' }
SpPanelWidgetPresenter >> isDirty [

	^ self isModified
]

{ #category : 'testing' }
SpPanelWidgetPresenter >> isModified [

	^ modified
]

{ #category : 'testing' }
SpPanelWidgetPresenter >> isPanelWindow [

	^ true
]

{ #category : 'api' }
SpPanelWidgetPresenter >> markBusy [
	"this setting just has sense if it is visible"

	self withAdapterDo: [ :anAdapter | anAdapter markBusy ]
]

{ #category : 'api' }
SpPanelWidgetPresenter >> maximize [

	self withAdapterDo: [ :anAdapter | anAdapter maximize ]
]

{ #category : 'api' }
SpPanelWidgetPresenter >> modified: aBoolean [

	modified := aBoolean
]

{ #category : 'private' }
SpPanelWidgetPresenter >> nearWindow [

	^ self owner ifNotNil: [ :anOwner | anOwner nearWindow ]
]

{ #category : 'private' }
SpPanelWidgetPresenter >> nearWindowLike [

	^ self
]

{ #category : 'testing' }
SpPanelWidgetPresenter >> needsAttention [
	"this setting just has sense if it is visible"

	self withAdapterDo: [ :anAdapter | ^ anAdapter needsAttention ].
	
	^ false
]

{ #category : 'api' }
SpPanelWidgetPresenter >> needsAttention: aBoolean [
	"this setting just has sense if it is visible"

	self withAdapterDo: [ :anAdapter | anAdapter needsAttention: aBoolean ]
]

{ #category : 'accessing' }
SpPanelWidgetPresenter >> panelArea [
	
	^ self panelPosition area
]

{ #category : 'api' }
SpPanelWidgetPresenter >> panelPosition [

	^ dockPosition
]

{ #category : 'api' }
SpPanelWidgetPresenter >> panelPosition: aDockPosition [

	dockPosition := aDockPosition
]

{ #category : 'api' }
SpPanelWidgetPresenter >> raise [

	self withAdapterDo: [ :anAdapter | anAdapter raise ]
]

{ #category : 'api' }
SpPanelWidgetPresenter >> raiseAndTakeKeyboardFocus [

	self raise.
	self takeKeyboardFocus
]

{ #category : 'initialization' }
SpPanelWidgetPresenter >> registerActions [

	self ensureInternalActions
		addShortcutWith: [ :action | action
			shortcutKey: $w actionModifier;
			action: [ self closeFromKeyboard ] ]
]

{ #category : 'api' }
SpPanelWidgetPresenter >> unmarkBusy [
	"this setting just has sense if it is visible"

	self withAdapterDo: [ :anAdapter | anAdapter unmarkBusy ]
]

{ #category : 'api' }
SpPanelWidgetPresenter >> unmaximize [

	self withAdapterDo: [ :anAdapter | anAdapter unmaximize ]
]

{ #category : 'api - events' }
SpPanelWidgetPresenter >> whenDiscardDo: aBlock [ 

	self announcer 
		when: DockPanelWindowDiscard
		do: aBlock
		for: aBlock receiver
]

{ #category : 'api - events' }
SpPanelWidgetPresenter >> whenDockPositionChangedDo: aBlock [

	self property: #panelPosition whenChangedDo: aBlock
]

{ #category : 'api - events' }
SpPanelWidgetPresenter >> whenFocusLostDo: aBlock [

	self announcer
		when: DockPanelWindowFocusLost
		do: aBlock
		for: aBlock receiver
]

{ #category : 'api - events' }
SpPanelWidgetPresenter >> whenFocusReceivedDo: aBlock [

	self announcer
		when: DockPanelWindowFocusReceived 
		do: aBlock
		for: aBlock receiver
]

{ #category : 'api - events' }
SpPanelWidgetPresenter >> whenModifiedChangedDo: aBlock [

	self property: #modified whenChangedDo: aBlock
]

{ #category : 'api - events' }
SpPanelWidgetPresenter >> whenPlacedDo: aBlock [

	self announcer
		when: DockPanelWidgetPlaced
		do: aBlock
		for: aBlock receiver
]

{ #category : 'api - events' }
SpPanelWidgetPresenter >> whenPresentedDo: aBlock [

	self announcer 
		when: DockPanelWindowPresented 
		do: aBlock 
		for: aBlock receiver
]

{ #category : 'api - events' }
SpPanelWidgetPresenter >> whenSaveDo: aBlock [
	"Announces when the window is dirty (modified) and user wants to close it by pressing the 
	 close button (or with <meta+w>. 
	 DockPanelWindowSave ann needs to be setted to success (using beSuccess) for the window to
	 close effectible"

	self announcer 
		when: DockPanelWindowSave
		do: aBlock
		for: aBlock receiver
]

{ #category : 'api - events' }
SpPanelWidgetPresenter >> whenWindowIconChangedDo: aBlock [

	self property: #windowIcon whenChangedDo: aBlock
]

{ #category : 'private' }
SpPanelWidgetPresenter >> window [
	"Answer window containing this composition (windows can be nested, so we 
	 need to answer the closest one)."
	
	^ self nearWindow
]

{ #category : 'private' }
SpPanelWidgetPresenter >> windowClosed [

	isClosed := true
]
