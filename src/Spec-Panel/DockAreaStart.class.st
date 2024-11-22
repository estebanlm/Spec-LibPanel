Class {
	#name : 'DockAreaStart',
	#superclass : 'DockArea',
	#category : 'Spec-Panel-Presenter',
	#package : 'Spec-Panel',
	#tag : 'Presenter'
}

{ #category : 'converting' }
DockAreaStart >> asPanelArea [

	^ PanelArea PANEL_AREA_START
]

{ #category : 'converting' }
DockAreaStart >> toPanelPosition [

	^ PanelPosition start
]
