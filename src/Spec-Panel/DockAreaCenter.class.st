Class {
	#name : 'DockAreaCenter',
	#superclass : 'DockArea',
	#category : 'Spec-Panel-Presenter',
	#package : 'Spec-Panel',
	#tag : 'Presenter'
}

{ #category : 'converting' }
DockAreaCenter >> asPanelArea [

	^ PanelArea PANEL_AREA_CENTER
]

{ #category : 'converting' }
DockAreaCenter >> toPanelPosition [

	^ PanelPosition center
]
