Class {
	#name : 'DockAreaBottom',
	#superclass : 'DockArea',
	#category : 'Spec-Panel-Presenter',
	#package : 'Spec-Panel',
	#tag : 'Presenter'
}

{ #category : 'converting' }
DockAreaBottom >> asPanelArea [

	^ PanelArea PANEL_AREA_BOTTOM
]

{ #category : 'converting' }
DockAreaBottom >> toPanelPosition [

	^ PanelPosition bottom
]
