Class {
	#name : 'SpPanelAreaStart',
	#superclass : 'SpPanelArea',
	#category : 'Spec-Panel-Presenter',
	#package : 'Spec-Panel',
	#tag : 'Presenter'
}

{ #category : 'converting' }
SpPanelAreaStart >> asPanelArea [

	^ PanelArea PANEL_AREA_START
]

{ #category : 'converting' }
SpPanelAreaStart >> toPanelPosition [

	^ PanelPosition start
]
