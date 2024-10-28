Class {
	#name : 'DockAreaStart',
	#superclass : 'DockArea',
	#category : 'Spec-Panel-Base',
	#package : 'Spec-Panel',
	#tag : 'Base'
}

{ #category : 'converting' }
DockAreaStart >> asPanelArea [

	^ PanelArea PANEL_AREA_START
]

{ #category : 'converting' }
DockAreaStart >> asPanelPosition [

	^ PanelPosition start
]
