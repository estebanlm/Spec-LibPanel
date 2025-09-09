"
https://gnome.pages.gitlab.gnome.org/libpanel/panel-1.0/class.Statusbar.html
"
Class {
	#name : 'PanelStatusbar',
	#superclass : 'GtkWidget',
	#traits : 'LibTPanel',
	#classTraits : 'LibTPanel classTrait',
	#instVars : [
		'children'
	],
	#category : 'Panel',
	#package : 'Panel'
}

{ #category : 'accessing' }
PanelStatusbar >> addPrefix: aWidget priority: aNumber [

	self keepWidget: aWidget.
	self basicAddPrefix: aWidget priority: aNumber
]

{ #category : 'accessing' }
PanelStatusbar >> addSuffix: aWidget priority: aNumber [

	self keepWidget: aWidget.
	self basicAddSuffix: aWidget priority: aNumber
]

{ #category : 'private' }
PanelStatusbar >> basicAddPrefix: widget priority: priority [

	self ffiCall: #(void panel_statusbar_add_prefix (self, int priority, GtkWidget* widget))
]

{ #category : 'private' }
PanelStatusbar >> basicAddSuffix: widget priority: priority [

	self ffiCall: #(void panel_statusbar_add_suffix (self, int priority, GtkWidget* widget))
]

{ #category : 'accessing' }
PanelStatusbar >> basicRemove: widget [

	self ffiCall: #(void panel_statusbar_remove (self, GtkWidget* widget))
]

{ #category : 'initialization' }
PanelStatusbar >> initialize [

	super initialize.
	children := #()
]

{ #category : 'private' }
PanelStatusbar >> keepWidget: aWidget [

	"since this component can be initialized in gtk side"
	children ifNil: [ children := #() ].
	children := children copyWith: aWidget
]

{ #category : 'accessing' }
PanelStatusbar >> remove: aWidget [

	self basicRemove: aWidget.
	children := children copyWithout: aWidget
]
