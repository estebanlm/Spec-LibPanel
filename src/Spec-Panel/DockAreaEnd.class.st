Class {
	#name : 'DockAreaEnd',
	#superclass : 'DockArea',
	#category : 'Spec-Panel-Base',
	#package : 'Spec-Panel',
	#tag : 'Base'
}

{ #category : 'converting' }
DockAreaEnd >> asPanelArea [

	^ PanelArea PANEL_AREA_END
]

{ #category : 'converting' }
DockAreaEnd >> asPanelPosition [

	^ PanelPosition end
]
