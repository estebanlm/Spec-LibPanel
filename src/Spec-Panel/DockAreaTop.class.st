Class {
	#name : 'DockAreaTop',
	#superclass : 'DockArea',
	#category : 'Spec-Panel-Base',
	#package : 'Spec-Panel',
	#tag : 'Base'
}

{ #category : 'converting' }
DockAreaTop >> asPanelArea [

	^ PanelArea PANEL_AREA_TOP
]

{ #category : 'converting' }
DockAreaTop >> asPanelPosition [

	^ PanelPosition top
]
