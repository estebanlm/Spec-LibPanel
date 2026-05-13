Extension { #name : 'SpPresenter' }

{ #category : '*Spec-Panel' }
SpPresenter >> initializePanelWidget: aPanelWidgetPresenter [
	"override to add PanelWindow specific settings"
]

{ #category : '*Spec-Panel' }
SpPresenter >> isPanelWidget [
	
	^ false
]

{ #category : '*Spec-Panel' }
SpPresenter >> panelWidget [
	"as 'window', but answers the tiled window"
	self isPanelWidget ifTrue: [ ^ self ].
	self hasOwner ifTrue: [ ^ self owner panelWidget ].
	^ nil
]

{ #category : '*Spec-Panel' }
SpPresenter >> withPanelWidgetDo: aBlock [

	^ self panelWidget ifNotNil: aBlock
]
