"
https://gnome.pages.gitlab.gnome.org/libpanel/panel-1.0/class.FrameHeaderBar.html
"
Class {
	#name : 'PanelFrameHeaderBar',
	#superclass : 'PanelFrameHeader',
	#category : 'Panel',
	#package : 'Panel'
}

{ #category : 'private' }
PanelFrameHeaderBar class >> gtkNew [

	^ self ffiCall: #(PanelFrameHeaderBar* panel_frame_header_bar_new (void))
]
