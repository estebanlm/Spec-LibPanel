Class {
	#name : 'GtkPanelWindowAdapter',
	#superclass : 'GtkAdapter',
	#instVars : [
		'lastSizeAllocation',
		'toastOverlay',
		'frames'
	],
	#category : 'Spec-Panel-Adapter',
	#package : 'Spec-Panel',
	#tag : 'Adapter'
}

{ #category : 'building' }
GtkPanelWindowAdapter >> addModelTo: panelWindow [

	super addModelTo: panelWindow.

	"Creation of frames (both in window and in dock) are not doing anythign extra to 
	 what they already do without hanging  on them, but I will need them when working on 
	 other menus, etc."
	
	frames := OrderedCollection new.
	panelWindow connectCreateFrame: [ :position |
		| frame |
		
		frame := PanelFrame new.
		frames add: frame.
		(position area = PanelArea PANEL_AREA_CENTER)
			ifTrue: [ frame header: PanelFrameTabBar new ].
		"frame connectPageClosed: [ :aWidget | aWidget printToStdout ]."
		frame getHandle ].

	panelWindow defaultSize: self presenter initialExtent.
	
	self addTitlebarTo: panelWindow.

	self connectToGtkSignals: panelWindow.
	self presenter presenters do: [ :each |
		self dockWindow: each to: panelWindow ].
	
	panelWindow grid connectCreateFrame: [
		| frame |
		frame := PanelFrame new.
		frame header: PanelFrameTabBar new.
		frames add: frame.
		"frame connectPageClosed: [ :aWidget | aWidget printToStdout ]."
		frame getHandle ].
		
	self addOverlaysTo: panelWindow
]

{ #category : 'accessing' }
GtkPanelWindowAdapter >> addOverlay: aPresenter constraints: constraints [

	self innerWidgetDo: [ :w |
		self 
			addOverlay: aPresenter 
			constraints: constraints 
			to: w ]
]

{ #category : 'accessing' }
GtkPanelWindowAdapter >> addOverlay: aPresenter constraints: constraints to: gtkWindow [
	| overlayWidget |
	
	overlayWidget := aPresenter build.
	constraints hAlign ifNotNil: [ :hAlign | overlayWidget hAlign: hAlign asGtkAlign ].
	constraints vAlign ifNotNil: [ :vAlign | overlayWidget vAlign: vAlign asGtkAlign ].
	gtkWindow dock overlay addOverlay: overlayWidget
]

{ #category : 'building' }
GtkPanelWindowAdapter >> addOverlaysTo: gtkWindow [
	| overlayLayout |

	overlayLayout := self presenter overlayLayout.
	overlayLayout children do: [ :each | 
		self 
			addOverlay: each 
			constraints: (overlayLayout constraintsFor: each)
			to: gtkWindow ]
]

{ #category : 'building' }
GtkPanelWindowAdapter >> addTitlebarTo: gtkWindow [
	
	gtkWindow titlebar: (AdwHeaderBar new  
		titleWidget: (GtkLabel newLabel: self presenter title);
		yourself)
]

{ #category : 'accessing' }
GtkPanelWindowAdapter >> addToast: aToast [
	self innerWidgetDo: [ :w |
		| toast |
		toast := self toAdwToast: aToast.
		toastOverlay ifNil: [
			toastOverlay := AdwToastOverlay new
				hAlign: GtkAlign GTK_ALIGN_CENTER;
				vAlign: GtkAlign GTK_ALIGN_END; "in fact, this could be a setting"
				yourself.
			w dock overlay addOverlay: toastOverlay ].
		toastOverlay addToast: toast ]
]

{ #category : 'building' }
GtkPanelWindowAdapter >> addVisibleSettingsTo: gtkWidget [
	"windows fo not have visibility settings, they are shown or hide"
]

{ #category : 'private - announcing' }
GtkPanelWindowAdapter >> announceClosed [

	self presenter windowIsClosing.
	self presenter windowClosed
]

{ #category : 'private - announcing' }
GtkPanelWindowAdapter >> announceOpened [
	"ensure not in callback"
	
	self runInSystem: [ 
		self presenter windowIsOpened ]
]

{ #category : 'private - announcing' }
GtkPanelWindowAdapter >> announceResized: newSize [
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
GtkPanelWindowAdapter >> announceWillClose [
	| ann |

	ann := SpWindowWillClose new
		window: self presenter;
		yourself.
	
	self presenter announce: ann.
	
	^ ann canClose
]

{ #category : 'accessing' }
GtkPanelWindowAdapter >> bottomHeight [

	^ self widgetDo: [ :w | w dock bottomHeight ]
]

{ #category : 'accessing' }
GtkPanelWindowAdapter >> bottomHeight: aNumber [

	self widgetDo: [ :w | w dock bottomHeight: aNumber ]
]

{ #category : 'accessing' }
GtkPanelWindowAdapter >> bottomVisible: aBoolean [

	self widgetDo: [ :w | w dock revealBottom: aBoolean ]
]

{ #category : 'accessing' }
GtkPanelWindowAdapter >> close [

	self announceWillClose ifFalse: [ ^ self ].
	self widgetDo: [ :w | w beNotVisible ]
]

{ #category : 'private' }
GtkPanelWindowAdapter >> closeFromSignal [
	"this is called from connectDestroy (just one time)"
	self runInSystem: [
		self announceClosed.
		self widget unregister ]
]

{ #category : 'private - building' }
GtkPanelWindowAdapter >> connectToGtkSignals: gtkWindow [

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
GtkPanelWindowAdapter >> dockWindow: aDockableWindow [

	self widgetDo: [ :w |
		self dockWindow: aDockableWindow to: w ]
	

	
]

{ #category : 'accessing' }
GtkPanelWindowAdapter >> dockWindow: aDockableWindow to: gtkWindow [
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
GtkPanelWindowAdapter >> endVisible: aBoolean [

	self widgetDo: [ :w | w dock revealEnd: aBoolean ]
]

{ #category : 'accessing' }
GtkPanelWindowAdapter >> endWidth [

	^ self widgetDo: [ :w | w dock endWidth ]
]

{ #category : 'accessing' }
GtkPanelWindowAdapter >> endWidth: aNumber [

	self widgetDo: [ :w | w dock endWidth: aNumber ]
]

{ #category : 'private' }
GtkPanelWindowAdapter >> findPresenterFocused: widgetFocused inTopLevel: aPresenter [

	aPresenter traversePresentersDo: [ :each | 
		(each adapter isFocusedWidgetSameAsMe: widgetFocused) 
			ifTrue: [ ^ each ] ].

	^ nil
]

{ #category : 'testing' }
GtkPanelWindowAdapter >> isAreaVisible: aDockArea [

	aDockArea = SpPanelArea center ifTrue: [ ^ true ].
	
	^ self widgetDo: [ :w |
		 w dock isAreaRevealed: aDockArea asPanelArea ]
]

{ #category : 'testing' }
GtkPanelWindowAdapter >> isBottomVisible [

	^ self isAreaVisible: SpPanelArea bottom
]

{ #category : 'testing' }
GtkPanelWindowAdapter >> isEndVisible [

	^ self isAreaVisible: SpPanelArea end
]

{ #category : 'testing' }
GtkPanelWindowAdapter >> isMaximized [
	| maximized |

	maximized := self widgetDo: [ :w | w isMaximized ].
	^ maximized ifNil: [ false ]
]

{ #category : 'testing' }
GtkPanelWindowAdapter >> isMinimized [

	^ self widgetDo: [ :w |
		w surface state isMinimized ]
]

{ #category : 'testing' }
GtkPanelWindowAdapter >> isStartVisible [

	^ self isAreaVisible: SpPanelArea start
]

{ #category : 'testing' }
GtkPanelWindowAdapter >> isTopVisible [

	^ self isAreaVisible: SpPanelArea top
]

{ #category : 'testing' }
GtkPanelWindowAdapter >> isTopWindow [

	^ self widgetDo: [ :w |
		GEngine current ensureApplication activeWindow
			ifNotNil: [ :active | active getHandle = w getHandle ]
			ifNil: [ false ] ]
]

{ #category : 'api - focus' }
GtkPanelWindowAdapter >> lastPresenterFocused [
	| widgetFocused |

	widgetFocused := self innerWidget widgetFocused.
	widgetFocused isNullOrNil ifTrue: [ ^ nil ].
	
	(self findPresenterFocused: widgetFocused inTopLevel: self presenter)
		ifNotNil: [ :aPresenter | ^ aPresenter ].
	"but it may also be in a popover"
	self presenter application windows 
		select: [ :each | each isPopover ]
		thenDo: [ :each | 
			(self findPresenterFocused: widgetFocused inTopLevel: each presenter)
				ifNotNil: [ :aPresenter | ^ aPresenter ] ].

	^ nil
]

{ #category : 'private - actions' }
GtkPanelWindowAdapter >> newActionManager [

	^ GtkAdapterActionPanelWindowManager on: self
]

{ #category : 'private - toast' }
GtkPanelWindowAdapter >> newToastWidgetFrom: aPanelToast in: aToast [
	| toastPresenter |
	
	toastPresenter := self presenter instantiate: SpPresenter.
	toastPresenter layout: (SpBoxLayout newHorizontal
		vAlignCenter;
		spacing: 5;
		add: ((toastPresenter newLabel 
			addStyle: 'heading';
			label: aPanelToast title; 
			yourself));
		add: (toastPresenter newButton 
				label: (aPanelToast actionLabel ifNil: [ 'Accept' ]);
				action: [ 
					aPanelToast action value. 
					aToast dismiss ] ) 
			expand: false;
	yourself).

	toastPresenter build.
	
	^ toastPresenter adapter widget
]

{ #category : 'building' }
GtkPanelWindowAdapter >> newWidget [

	^ self widgetClass new 
		autoRelease;
		hideOnClose: true;
		yourself
]

{ #category : 'accessing' }
GtkPanelWindowAdapter >> openWithDeferredAction: aBlock [
 
	self hasWidget ifFalse: [ ^ nil ].
	self widgetDo: [ :w | w present ].
	self processInitializationDeferredActions.
	self announceOpened.
	self presenter takeKeyboardFocus.
	aBlock value
]

{ #category : 'private' }
GtkPanelWindowAdapter >> processInitializationDeferredActions [
	
	self presenter traversePresentersDo: [ :each | 
		each adapter ifNotNil: [ :anAdapter |
			anAdapter doInitializationDeferredActions ] ] 
]

{ #category : 'accessing' }
GtkPanelWindowAdapter >> startVisible: aBoolean [

	self widgetDo: [ :w | w dock revealStart: aBoolean ]
]

{ #category : 'accessing' }
GtkPanelWindowAdapter >> startWidth [

	^ self widgetDo: [ :w | w dock startWidth ]
]

{ #category : 'accessing' }
GtkPanelWindowAdapter >> startWidth: aNumber [

	self widgetDo: [ :w | w dock startWidth: aNumber ]
]

{ #category : 'accessing' }
GtkPanelWindowAdapter >> title: aString [ 
	
	self widgetDo: [ :w | 
		w titlebar titleWidget label: aString ]
]

{ #category : 'private - toast' }
GtkPanelWindowAdapter >> toAdwToast: aPanelToast [
	| toast |

	toast := AdwToast new. 
	aPanelToast action 
		ifNotNil: [ toast customTitle: (self newToastWidgetFrom: aPanelToast in: toast) ]
		ifNil: [ toast title: (aPanelToast title ifNil: [ 'Unnamed' ]) ].
	aPanelToast timeout 
		ifNotNil: [ :aNumber | toast timeout: aNumber ].
	
	^ toast
]

{ #category : 'accessing' }
GtkPanelWindowAdapter >> topHeight [

	^ self widgetDo: [ :w | w dock topHeight ]
]

{ #category : 'accessing' }
GtkPanelWindowAdapter >> topHeight: aNumber [

	self widgetDo: [ :w | w dock topHeight: aNumber ]
]

{ #category : 'accessing' }
GtkPanelWindowAdapter >> topVisible: aBoolean [

	self widgetDo: [ :w | w dock revealTop: aBoolean ]
]

{ #category : 'building' }
GtkPanelWindowAdapter >> widgetClass [

	^ PanelDocumentWorkspaceWindow
]

{ #category : 'test support' }
GtkPanelWindowAdapter >> widgetIsVisible [

	^ self widgetDo: [ :w | w isVisible ]
]

{ #category : 'test support' }
GtkPanelWindowAdapter >> widgetSize [

	^ self widgetDo: [ :w | w defaultSize ]
]

{ #category : 'test support' }
GtkPanelWindowAdapter >> widgetTitle [

	^ self widgetDo: [ :w | w titlebar titleWidget label ]
]
