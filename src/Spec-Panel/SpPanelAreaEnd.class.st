Class {
	#name : 'SpPanelAreaEnd',
	#superclass : 'SpPanelArea',
	#category : 'Spec-Panel-Presenter',
	#package : 'Spec-Panel',
	#tag : 'Presenter'
}

{ #category : 'visiting' }
SpPanelAreaEnd >> accept: aVisitor [

	^ aVisitor visitEnd: self 
]

{ #category : 'converting' }
SpPanelAreaEnd >> asPanelArea [

	^ PanelArea PANEL_AREA_END
]

{ #category : 'converting' }
SpPanelAreaEnd >> toPanelPosition [

	^ PanelPosition end
]
