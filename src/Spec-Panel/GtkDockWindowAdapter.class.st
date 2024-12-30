Class {
	#name : 'GtkDockWindowAdapter',
	#superclass : 'GtkAdapter',
	#instVars : [
		'lastSizeAllocation'
	],
	#category : 'Spec-Panel-Adapter',
	#package : 'Spec-Panel',
	#tag : 'Adapter'
}

{ #category : 'building' }
GtkDockWindowAdapter >> addModelTo: gtkWindow [

	super addModelTo: gtkWindow.

	gtkWindow defaultSize: self presenter initialExtent.
	
	self addTitlebarTo: gtkWindow.

	self connectToGtkSignals: gtkWindow.

	self presenter presenters do: [ :each | 
		self dockWindow: each to: gtkWindow ].

	"gtkWindow dock forEachFrameDo: [ :aPanelFrame | aPanelFrame crTrace ].
	gtkWindow dock connectCreateFrame: [ :handle :position :user_data |
		'HERE' crTrace.
		PanelFrame new getHandle ]"
]

{ #category : 'building' }
GtkDockWindowAdapter >> addTitlebarTo: gtkWindow [
	
	gtkWindow titlebar: (AdwHeaderBar new  
		titleWidget: (GtkLabel newLabel: self presenter title);
		yourself) 
]

{ #category : 'building' }
GtkDockWindowAdapter >> addVisibleSettingsTo: gtkWidget [
	"windows fo not have visibility settings, they are shown or hide"
]

{ #category : 'private - announcing' }
GtkDockWindowAdapter >> announceClosed [

	self presenter windowIsClosing.
	self presenter windowClosed
]

{ #category : 'private - announcing' }
GtkDockWindowAdapter >> announceOpened [
	"ensure not in callback"
	
	self runInSystem: [ 
		self presenter windowIsOpened ]
]

{ #category : 'private - announcing' }
GtkDockWindowAdapter >> announceResized: newSize [
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
GtkDockWindowAdapter >> announceWillClose [
	| ann |

	ann := SpWindowWillClose new
		window: self presenter;
		yourself.
	
	self presenter announce: ann.
	
	^ ann canClose
]

{ #category : 'accessing' }
GtkDockWindowAdapter >> bottomHeight: aNumber [

	self widgetDo: [ :w | w dock bottomHeight: aNumber ]
]

{ #category : 'accessing' }
GtkDockWindowAdapter >> bottomVisible: aBoolean [

	self widgetDo: [ :w | w dock revealBottom: aBoolean ]
]

{ #category : 'accessing' }
GtkDockWindowAdapter >> close [

	self announceWillClose ifFalse: [ ^ self ].
	self widgetDo: [ :w | w beNotVisible ]
]

{ #category : 'private' }
GtkDockWindowAdapter >> closeFromSignal [
	"this is called from connectDestroy (just one time)"

	self announceClosed.
	self widget unregister
]

{ #category : 'private - building' }
GtkDockWindowAdapter >> connectToGtkSignals: gtkWindow [

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
GtkDockWindowAdapter >> dockWindow: aDockableWindow [

	self widgetDo: [ :w |
		self dockWindow: aDockableWindow to: w ]
	

	
]

{ #category : 'accessing' }
GtkDockWindowAdapter >> dockWindow: aDockableWindow to: gtkWindow [
	| panelWidget panelPosition panelArea |
 
	panelPosition := aDockableWindow dockPosition toPanelPosition.
	panelWidget := aDockableWindow build.
	gtkWindow 
		addWidget: panelWidget 
		at: panelPosition.

	panelArea := aDockableWindow dockArea asPanelArea.
	(gtkWindow dock isAreaRevealed: panelArea)
		ifFalse: [ gtkWindow dock revealArea: panelArea ]	.
			
	aDockableWindow windowIsOpened
]

{ #category : 'accessing' }
GtkDockWindowAdapter >> endVisible: aBoolean [

	self widgetDo: [ :w | w dock revealEnd: aBoolean ]
]

{ #category : 'accessing' }
GtkDockWindowAdapter >> endWidth: aNumber [

	self widgetDo: [ :w | w dock endWidth: aNumber ]
]

{ #category : 'testing' }
GtkDockWindowAdapter >> isAreaVisible: aDockArea [

	aDockArea = DockArea center ifTrue: [ ^ true ].
	
	^ self widgetDo: [ :w |
		 w dock isAreaRevealed: aDockArea asPanelArea ]
]

{ #category : 'testing' }
GtkDockWindowAdapter >> isTopWindow [

	^ self widgetDo: [ :w |
		GEngine current ensureApplication activeWindow
			ifNotNil: [ :active | active getHandle = w getHandle ]
			ifNil: [ false ] ]
]

{ #category : 'building' }
GtkDockWindowAdapter >> newWidget [

	^ self widgetClass new 
		autoRelease;
		hideOnClose: false;
		yourself
]

{ #category : 'accessing' }
GtkDockWindowAdapter >> openWithDeferredAction: aBlock [
 
	self hasWidget ifFalse: [ ^ nil ].
	self widgetDo: [ :w | w present ].
	self processInitializationDeferredActions.
	self announceOpened.
	self presenter takeKeyboardFocus.
	aBlock value
]

{ #category : 'private' }
GtkDockWindowAdapter >> processInitializationDeferredActions [
	
	self presenter traversePresentersDo: [ :each | 
		each adapter ifNotNil: [ :anAdapter |
			anAdapter doInitializationDeferredActions ] ] 
]

{ #category : 'accessing' }
GtkDockWindowAdapter >> startVisible: aBoolean [

	self widgetDo: [ :w | w dock revealStart: aBoolean ]
]

{ #category : 'accessing' }
GtkDockWindowAdapter >> startWidth: aNumber [

	self widgetDo: [ :w | w dock startWidth: aNumber ]
]

{ #category : 'accessing' }
GtkDockWindowAdapter >> title: aString [ 
	
	self widgetDo: [ :w | 
		w titlebar titleWidget label: aString ]
]

{ #category : 'accessing' }
GtkDockWindowAdapter >> topHeight: aNumber [

	self widgetDo: [ :w | w dock topHeight: aNumber ]
]

{ #category : 'accessing' }
GtkDockWindowAdapter >> topVisible: aBoolean [

	self widgetDo: [ :w | w dock revealTop: aBoolean ]
]

{ #category : 'building' }
GtkDockWindowAdapter >> widgetClass [

	^ PanelDocumentWorkspaceWindow
]

{ #category : 'test support' }
GtkDockWindowAdapter >> widgetIsVisible [

	^ self widgetDo: [ :w | w isVisible ]
]

{ #category : 'test support' }
GtkDockWindowAdapter >> widgetSize [

	^ self widgetDo: [ :w | w defaultSize ]
]

{ #category : 'test support' }
GtkDockWindowAdapter >> widgetTitle [

	^ self widgetDo: [ :w | w titlebar titleWidget label ]
]
