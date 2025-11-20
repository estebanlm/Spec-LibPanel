Class {
	#name : 'PanelFrameSwitcher',
	#superclass : 'PanelFrameHeader',
	#category : 'Panel',
	#package : 'Panel'
}

{ #category : 'private' }
PanelFrameSwitcher class >> gtkNew [

	^ self ffiCall: #(PanelFrameSwitcher *panel_frame_switcher_new (void))
]
