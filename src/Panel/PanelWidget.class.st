"
https://gnome.pages.gitlab.gnome.org/libpanel/class.Widget.html
"
Class {
	#name : 'PanelWidget',
	#superclass : 'GtkWidget',
	#traits : 'LibTPanel + GtkTBin',
	#classTraits : 'LibTPanel classTrait + GtkTBin classTrait',
	#instVars : [
		'menuModel'
	],
	#category : 'Panel',
	#package : 'Panel'
}

{ #category : 'private' }
PanelWidget class >> gtkNew [

	^ self ffiCall: #(PanelWidget* panel_widget_new (void))
]

{ #category : 'testing' }
PanelWidget >> canMaximize [

	^ self ffiCall: #(gboolean panel_widget_get_can_maximize (self))
]

{ #category : 'accessing' }
PanelWidget >> canMaximize: can_maximize [

	self ffiCall: #(void panel_widget_set_can_maximize (self, gboolean can_maximize))
]

{ #category : 'signaling' }
PanelWidget >> connectGetDefaultFocus: aBlock [

	self 
		connect: 'get-default-focus'
	 	signature:  #(void* (void *widget, gpointer user_data))
		do: [ :widget :user_data | 
			aBlock value ]
]

{ #category : 'signaling' }
PanelWidget >> connectPresented: aBlock [

	self 
		connect: 'presented'
	 	signature:  #(void (void *widget, gpointer user_data))
		do: [ :widget :user_data | 
			aBlock value ]
]

{ #category : 'private' }
PanelWidget >> getMenuModel [

	self ffiCall: #(GMenuModel *panel_widget_get_menu_model (self))
]

{ #category : 'accessing' }
PanelWidget >> icon [

	self ffiCall: #(GIcon* panel_widget_get_icon (self))
]

{ #category : 'accessing' }
PanelWidget >> icon: icon [

	self ffiCall: #(void panel_widget_set_icon (self, GIcon* icon))
]

{ #category : 'testing' }
PanelWidget >> isBusy [

	^ self ffiCall: #(gboolean panel_widget_get_busy (self))
]

{ #category : 'testing' }
PanelWidget >> isModified [

	self ffiCall: #(gboolean panel_widget_get_modified (self))
]

{ #category : 'testing' }
PanelWidget >> isReorderable [

	self ffiCall: #(gboolean panel_widget_get_reorderable (self))
]

{ #category : 'accessing' }
PanelWidget >> markBusy [

	self ffiCall: #(void panel_widget_mark_busy (self))
]

{ #category : 'accessing' }
PanelWidget >> maximize [

	^ self ffiCall: #(void panel_widget_maximize (self))
]

{ #category : 'accessing' }
PanelWidget >> menuModel [

	^ menuModel ifNil: [ menuModel := self getMenuModel ]
]

{ #category : 'accessing' }
PanelWidget >> menuModel: menu_model [

	menuModel := menu_model.
	self setMenuModel: menu_model
]

{ #category : 'accessing' }
PanelWidget >> modified: modified [

	self ffiCall: #(void panel_widget_set_modified (self, gboolean modified))
]

{ #category : 'testing' }
PanelWidget >> needsAttention [

	^ self ffiCall: #(gboolean panel_widget_get_needs_attention (self))
]

{ #category : 'accessing' }
PanelWidget >> needsAttention: needs_attention [

	self ffiCall: #(void panel_widget_set_needs_attention (self, gboolean needs_attention))
]

{ #category : 'accessing' }
PanelWidget >> reorderable: reorderable [

	self ffiCall: #(void panel_widget_set_reorderable (self, gboolean reorderable))
]

{ #category : 'private' }
PanelWidget >> setChild: aWidget [

	self ffiCall: #(void panel_widget_set_child (self, GtkWidget* aWidget))
]

{ #category : 'private' }
PanelWidget >> setMenuModel: menu_model [

	self ffiCall: #(void panel_widget_set_menu_model (self, GMenuModel* menu_model))
]

{ #category : 'accessing' }
PanelWidget >> title [

	^ self ffiCall: #(char *panel_widget_get_title (self))
]

{ #category : 'accessing' }
PanelWidget >> title: aString [

	self ffiCall: #(void panel_widget_set_title (self, const char* aString))
]

{ #category : 'accessing' }
PanelWidget >> tooltip [

	^ self ffiCall: #(char* panel_widget_set_tooltip (self))
]

{ #category : 'accessing' }
PanelWidget >> tooltip: tooltip [

	self ffiCall: #(void panel_widget_set_tooltip (self, const char* tooltip))
]

{ #category : 'accessing' }
PanelWidget >> unmarkBusy [

	self ffiCall: #(void panel_widget_unmark_busy (self))
]

{ #category : 'accessing' }
PanelWidget >> unmaximize [

	self ffiCall: #(void panel_widget_unmaximize (self))
]
