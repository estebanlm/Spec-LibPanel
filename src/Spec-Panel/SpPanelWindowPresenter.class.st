Class {
	#name : 'SpPanelWindowPresenter',
	#superclass : 'SpAbstractWidgetPresenter',
	#instVars : [
		'#title => ObservableSlot',
		'#isClosed => ObservableSlot',
		'#presenters',
		'#initialExtent',
		'#overlayLayout',
		'#statusbar'
	],
	#category : 'Spec-Panel-Presenter',
	#package : 'Spec-Panel',
	#tag : 'Presenter'
}

{ #category : 'specs' }
SpPanelWindowPresenter class >> adapterName [

	^ #PanelWindowAdapter
]

{ #category : 'accessing' }
SpPanelWindowPresenter class >> defaultTitle [
	
	^ 'Untitled Dock'
]

{ #category : 'api' }
SpPanelWindowPresenter >> addOverlay: aPresenter [

	self addOverlay: aPresenter withConstraints: [ :c |]
]

{ #category : 'api' }
SpPanelWindowPresenter >> addOverlay: aPresenter withConstraints: aBlock [

	overlayLayout addOverlay: aPresenter withConstraints: aBlock.
	self withAdapterDo: [ :anAdapter |
		anAdapter 
			addOverlay: aPresenter 
			constraints: (overlayLayout constraintsFor: aPresenter) ]
]

{ #category : 'api' }
SpPanelWindowPresenter >> addPresenter: aPresenter [

	self 
		addPresenter: aPresenter 
		at: SpPanelArea center
]

{ #category : 'api' }
SpPanelWindowPresenter >> addPresenter: aPresenter at: aPositionOrArea [

	self addWindow: (aPresenter asDockableWindow 
		panelPosition: aPositionOrArea toPosition;
		yourself)
]

{ #category : 'api' }
SpPanelWindowPresenter >> addToast: aToast [

	self withAdapterDo: [ :anAdapter | anAdapter addToast: aToast ]
]

{ #category : 'private' }
SpPanelWindowPresenter >> addWindow: aPanelWidget [
	
	aPanelWidget owner: self.
	aPanelWidget whenClosedDo: [
		"this is like this because we can change the window of the PanelWidget  
		 when dragging it to another window, hence, we cannot do just 'self basicRemovePresenter' :)"
		aPanelWidget window basicRemovePresenter: aPanelWidget ].
	self basicAddPresenter: aPanelWidget.
	self withAdapterDo: [ :anAdapter |
		anAdapter placeWindow: aPanelWidget ]
]

{ #category : 'showing' }
SpPanelWindowPresenter >> asWindow [

	^ self
]

{ #category : 'private' }
SpPanelWindowPresenter >> basicAddPresenter: aDockableWindow [
	
	presenters := self presenters copyWith: aDockableWindow
]

{ #category : 'private' }
SpPanelWindowPresenter >> basicRemovePresenter: aDockableWindow [
	
	presenters := self presenters copyWithout: aDockableWindow
]

{ #category : 'api' }
SpPanelWindowPresenter >> bottomHeight [

	self withAdapterDo: [ :anAdapter | ^ anAdapter bottomHeight ].
	^ nil
]

{ #category : 'api' }
SpPanelWindowPresenter >> bottomHeight: aNumber [

	self withAdapterPerformOrDefer: [ :anAdapter | anAdapter bottomHeight: aNumber ]
]

{ #category : 'api' }
SpPanelWindowPresenter >> bottomVisible: aBoolean [

	self withAdapterPerformOrDefer: [ :anAdapter | anAdapter bottomVisible: aBoolean ]
]

{ #category : 'api' }
SpPanelWindowPresenter >> close [
	"Close current window."

	"Only manage closing if the presenter is really open"
	self isOpen ifFalse: [ ^ self ].
	self withAdapterDo: [ :anAdapter | 
		anAdapter close ]
]

{ #category : 'private' }
SpPanelWindowPresenter >> defaultInitialExtent [
	
	^ 800@600
]

{ #category : 'api' }
SpPanelWindowPresenter >> endVisible: aBoolean [

	self withAdapterPerformOrDefer: [ :anAdapter | anAdapter endVisible: aBoolean ]
]

{ #category : 'api' }
SpPanelWindowPresenter >> endWidth [


	self withAdapterDo: [ :anAdapter | ^ anAdapter endWidth ].
	^ nil
	
]

{ #category : 'api' }
SpPanelWindowPresenter >> endWidth: aNumber [

	self withAdapterPerformOrDefer: [ :anAdapter | anAdapter endWidth: aNumber ]
]

{ #category : 'api' }
SpPanelWindowPresenter >> initialExtent [
	"Answer initial extent of the window. By default, it answer what is defined 
	 in `#defaultInitialExtent`"

	^ initialExtent ifNil: [ self defaultInitialExtent ]
]

{ #category : 'api' }
SpPanelWindowPresenter >> initialExtent: aPoint [

	initialExtent := aPoint
]

{ #category : 'initialization' }
SpPanelWindowPresenter >> initialize [

	super initialize.

	titleHolder := self class defaultTitle.
	isClosed := true.
	"resizable := true.
	centered := false.
	decorations := true."
	"this is just used to keep and display overlays. 
	 Child api cannot be used as it does not has sense"
	overlayLayout := SpOverlayLayout new.

	self whenTitleChangedDo: [ :aString |
		self withAdapterDo: [ :anAdapter | anAdapter title: aString ] ].
	
	self registerActions.
	
	self initializeWorkspace.
	
	self whenBuiltDo: [
		self statusbar build ]
]

{ #category : 'initialization' }
SpPanelWindowPresenter >> initializeWindow: aWindowPresenter [
	"override this to initialize the workspace window"
	
	"super initializeWindow: aWindowPresenter"
]

{ #category : 'initialization' }
SpPanelWindowPresenter >> initializeWorkspace [
	"override this to initialize the workspace"
]

{ #category : 'testing' }
SpPanelWindowPresenter >> isAreaVisible: aDockArea [

	self withAdapterDo: [ :anAdapter | 
		^ anAdapter isAreaVisible: aDockArea ].
	
	^ false
]

{ #category : 'testing' }
SpPanelWindowPresenter >> isClosed [
	"Answer if window has is closed"

	^ isClosed
]

{ #category : 'testing' }
SpPanelWindowPresenter >> isMaximized [
	"Answer if window is maximized"

	self withAdapterDo: [ :anAdapter | ^ anAdapter isMaximized ].
	^ false
]

{ #category : 'testing' }
SpPanelWindowPresenter >> isMinimized [
	"Answer if window is minimized"

	self withAdapterDo: [ :anAdapter | ^ anAdapter isMinimized ].
	^ false
]

{ #category : 'testing' }
SpPanelWindowPresenter >> isOpen [
	"Answer if window is open."
	
	^ self isClosed not
]

{ #category : 'testing' }
SpPanelWindowPresenter >> isResizable [
	
	self flag: #TODO. "I need to extend this to adapt to the same as a SpWindowPresenter"

	^ true
]

{ #category : 'testing' }
SpPanelWindowPresenter >> isTopWindow [

	self withAdapterDo: [ :anAdapter | ^ anAdapter isTopWindow ].
	
	^ false
]

{ #category : 'api' }
SpPanelWindowPresenter >> lastPresenterFocused [

	self withAdapterDo: [ :anAdapter | 
		^ anAdapter lastPresenterFocused ].
		
	^ nil
]

{ #category : 'initialization' }
SpPanelWindowPresenter >> maybeInitializeWorkspace [
	"Initialization may happen when setting application by "

	"not owner/application yet"
	application ifNil: [ ^ self ].
	"if presenters is not nil this has been initialized"
	presenters ifNotNil: [ ^ self ].
	"ok, now I can initialize it"
	self initializeWorkspace
]

{ #category : 'private' }
SpPanelWindowPresenter >> nearWindow [

	^ self
]

{ #category : 'private' }
SpPanelWindowPresenter >> nearWindowLike [

	^ self
]

{ #category : 'showing' }
SpPanelWindowPresenter >> open [

	self initializeWindow: self.
	self build.
	self application registerWindow: self.
	self withAdapterDo: [ :anAdapter | 
		anAdapter openWithDeferredAction: [ 
			self allPresenters do: [ :each | each announceDisplayed ] ] ]
]

{ #category : 'private' }
SpPanelWindowPresenter >> overlayLayout [ 

	^ overlayLayout
]

{ #category : 'accessing' }
SpPanelWindowPresenter >> preferredExtent: aSize [

	(self isMaximized 
		or: [ self isMinimized ])
		ifTrue: [ ^ self ].
	self class preferredExtent: aSize
]

{ #category : 'private - traversing' }
SpPanelWindowPresenter >> presenters [

	^ presenters ifNil: [ #() ]
]

{ #category : 'private - traversing' }
SpPanelWindowPresenter >> presentersDo: aBlock [

	self presenters do: aBlock
]

{ #category : 'initialization' }
SpPanelWindowPresenter >> registerActions [

	self ensureInternalActions 
		addShortcutWith: [ :action | action 
			shortcutKey: $w actionModifier;
			action: [ self close ] ]
]

{ #category : 'api' }
SpPanelWindowPresenter >> startVisible: aBoolean [

	self withAdapterPerformOrDefer: [ :anAdapter | anAdapter startVisible: aBoolean ]
]

{ #category : 'api' }
SpPanelWindowPresenter >> startWidth [

	self withAdapterDo: [ :anAdapter | ^ anAdapter startWidth ].
	^ nil
]

{ #category : 'api' }
SpPanelWindowPresenter >> startWidth: aNumber [

	self withAdapterPerformOrDefer: [ :anAdapter | anAdapter startWidth: aNumber ]
]

{ #category : 'api' }
SpPanelWindowPresenter >> statusbar [

	^ statusbar ifNil: [ statusbar := self instantiate: SpPanelStatusbarPresenter ]
]

{ #category : 'api' }
SpPanelWindowPresenter >> title [

	^ title
]

{ #category : 'api' }
SpPanelWindowPresenter >> title: aString [

	title := aString
]

{ #category : 'api' }
SpPanelWindowPresenter >> topHeight [


	self withAdapterDo: [ :anAdapter | ^ anAdapter topHeight ].
	^ nil
]

{ #category : 'api' }
SpPanelWindowPresenter >> topHeight: aNumber [

	self withAdapterPerformOrDefer: [ :anAdapter | anAdapter topHeight: aNumber ]
]

{ #category : 'api' }
SpPanelWindowPresenter >> topVisible: aBoolean [

	self withAdapterPerformOrDefer: [ :anAdapter | anAdapter topVisible: aBoolean ]
]

{ #category : 'private - traversing' }
SpPanelWindowPresenter >> traversePresentersDo: aBlock excluding: excludes [

	super traversePresentersDo: aBlock excluding: excludes.
	self presentersDo: [ :each |
		each traversePresentersDo: aBlock excluding: excludes ]
]

{ #category : 'api - events' }
SpPanelWindowPresenter >> whenClosedDo: aBlock [
	"Inform when window is closed.
	 `aBlock` receives zero arguments."
	
	self 
		property: #isClosed 
		whenChangedDo: [ :value | value ifTrue: aBlock ]
]

{ #category : 'api - events' }
SpPanelWindowPresenter >> whenOpenedDo: aBlock [
	"Inform when window is opened. 
	 `aBlock` receives zero arguments."

	self 
		property: #isClosed 
		whenChangedDo: [ :value | value ifFalse: aBlock ]
]

{ #category : 'api - events' }
SpPanelWindowPresenter >> whenResizingDo: aBlock [
	"Inform when window is resizing. 
	 `aBlock` receives one optional argument (an instance of the announcement `SpWindowResizing`)"

	self announcer 
		when: SpWindowResizing 
		do: aBlock 
		for: aBlock receiver
]

{ #category : 'api - events' }
SpPanelWindowPresenter >> whenTitleChangedDo: aBlock [

	self property: #title whenChangedDo: aBlock
]

{ #category : 'api - events' }
SpPanelWindowPresenter >> whenWillCloseDo: aBlock [
	"Inform when window will close, allowing process before the close happen. 
	 Note that user cannot cancel the close operation using this event. 
	 `aBlock` receives one optional argument (an instance of the announcement `SpWindowWillClose`)."

	self announcer
		when: SpWindowWillClose
		do: aBlock
		for: aBlock receiver
]

{ #category : 'accessing' }
SpPanelWindowPresenter >> window [
	"this is for compatibility with SpWindowPresenter... not convinced"

	self withAdapterDo: [ :anAdapter | ^ anAdapter widget ].
	
	^ nil
]

{ #category : 'private' }
SpPanelWindowPresenter >> windowClosed [
	
	isClosed := true.
	self application windowClosed: self
]

{ #category : 'accessing' }
SpPanelWindowPresenter >> windowIcon: anIcon [
	"For background compatibility"
]

{ #category : 'updating' }
SpPanelWindowPresenter >> windowIsClosing [
	
	self flag: #TODO.
	"inform the presenters they will be closed"
]

{ #category : 'updating' }
SpPanelWindowPresenter >> windowIsOpened [

	isClosed := false
]
