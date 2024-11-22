Class {
	#name : 'DockAreaEnd',
	#superclass : 'DockArea',
	#category : 'Spec-Panel-Presenter',
	#package : 'Spec-Panel',
	#tag : 'Presenter'
}

{ #category : 'converting' }
DockAreaEnd >> asPanelArea [

	^ PanelArea PANEL_AREA_END
]

{ #category : 'converting' }
DockAreaEnd >> toPanelPosition [

	^ PanelPosition end
]
