Class {
	#name : 'SpPanelAreaTop',
	#superclass : 'SpPanelArea',
	#category : 'Spec-Panel-Presenter',
	#package : 'Spec-Panel',
	#tag : 'Presenter'
}

{ #category : 'converting' }
SpPanelAreaTop >> asPanelArea [

	^ PanelArea PANEL_AREA_TOP
]

{ #category : 'converting' }
SpPanelAreaTop >> toPanelPosition [

	^ PanelPosition top
]
