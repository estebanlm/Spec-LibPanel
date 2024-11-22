Extension { #name : 'SpPresenter' }

{ #category : '*Spec-Panel' }
SpPresenter >> isPanelWindow [
	
	^ false
]

{ #category : '*Spec-Panel' }
SpPresenter >> panelWindow [
	"as 'window', but answers the tiled window"
	self isPanelWindow ifTrue: [ ^ self ].
	self hasOwner ifTrue: [ ^ self owner panelWindow ].
	^ nil
]

{ #category : '*Spec-Panel' }
SpPresenter >> withPanelWindowDo: aBlock [

	^ self panelWindow ifNotNil: aBlock
]
