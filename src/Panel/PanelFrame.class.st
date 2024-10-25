Class {
	#name : 'PanelFrame',
	#superclass : 'GtkWidget',
	#traits : 'LibTPanel',
	#classTraits : 'LibTPanel classTrait',
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
