"
https://gnome.pages.gitlab.gnome.org/libpanel/panel-1.0/class.DocumentWorkspace.html
"
Class {
	#name : 'PanelDocumentWorkspace',
	#superclass : 'PanelWorkspace',
	#instVars : [
		'titlebar',
		'dock',
		'widgets',
		'grid',
		'statusbar'
	],
	#category : 'Panel',
	#package : 'Panel'
}

{ #category : 'instance creation' }
PanelDocumentWorkspace class >> gType [

	^ self ffiCall: #(gsize panel_document_workspace_get_type())
]

{ #category : 'private' }
PanelDocumentWorkspace class >> gtkNew [

	^ self ffiCall: #(PanelDocumentWorkspace* panel_document_workspace_new (void))
]

{ #category : 'accessing' }
PanelDocumentWorkspace >> addWidget: aWidget [

	self 
		addWidget: aWidget
		at: PanelPosition center
]

{ #category : 'accessing' }
PanelDocumentWorkspace >> addWidget: aPanelWidget at: aPanelPosition [

	widgets add: aPanelWidget.
	self 
		basicAddWidget: aPanelWidget 
		at: aPanelPosition
]

{ #category : 'private' }
PanelDocumentWorkspace >> basicAddWidget: widget at: position [

	^ self ffiCall: #(gboolean panel_document_workspace_add_widget (
		self, 
		PanelWidget* widget,
		PanelPosition* position))
]

{ #category : 'private' }
PanelDocumentWorkspace >> basicTitlebar: aWidget [

	self ffiCall: #(void panel_document_workspace_set_titlebar (self, GtkWidget* aWidget))
]

{ #category : 'accessing' }
PanelDocumentWorkspace >> dock [

	^ dock ifNil: [
		dock := self getDock initialize ]
]

{ #category : 'accessing' }
PanelDocumentWorkspace >> dock: aPanelDock [

	self setDock: aPanelDock.
	dock := aPanelDock
]

{ #category : 'private' }
PanelDocumentWorkspace >> getDock [

	^ self ffiCall: #(PanelDock* panel_document_workspace_get_dock (self))
]

{ #category : 'private' }
PanelDocumentWorkspace >> getGrid [

	^ self ffiCall: #(PanelGrid* panel_document_workspace_get_grid (self))
]

{ #category : 'accessing' }
PanelDocumentWorkspace >> getStatusbar [

	^ self ffiCall: #(PanelStatusbar* panel_document_workspace_get_statusbar (self))
]

{ #category : 'accessing' }
PanelDocumentWorkspace >> grid [

	^ grid ifNil: [ grid := self getGrid ]
]

{ #category : 'initialization' }
PanelDocumentWorkspace >> initialize [

	super initialize.
	widgets := Set new
]

{ #category : 'private' }
PanelDocumentWorkspace >> setDock: aPanelDock [

	^ self ffiCall: #(void panel_document_workspace_get_dock (self, PanelDock *aPanelDock))
]

{ #category : 'accessing' }
PanelDocumentWorkspace >> statusbar [

	^ statusbar ifNil: [ statusbar := self getStatusbar ]
]

{ #category : 'accessing' }
PanelDocumentWorkspace >> titlebar [

	^ titlebar
]

{ #category : 'accessing' }
PanelDocumentWorkspace >> titlebar: aWidget [

	titlebar := aWidget.
	self basicTitlebar: aWidget
]
