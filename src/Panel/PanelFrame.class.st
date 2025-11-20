"
https://gnome.pages.gitlab.gnome.org/libpanel/panel-1.0/class.Frame.html
"
Class {
	#name : 'PanelFrame',
	#superclass : 'GtkWidget',
	#traits : 'LibTPanel',
	#classTraits : 'LibTPanel classTrait',
	#instVars : [
		'header'
	],
	#category : 'Panel',
	#package : 'Panel'
}

{ #category : 'private' }
PanelFrame class >> gtkNew [

	^ self ffiCall: #(PanelFrame* panel_frame_new (void))
]

{ #category : 'instance creation' }
PanelFrame class >> new [

	^ self gtkNew initialize
]

{ #category : 'signaling' }
PanelFrame >> connectPageClosed: aBlock [

	self 
		connect: 'page-closed' 
		signature: #(void (void* selfHandle, void* widget, gpointer user_data)) 
		do: [ :selfHandle :widget :user_data |
			aBlock value: widget ]
]

{ #category : 'accessing' }
PanelFrame >> header: aHeader [

	self withReferenceOf: header do: [
		header := aHeader.
		self setHeader: header.
		"caller (me) is owner of the reference, so no, do not unref"
		"header objectUnrefNow" ]
]

{ #category : 'private' }
PanelFrame >> setHeader: aHeader [

	self ffiCall: #(void panel_frame_set_header (self, PanelFrameHeader* aHeader))
]
