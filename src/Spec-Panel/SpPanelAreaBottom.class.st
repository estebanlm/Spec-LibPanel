Class {
	#name : 'SpPanelAreaBottom',
	#superclass : 'SpPanelArea',
	#category : 'Spec-Panel-Presenter',
	#package : 'Spec-Panel',
	#tag : 'Presenter'
}

{ #category : 'converting' }
SpPanelAreaBottom >> asPanelArea [

	^ PanelArea PANEL_AREA_BOTTOM
]

{ #category : 'converting' }
SpPanelAreaBottom >> toPanelPosition [

	^ PanelPosition bottom
]
