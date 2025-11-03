"
Base object for implementations of `PanelTFrameHeader`
It matches the ifaz: https://gnome.pages.gitlab.gnome.org/libpanel/panel-1.0/iface.FrameHeader.html

"
Class {
	#name : 'PanelFrameHeader',
	#superclass : 'GtkWidget',
	#traits : 'LibTPanel + PanelTFrameHeader',
	#classTraits : 'LibTPanel classTrait + PanelTFrameHeader classTrait',
	#instVars : [
		'menuPopover'
	],
	#category : 'Panel',
	#package : 'Panel'
}

{ #category : 'private' }
PanelFrameHeader class >> gtkNew [

	^ self subclassResponsibility
]

{ #category : 'instance creation' }
PanelFrameHeader class >> new [

	^ self gtkNew initialize
]

{ #category : 'private' }
PanelFrameHeader >> getMenuPopover [

	self ffiCall: #(GtkPopoverMenu *panel_frame_header_bar_get_menu_popover (self))
]

{ #category : 'testing' }
PanelFrameHeader >> isShowIcon [

	self ffiCall: #(gboolean panel_frame_header_bar_get_show_icon (self))

]

{ #category : 'accessing' }
PanelFrameHeader >> menuPopover [

	^ menuPopover ifNil: [ menuPopover := self getMenuPopover ]
]

{ #category : 'accessing' }
PanelFrameHeader >> showIcon: show_icon [

	self ffiCall: #(void panel_frame_header_bar_set_show_icon (self, gboolean show_icon))

]
