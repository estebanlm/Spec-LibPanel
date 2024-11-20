Class {
	#name : 'DockDockWindowPresenter',
	#superclass : 'SpAbstractWidgetPresenter',
	#instVars : [
		'#title => ObservableSlot',
		'#isClosed => ObservableSlot',
		'#presenters',
		'#initialExtent'
	],
	#category : 'Spec-Panel-Base',
	#package : 'Spec-Panel',
	#tag : 'Base'
}

{ #category : 'specs' }
DockDockWindowPresenter class >> adapterName [

	^ #DockWindowAdapter
]

{ #category : 'accessing' }
DockDockWindowPresenter class >> defaultTitle [
	
	^ 'Untitled Dock'
]

{ #category : 'api' }
DockDockWindowPresenter >> addPresenter: aPresenter [

	self 
		addPresenter: aPresenter 
		at: DockArea center
]

{ #category : 'api' }
DockDockWindowPresenter >> addPresenter: aPresenter at: aPositionOrArea [

	self addWindow: (aPresenter asDockableWindow 
		dockPosition: aPositionOrArea toPosition;
		yourself)
]

{ #category : 'private' }
DockDockWindowPresenter >> addWindow: aDockableWindow [
	
	aDockableWindow owner: self.
	presenters := self presenters copyWith: aDockableWindow.
	self withAdapterDo: [ :anAdapter | anAdapter dockWindow: aDockableWindow ]
]

{ #category : 'showing' }
DockDockWindowPresenter >> asWindow [

	^ self
]

{ #category : 'api' }
DockDockWindowPresenter >> bottomHeight: aNumber [

	self withAdapterPerformOrDefer: [ :anAdapter | anAdapter bottomHeight: aNumber ]
]

{ #category : 'api' }
DockDockWindowPresenter >> bottomVisible: aBoolean [

	self withAdapterPerformOrDefer: [ :anAdapter | anAdapter bottomVisible: aBoolean ]
]

{ #category : 'api' }
DockDockWindowPresenter >> close [
	"Close current window."

	"Only manage closing if the presenter is really open"
	self isOpen ifFalse: [ ^ self ].
	self withAdapterDo: [ :anAdapter | 
		anAdapter close ]
]

{ #category : 'private' }
DockDockWindowPresenter >> defaultInitialExtent [
	
	^ 800@600
]

{ #category : 'api' }
DockDockWindowPresenter >> endVisible: aBoolean [

	self withAdapterPerformOrDefer: [ :anAdapter | anAdapter endVisible: aBoolean ]
]

{ #category : 'api' }
DockDockWindowPresenter >> endWidth: aNumber [

	self withAdapterPerformOrDefer: [ :anAdapter | anAdapter endWidth: aNumber ]
]

{ #category : 'api' }
DockDockWindowPresenter >> initialExtent [
	"Answer initial extent of the window. By default, it answer what is defined 
	 in `#defaultInitialExtent`"

	^ initialExtent ifNil: [ self defaultInitialExtent ]
]

{ #category : 'api' }
DockDockWindowPresenter >> initialExtent: aPoint [

	initialExtent := aPoint
]

{ #category : 'initialization' }
DockDockWindowPresenter >> initialize [

	super initialize.

	titleHolder := self class defaultTitle.
	isClosed := true.
	"resizable := true.
	centered := false.
	decorations := true."

	self whenTitleChangedDo: [ :aString |
		self withAdapterDo: [ :anAdapter | anAdapter title: aString ] ].
	
	self registerActions.
	
	self initializeWorkspace
]

{ #category : 'initialization' }
DockDockWindowPresenter >> initializeWindow: aWindowPresenter [
	"override this to initialize the workspace window"
	
	super initializeWindow: aWindowPresenter
]

{ #category : 'initialization' }
DockDockWindowPresenter >> initializeWorkspace [
	"override this to initialize the workspace"
]

{ #category : 'testing' }
DockDockWindowPresenter >> isAreaVisible: aDockArea [

	self withAdapterDo: [ :anAdapter | 
		^ anAdapter isAreaVisible: aDockArea ].
	
	^ false
]

{ #category : 'testing' }
DockDockWindowPresenter >> isClosed [
	"Answer if window has is closed"

	^ isClosed
]

{ #category : 'testing' }
DockDockWindowPresenter >> isOpen [
	"Answer if window is open."
	
	^ self isClosed not
]

{ #category : 'testing' }
DockDockWindowPresenter >> isTopWindow [

	self withAdapterDo: [ :anAdapter | ^ anAdapter isTopWindow ].
	
	^ false
]

{ #category : 'initialization' }
DockDockWindowPresenter >> maybeInitializeWorkspace [
	"Initialization may happen when setting application by "

	"not owner/application yet"
	application ifNil: [ ^ self ].
	"if presenters is not nil this has been initialized"
	presenters ifNotNil: [ ^ self ].
	"ok, now I can initialize it"
	self initializeWorkspace
]

{ #category : 'private' }
DockDockWindowPresenter >> nearWindow [

	^ self
]

{ #category : 'showing' }
DockDockWindowPresenter >> open [

	self initializeWindow: self.
	self build.
	self application registerWindow: self.
	self withAdapterDo: [ :anAdapter | 
		anAdapter openWithDeferredAction: [ 
			self allPresenters do: [ :each | each announceDisplayed ] ] ]
]

{ #category : 'private - traversing' }
DockDockWindowPresenter >> presenters [

	^ presenters ifNil: [ #() ]
]

{ #category : 'private - traversing' }
DockDockWindowPresenter >> presentersDo: aBlock [

	self presenters do: aBlock
]

{ #category : 'initialization' }
DockDockWindowPresenter >> registerActions [

	self ensureInternalActions 
		addShortcutWith: [ :action | action 
			shortcutKey: $w actionModifier;
			action: [ self close ] ]
]

{ #category : 'api' }
DockDockWindowPresenter >> startVisible: aBoolean [

	self withAdapterPerformOrDefer: [ :anAdapter | anAdapter startVisible: aBoolean ]
]

{ #category : 'api' }
DockDockWindowPresenter >> startWidth: aNumber [

	self withAdapterPerformOrDefer: [ :anAdapter | anAdapter startWidth: aNumber ]
]

{ #category : 'api' }
DockDockWindowPresenter >> title [

	^ title
]

{ #category : 'api' }
DockDockWindowPresenter >> title: aString [

	title := aString
]

{ #category : 'api' }
DockDockWindowPresenter >> topHeight: aNumber [

	self withAdapterPerformOrDefer: [ :anAdapter | anAdapter topHeight: aNumber ]
]

{ #category : 'api' }
DockDockWindowPresenter >> topVisible: aBoolean [

	self withAdapterPerformOrDefer: [ :anAdapter | anAdapter topVisible: aBoolean ]
]

{ #category : 'api - events' }
DockDockWindowPresenter >> whenClosedDo: aBlock [
	"Inform when window is closed.
	 `aBlock` receives zero arguments."
	
	self 
		property: #isClosed 
		whenChangedDo: [ :value | value ifTrue: aBlock ]
]

{ #category : 'api - events' }
DockDockWindowPresenter >> whenResizingDo: aBlock [
	"Inform when window is resizing. 
	 `aBlock` receives one optional argument (an instance of the announcement `SpWindowResizing`)"

	self announcer 
		when: SpWindowResizing 
		do: aBlock 
		for: aBlock receiver
]

{ #category : 'api - events' }
DockDockWindowPresenter >> whenTitleChangedDo: aBlock [

	self property: #title whenChangedDo: aBlock
]

{ #category : 'api - events' }
DockDockWindowPresenter >> whenWillCloseDo: aBlock [
	"Inform when window will close, allowing process before the close happen. 
	 Note that user cannot cancel the close operation using this event. 
	 `aBlock` receives one optional argument (an instance of the announcement `SpWindowWillClose`)."

	self announcer
		when: SpWindowWillClose
		do: aBlock
		for: aBlock receiver
]

{ #category : 'accessing' }
DockDockWindowPresenter >> window [
	"this is for compatibility with SpWindowPresenter... not convinced"

	self withAdapterDo: [ :anAdapter | ^ anAdapter widget ].
	
	^ nil
]

{ #category : 'private' }
DockDockWindowPresenter >> windowClosed [
	
	isClosed := true.
	self application windowClosed: self
]

{ #category : 'updating' }
DockDockWindowPresenter >> windowIsClosing [
	
	self flag: #TODO.
	"inform the presenters they will be closed"
]

{ #category : 'updating' }
DockDockWindowPresenter >> windowIsOpened [

	isClosed := false
]
