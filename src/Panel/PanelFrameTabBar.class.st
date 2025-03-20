Class {
	#name : 'PanelFrameTabBar',
	#superclass : 'PanelFrameHeader',
	#category : 'Panel',
	#package : 'Panel'
}

{ #category : 'private' }
PanelFrameTabBar class >> gtkNew [

	^ self ffiCall: #(PanelFrameTabBar *panel_frame_tab_bar_new (void))
]
