Class {
	#name : 'DockAreaBottom',
	#superclass : 'DockArea',
	#category : 'Spec-Panel-Base',
	#package : 'Spec-Panel',
	#tag : 'Base'
}

{ #category : 'converting' }
DockAreaBottom >> asPanelArea [

	^ PanelArea PANEL_AREA_BOTTOM
]

{ #category : 'converting' }
DockAreaBottom >> asPanelPosition [

	^ PanelPosition bottom
]
