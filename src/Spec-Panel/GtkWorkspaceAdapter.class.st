Class {
	#name : 'GtkWorkspaceAdapter',
	#superclass : 'GtkAdapter',
	#instVars : [
		'lastSizeAllocation'
	],
	#category : 'Spec-Panel-Adapter',
	#package : 'Spec-Panel',
	#tag : 'Adapter'
}

{ #category : 'building' }
GtkWorkspaceAdapter >> addModelTo: gtkWindow [

	super addModelTo: gtkWindow.

	gtkWindow defaultSize: self presenter initialExtent.

	self addTitlebarTo: gtkWindow.

	self connectToGtkSignals: gtkWindow.

	self presenter presenters do: [ :each | 
		self dockWindow: each to: gtkWindow ]

	"add window properties"
	"self presenter initialExtent ifNotNil: [ :extent |
		gtkWindow defaultSize: extent ]."
	"self presenter initialPosition
		ifNotNil: [ :position | gtkWindow moveTo: position ]."
	"gtkWindow decorated: self presenter hasDecorations.
	self subscribeDecorations."
]

{ #category : 'building' }
GtkWorkspaceAdapter >> addTitlebarTo: gtkWindow [
	
	gtkWindow titlebar: (AdwHeaderBar new  
		titleWidget: (GtkLabel newLabel: self presenter title);
		yourself) 
]

{ #category : 'building' }
GtkWorkspaceAdapter >> addVisibleSettingsTo: gtkWidget [
	"windows fo not have visibility settings, they are shown or hide"
]

{ #category : 'private - announcing' }
GtkWorkspaceAdapter >> announceClosed [

	self presenter windowIsClosing.
	self presenter windowClosed
]

{ #category : 'private - announcing' }
GtkWorkspaceAdapter >> announceOpened [
	"ensure not in callback"
	
	self runInSystem: [ 
		self presenter windowIsOpened ]
]

{ #category : 'private - announcing' }
GtkWorkspaceAdapter >> announceResized: newSize [
	| windowSize |

	"We keep last size allocation to compare, because size-allocate can be signaled 
	 several times, many of them with same extent. 
	 We want to avoid the internal signaling of window resized in those cases (because 
	 there is no real resizing). "
	lastSizeAllocation = newSize ifTrue: [ ^ self ].
	lastSizeAllocation := newSize.
	"It seems the allocated extent is not necessarly the resulting size of the window, 
	 Instead using that extent as newSize informed, we ask the real size of the 
	 window to send."
	self widgetDo: [ :w | windowSize := w defaultSize ].
	self presenter announcer announce: (SpWindowResizing new
		window: self presenter;
		newSize: windowSize;	
		yourself)	
]

{ #category : 'private - announcing' }
GtkWorkspaceAdapter >> announceWillClose [
	| ann |

	ann := SpWindowWillClose new
		window: self presenter;
		yourself.
	
	self presenter announce: ann.
	
	^ ann canClose
]

{ #category : 'accessing' }
GtkWorkspaceAdapter >> close [

	self announceWillClose ifFalse: [ ^ self ].
	self widgetDo: [ :w | w beNotVisible ]
]

{ #category : 'private' }
GtkWorkspaceAdapter >> closeFromSignal [
	"this is called from connectDestroy (just one time)"

	self announceClosed.
	self widget unregister
]

{ #category : 'private - building' }
GtkWorkspaceAdapter >> connectToGtkSignals: gtkWindow [

	"add close events (delete is sent before)"

	gtkWindow
		connectCloseRequest: [ 
			"true to stop handlers to continue (so, if I want to *not* close it, I need 
			 to answer true, the oposite of canClose)"
			self announceWillClose not ];
		connectHide: [ self closeFromSignal ];
		connectDefaultWidth: [ self announceResized: self widget defaultSize ];
		connectDefaultHeight: [ self announceResized: self widget defaultSize ]
]

{ #category : 'accessing' }
GtkWorkspaceAdapter >> dockWindow: aDockableWindow [

	self widgetDo: [ :w |
		self dockWindow: aDockableWindow to: w ]
	

	
]

{ #category : 'accessing' }
GtkWorkspaceAdapter >> dockWindow: aDockableWindow to: gtkWindow [
	| panelWidget panelPosition panelArea |
 
	panelPosition := aDockableWindow dockArea asPanelPosition.
	panelArea := aDockableWindow dockArea asPanelArea.
	panelWidget := aDockableWindow build.
	gtkWindow 
		addWidget: panelWidget 
		at: panelPosition.
	(gtkWindow dock isAreaRevealed: panelArea)
		ifFalse: [ gtkWindow dock revealArea: panelArea ]	
]

{ #category : 'testing' }
GtkWorkspaceAdapter >> isAreaVisible: aDockArea [

	aDockArea = DockArea center ifTrue: [ ^ true ].
	
	^ self widgetDo: [ :w |
		 w dock isAreaRevealed: aDockArea asPanelArea ]
]

{ #category : 'building' }
GtkWorkspaceAdapter >> newWidget [

	^ self widgetClass new 
		autoRelease;
		hideOnClose: false;
		yourself
]

{ #category : 'accessing' }
GtkWorkspaceAdapter >> openWithDeferredAction: aBlock [
 
	self hasWidget ifFalse: [ ^ nil ].
	self widgetDo: [ :w | w present ].
	self processInitializationDeferredActions.
	self announceOpened.
	aBlock value
]

{ #category : 'private' }
GtkWorkspaceAdapter >> processInitializationDeferredActions [
	
	self presenter traversePresentersDo: [ :each | 
		each adapter ifNotNil: [ :anAdapter |
			anAdapter doInitializationDeferredActions ] ] 
]

{ #category : 'accessing' }
GtkWorkspaceAdapter >> title: aString [ 
	
	self widgetDo: [ :w | 
		w titlebar titleWidget label: aString ]
]

{ #category : 'building' }
GtkWorkspaceAdapter >> widgetClass [

	^ PanelDocumentWorkspaceWindow
]

{ #category : 'test support' }
GtkWorkspaceAdapter >> widgetIsVisible [

	^ self widgetDo: [ :w | w isVisible ]
]

{ #category : 'test support' }
GtkWorkspaceAdapter >> widgetSize [

	^ self widgetDo: [ :w | w defaultSize ]
]

{ #category : 'test support' }
GtkWorkspaceAdapter >> widgetTitle [

	^ self widgetDo: [ :w | w titlebar titleWidget label ]
]
