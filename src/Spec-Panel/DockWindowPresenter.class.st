Class {
	#name : 'DockWindowPresenter',
	#superclass : 'SpAbstractWidgetPresenter',
	#instVars : [
		'#title => ObservableSlot',
		'#isClosed => ObservableSlot',
		'#presenters',
		'#initialExtent'
	],
	#category : 'Spec-Panel-Presenter',
	#package : 'Spec-Panel',
	#tag : 'Presenter'
}

{ #category : 'specs' }
DockWindowPresenter class >> adapterName [

	^ #DockWindowAdapter
]

{ #category : 'accessing' }
DockWindowPresenter class >> defaultTitle [
	
	^ 'Untitled Dock'
]

{ #category : 'api' }
DockWindowPresenter >> addPresenter: aPresenter [

	self 
		addPresenter: aPresenter 
		at: DockArea center
]

{ #category : 'api' }
DockWindowPresenter >> addPresenter: aPresenter at: aPositionOrArea [

	self addWindow: (aPresenter asDockableWindow 
		dockPosition: aPositionOrArea toPosition;
		yourself)
]

{ #category : 'private' }
DockWindowPresenter >> addWindow: aDockableWindow [
	
	aDockableWindow owner: self.
	aDockableWindow whenClosedDo: [
		self basicRemovePresenter: aDockableWindow ].
	self basicAddPresenter: aDockableWindow.
	self withAdapterDo: [ :anAdapter |
		anAdapter dockWindow: aDockableWindow ]
]

{ #category : 'showing' }
DockWindowPresenter >> asWindow [

	^ self
]

{ #category : 'private' }
DockWindowPresenter >> basicAddPresenter: aDockableWindow [
	
	presenters := self presenters copyWith: aDockableWindow
]

{ #category : 'private' }
DockWindowPresenter >> basicRemovePresenter: aDockableWindow [
	
	presenters := self presenters copyWithout: aDockableWindow
]

{ #category : 'api' }
DockWindowPresenter >> bottomHeight: aNumber [

	self withAdapterPerformOrDefer: [ :anAdapter | anAdapter bottomHeight: aNumber ]
]

{ #category : 'api' }
DockWindowPresenter >> bottomVisible: aBoolean [

	self withAdapterPerformOrDefer: [ :anAdapter | anAdapter bottomVisible: aBoolean ]
]

{ #category : 'api' }
DockWindowPresenter >> close [
	"Close current window."

	"Only manage closing if the presenter is really open"
	self isOpen ifFalse: [ ^ self ].
	self withAdapterDo: [ :anAdapter | 
		anAdapter close ]
]

{ #category : 'private' }
DockWindowPresenter >> defaultInitialExtent [
	
	^ 800@600
]

{ #category : 'api' }
DockWindowPresenter >> endVisible: aBoolean [

	self withAdapterPerformOrDefer: [ :anAdapter | anAdapter endVisible: aBoolean ]
]

{ #category : 'api' }
DockWindowPresenter >> endWidth: aNumber [

	self withAdapterPerformOrDefer: [ :anAdapter | anAdapter endWidth: aNumber ]
]

{ #category : 'api' }
DockWindowPresenter >> initialExtent [
	"Answer initial extent of the window. By default, it answer what is defined 
	 in `#defaultInitialExtent`"

	^ initialExtent ifNil: [ self defaultInitialExtent ]
]

{ #category : 'api' }
DockWindowPresenter >> initialExtent: aPoint [

	initialExtent := aPoint
]

{ #category : 'initialization' }
DockWindowPresenter >> initialize [

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
DockWindowPresenter >> initializeWindow: aWindowPresenter [
	"override this to initialize the workspace window"
	
	super initializeWindow: aWindowPresenter
]

{ #category : 'initialization' }
DockWindowPresenter >> initializeWorkspace [
	"override this to initialize the workspace"
]

{ #category : 'testing' }
DockWindowPresenter >> isAreaVisible: aDockArea [

	self withAdapterDo: [ :anAdapter | 
		^ anAdapter isAreaVisible: aDockArea ].
	
	^ false
]

{ #category : 'testing' }
DockWindowPresenter >> isClosed [
	"Answer if window has is closed"

	^ isClosed
]

{ #category : 'testing' }
DockWindowPresenter >> isOpen [
	"Answer if window is open."
	
	^ self isClosed not
]

{ #category : 'testing' }
DockWindowPresenter >> isTopWindow [

	self withAdapterDo: [ :anAdapter | ^ anAdapter isTopWindow ].
	
	^ false
]

{ #category : 'initialization' }
DockWindowPresenter >> maybeInitializeWorkspace [
	"Initialization may happen when setting application by "

	"not owner/application yet"
	application ifNil: [ ^ self ].
	"if presenters is not nil this has been initialized"
	presenters ifNotNil: [ ^ self ].
	"ok, now I can initialize it"
	self initializeWorkspace
]

{ #category : 'private' }
DockWindowPresenter >> nearWindow [

	^ self
]

{ #category : 'private' }
DockWindowPresenter >> nearWindowLike [

	^ self
]

{ #category : 'showing' }
DockWindowPresenter >> open [

	self initializeWindow: self.
	self build.
	self application registerWindow: self.
	self withAdapterDo: [ :anAdapter | 
		anAdapter openWithDeferredAction: [ 
			self allPresenters do: [ :each | each announceDisplayed ] ] ]
]

{ #category : 'private - traversing' }
DockWindowPresenter >> presenters [

	^ presenters ifNil: [ #() ]
]

{ #category : 'private - traversing' }
DockWindowPresenter >> presentersDo: aBlock [

	self presenters do: aBlock
]

{ #category : 'initialization' }
DockWindowPresenter >> registerActions [

	self ensureInternalActions 
		addShortcutWith: [ :action | action 
			shortcutKey: $w actionModifier;
			action: [ self close ] ]
]

{ #category : 'api' }
DockWindowPresenter >> startVisible: aBoolean [

	self withAdapterPerformOrDefer: [ :anAdapter | anAdapter startVisible: aBoolean ]
]

{ #category : 'api' }
DockWindowPresenter >> startWidth: aNumber [

	self withAdapterPerformOrDefer: [ :anAdapter | anAdapter startWidth: aNumber ]
]

{ #category : 'api' }
DockWindowPresenter >> title [

	^ title
]

{ #category : 'api' }
DockWindowPresenter >> title: aString [

	title := aString
]

{ #category : 'api' }
DockWindowPresenter >> topHeight: aNumber [

	self withAdapterPerformOrDefer: [ :anAdapter | anAdapter topHeight: aNumber ]
]

{ #category : 'api' }
DockWindowPresenter >> topVisible: aBoolean [

	self withAdapterPerformOrDefer: [ :anAdapter | anAdapter topVisible: aBoolean ]
]

{ #category : 'api - events' }
DockWindowPresenter >> whenClosedDo: aBlock [
	"Inform when window is closed.
	 `aBlock` receives zero arguments."
	
	self 
		property: #isClosed 
		whenChangedDo: [ :value | value ifTrue: aBlock ]
]

{ #category : 'api - events' }
DockWindowPresenter >> whenOpenedDo: aBlock [
	"Inform when window is opened. 
	 `aBlock` receives zero arguments."

	self 
		property: #isClosed 
		whenChangedDo: [ :value | value ifFalse: aBlock ]
]

{ #category : 'api - events' }
DockWindowPresenter >> whenResizingDo: aBlock [
	"Inform when window is resizing. 
	 `aBlock` receives one optional argument (an instance of the announcement `SpWindowResizing`)"

	self announcer 
		when: SpWindowResizing 
		do: aBlock 
		for: aBlock receiver
]

{ #category : 'api - events' }
DockWindowPresenter >> whenTitleChangedDo: aBlock [

	self property: #title whenChangedDo: aBlock
]

{ #category : 'api - events' }
DockWindowPresenter >> whenWillCloseDo: aBlock [
	"Inform when window will close, allowing process before the close happen. 
	 Note that user cannot cancel the close operation using this event. 
	 `aBlock` receives one optional argument (an instance of the announcement `SpWindowWillClose`)."

	self announcer
		when: SpWindowWillClose
		do: aBlock
		for: aBlock receiver
]

{ #category : 'accessing' }
DockWindowPresenter >> window [
	"this is for compatibility with SpWindowPresenter... not convinced"

	self withAdapterDo: [ :anAdapter | ^ anAdapter widget ].
	
	^ nil
]

{ #category : 'private' }
DockWindowPresenter >> windowClosed [
	
	isClosed := true.
	self application windowClosed: self
]

{ #category : 'accessing' }
DockWindowPresenter >> windowIcon: anIcon [
	"For background compatibility"
]

{ #category : 'updating' }
DockWindowPresenter >> windowIsClosing [
	
	self flag: #TODO.
	"inform the presenters they will be closed"
]

{ #category : 'updating' }
DockWindowPresenter >> windowIsOpened [

	isClosed := false
]
