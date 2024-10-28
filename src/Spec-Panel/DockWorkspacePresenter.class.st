Class {
	#name : 'DockWorkspacePresenter',
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
DockWorkspacePresenter class >> adapterName [

	^ #WorkspaceAdapter
]

{ #category : 'accessing' }
DockWorkspacePresenter class >> defaultTitle [
	
	^ 'Untitled Dock'
]

{ #category : 'api' }
DockWorkspacePresenter >> addPresenter: aPresenter at: anArea [

	self addWindow: (aPresenter asDockableWindow 
		dockArea: anArea;
		yourself)
]

{ #category : 'private' }
DockWorkspacePresenter >> addWindow: aDockableWindow [
	
	aDockableWindow owner: self.
	presenters := self presenters copyWith: aDockableWindow.
	self withAdapterDo: [ :anAdapter | anAdapter dockWindow: aDockableWindow ]
]

{ #category : 'showing' }
DockWorkspacePresenter >> asWindow [

	^ self
]

{ #category : 'api' }
DockWorkspacePresenter >> close [
	"Close current window."

	"Only manage closing if the presenter is really open"
	self isOpen ifFalse: [ ^ self ].
	self withAdapterDo: [ :anAdapter | 
		anAdapter close ]
]

{ #category : 'private' }
DockWorkspacePresenter >> defaultInitialExtent [
	
	^ 800@600
]

{ #category : 'api' }
DockWorkspacePresenter >> initialExtent [
	"Answer initial extent of the window. By default, it answer what is defined 
	 in `#defaultInitialExtent`"

	^ initialExtent ifNil: [ self defaultInitialExtent ]
]

{ #category : 'api' }
DockWorkspacePresenter >> initialExtent: aPoint [

	initialExtent := aPoint
]

{ #category : 'initialization' }
DockWorkspacePresenter >> initialize [

	super initialize.

	titleHolder := self class defaultTitle.
	isClosed := true.
	"resizable := true.
	centered := false.
	decorations := true."

	self whenTitleChangedDo: [ :aString |
		self withAdapterDo: [ :anAdapter | anAdapter title: aString ] ]
]

{ #category : 'testing' }
DockWorkspacePresenter >> isAreaVisible: aDockArea [

	self withAdapterDo: [ :anAdapter | 
		^ anAdapter isAreaVisible: aDockArea ].
	
	^ false
]

{ #category : 'testing' }
DockWorkspacePresenter >> isClosed [
	"Answer if window has is closed"

	^ isClosed
]

{ #category : 'testing' }
DockWorkspacePresenter >> isOpen [
	"Answer if window is open."
	
	^ self isClosed not
]

{ #category : 'showing' }
DockWorkspacePresenter >> open [

	self build.
	self application registerWindow: self.
	self withAdapterDo: [ :anAdapter | 
		anAdapter openWithDeferredAction: [ 
			self allPresenters do: [ :each | each announceDisplayed ] ] ]
]

{ #category : 'api' }
DockWorkspacePresenter >> presenters [

	^ presenters ifNil: [ #() ]
]

{ #category : 'api' }
DockWorkspacePresenter >> title [

	^ title
]

{ #category : 'api' }
DockWorkspacePresenter >> title: aString [

	title := aString
]

{ #category : 'api - events' }
DockWorkspacePresenter >> whenClosedDo: aBlock [
	"Inform when window is closed.
	 `aBlock` receives zero arguments."
	
	self 
		property: #isClosed 
		whenChangedDo: [ :value | value ifTrue: aBlock ]
]

{ #category : 'api - events' }
DockWorkspacePresenter >> whenTitleChangedDo: aBlock [

	self property: #title whenChangedDo: aBlock
]

{ #category : 'api - events' }
DockWorkspacePresenter >> whenWillCloseDo: aBlock [
	"Inform when window will close, allowing process before the close happen. 
	 Note that user cannot cancel the close operation using this event. 
	 `aBlock` receives one optional argument (an instance of the announcement `SpWindowWillClose`)."

	self announcer
		when: SpWindowWillClose
		do: aBlock
		for: aBlock receiver
]

{ #category : 'private' }
DockWorkspacePresenter >> windowClosed [
	
	isClosed := true.
	self application windowClosed: self
]

{ #category : 'updating' }
DockWorkspacePresenter >> windowIsClosing [
	
	self flag: #TODO.
	"inform the presenters they will be closed"
]

{ #category : 'updating' }
DockWorkspacePresenter >> windowIsOpened [

	isClosed := false
]
