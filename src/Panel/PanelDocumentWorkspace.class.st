"
https://gnome.pages.gitlab.gnome.org/libpanel/class.DocumentWorkspace.html
"
Class {
	#name : 'PanelDocumentWorkspace',
	#superclass : 'PanelWorkspace',
	#instVars : [
		'titlebar',
		'dock',
		'widgets'
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

{ #category : 'private' }
PanelDocumentWorkspace >> getDock [

	^ self ffiCall: #(PanelDock* panel_document_workspace_get_dock (self))
]

{ #category : 'initialization' }
PanelDocumentWorkspace >> initialize [

	super initialize.
	widgets := Set new
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
