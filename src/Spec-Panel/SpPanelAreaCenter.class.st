Class {
	#name : 'SpPanelAreaCenter',
	#superclass : 'SpPanelArea',
	#category : 'Spec-Panel-Presenter',
	#package : 'Spec-Panel',
	#tag : 'Presenter'
}

{ #category : 'converting' }
SpPanelAreaCenter >> asPanelArea [

	^ PanelArea PANEL_AREA_CENTER
]

{ #category : 'converting' }
SpPanelAreaCenter >> toPanelPosition [

	^ PanelPosition center
]
