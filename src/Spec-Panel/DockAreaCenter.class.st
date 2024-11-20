Class {
	#name : 'DockAreaCenter',
	#superclass : 'DockArea',
	#category : 'Spec-Panel-Base',
	#package : 'Spec-Panel',
	#tag : 'Base'
}

{ #category : 'converting' }
DockAreaCenter >> asPanelArea [

	^ PanelArea PANEL_AREA_CENTER
]

{ #category : 'converting' }
DockAreaCenter >> toPanelPosition [

	^ PanelPosition center
]
