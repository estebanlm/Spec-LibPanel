Class {
	#name : 'DockAreaTop',
	#superclass : 'DockArea',
	#category : 'Spec-Panel-Presenter',
	#package : 'Spec-Panel',
	#tag : 'Presenter'
}

{ #category : 'converting' }
DockAreaTop >> asPanelArea [

	^ PanelArea PANEL_AREA_TOP
]

{ #category : 'converting' }
DockAreaTop >> toPanelPosition [

	^ PanelPosition top
]
