"
https://gnome.pages.gitlab.gnome.org/libpanel/panel-1.0/class.Dock.html
"
Class {
	#name : 'PanelDock',
	#superclass : 'GtkWidget',
	#traits : 'LibTPanel',
	#classTraits : 'LibTPanel classTrait',
	#instVars : [
		'overlay'
	],
	#pools : [
		'PanelArea'
	],
	#category : 'Panel',
	#package : 'Panel'
}

{ #category : 'private' }
PanelDock class >> gtkNew [

	^ self ffiCall: #(PanelDock *panel_dock_new #(void))
]

{ #category : 'instance creation' }
PanelDock class >> new [

	^ self gtkNew initialize
]

{ #category : 'private' }
PanelDock >> basicForEachFrame: callback [

	self ffiCall: #(void panel_dock_foreach_frame (
		self,
  		"PanelFrameCallback"GCallback callback,
  		"gpointer user_data"NULL))
]

{ #category : 'accessing' }
PanelDock >> bottomHeight [

	^ self gObjectGetInteger: 'bottom-height'
]

{ #category : 'accessing' }
PanelDock >> bottomHeight: height [

	self ffiCall: #(void panel_dock_set_bottom_height (self, int height))
]

{ #category : 'signaling' }
PanelDock >> connectCreateFrame: aBlock [

	self 
		connect: 'create-frame' 
		signature: #(void* (void* selfHandle, void* position, gpointer user_data)) 
		do: [ :self_handle :position :user_data |
			aBlock value: (PanelPosition fromHandleUnreferenced: position) ]
]

{ #category : 'accessing' }
PanelDock >> endWidth [

	^ self gObjectGetInteger: 'end-width'
]

{ #category : 'accessing' }
PanelDock >> endWidth: width [

	self ffiCall: #(void panel_dock_set_end_width (self, int width))
]

{ #category : 'accessing' }
PanelDock >> forEachFrameDo: aBlock [ 
	| callback |
	
	callback := GCallback 
		signature: #(void (void *frameHandle, gpointer user_data)) 
		block: [ :frameHandle :user_data |
			aBlock value: (PanelFrame fromHandleUnreferenced: frameHandle) ].
		
	self basicForEachFrame: callback
]

{ #category : 'private' }
PanelDock >> getOverlay [

	self flag: #HACK. "I know a panel dock has an overlay as first children, but I 
	do not have a real access to it, so I need to hack its access. 
	THIS MAY FAIL IN THE FUTURE :("
	
	^ self firstChild asConcreteType
]

{ #category : 'testing' }
PanelDock >> isAreaRevealed: aPanelArea [

	aPanelArea = PANEL_AREA_TOP ifTrue: [ ^ self isTopRevealed ].
	aPanelArea = PANEL_AREA_START ifTrue: [ ^ self isStartRevealed ].
	aPanelArea = PANEL_AREA_BOTTOM ifTrue: [ ^ self isBottomRevealed ].
	aPanelArea = PANEL_AREA_END ifTrue: [ ^ self isEndRevealed ].			
			
	"is center"
	^ true
]

{ #category : 'testing' }
PanelDock >> isBottomRevealed [

	^ self ffiCall: #(gboolean panel_dock_get_reveal_bottom (self))
]

{ #category : 'testing' }
PanelDock >> isEndRevealed [

	^ self ffiCall: #(gboolean panel_dock_get_reveal_end (self))
]

{ #category : 'testing' }
PanelDock >> isStartRevealed [

	^ self ffiCall: #(gboolean panel_dock_get_reveal_start (self))
]

{ #category : 'testing' }
PanelDock >> isTopRevealed [

	^ self ffiCall: #(gboolean panel_dock_get_reveal_top (self))
]

{ #category : 'accessing' }
PanelDock >> overlay [

	^ overlay ifNil: [ overlay := self getOverlay ]
]

{ #category : 'accessing' }
PanelDock >> remove: widget [

	self ffiCall: #(void panel_dock_remove (self, GtkWidget* widget))
]

{ #category : 'accessing' }
PanelDock >> revealArea: aPanelArea [

	aPanelArea = PANEL_AREA_TOP ifTrue: [ ^ self revealTop: true ].
	aPanelArea = PANEL_AREA_START ifTrue: [ ^ self revealStart: true ].
	aPanelArea = PANEL_AREA_BOTTOM ifTrue: [ ^ self revealBottom: true ].
	aPanelArea = PANEL_AREA_END ifTrue: [ ^ self revealEnd: true ]				
]

{ #category : 'accessing' }
PanelDock >> revealBottom: reveal_bottom [

	self ffiCall: #(void panel_dock_set_reveal_bottom (self, gboolean reveal_bottom))
]

{ #category : 'accessing' }
PanelDock >> revealEnd: reveal_end [

	self ffiCall: #(void panel_dock_set_reveal_end (self, gboolean reveal_end))
]

{ #category : 'accessing' }
PanelDock >> revealStart: reveal_start [

	self ffiCall: #(void panel_dock_set_reveal_start (self, gboolean reveal_start))
]

{ #category : 'accessing' }
PanelDock >> revealTop: reveal_top [

	self ffiCall: #(void panel_dock_set_reveal_top (self, gboolean reveal_top))
]

{ #category : 'accessing' }
PanelDock >> startWidth [

	^ self gObjectGetInteger: 'start-width'
]

{ #category : 'accessing' }
PanelDock >> startWidth: width [

	self ffiCall: #(void panel_dock_set_start_width (self, int width))
]

{ #category : 'accessing' }
PanelDock >> topHeight [

	^ self gObjectGetInteger: 'top-height'
]

{ #category : 'accessing' }
PanelDock >> topHeight: height [

	self ffiCall: #(void panel_dock_set_top_height (self, int height))
]
