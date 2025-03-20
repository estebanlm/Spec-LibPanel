"
Base object for implementations of `PanelTFrameHeader`
"
Class {
	#name : 'PanelFrameHeader',
	#superclass : 'GtkWidget',
	#traits : 'LibTPanel + PanelTFrameHeader',
	#classTraits : 'LibTPanel classTrait + PanelTFrameHeader classTrait',
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
