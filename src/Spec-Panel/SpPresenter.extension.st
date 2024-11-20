Extension { #name : 'SpPresenter' }

{ #category : '*Spec-Panel' }
SpPresenter >> dockableWindow [
	"as 'window', but answers the tiled window"
	self isDockableWindow ifTrue: [ ^ self ].
	self hasOwner ifTrue: [ ^ self owner tileWindow ].
	^ nil
]

{ #category : '*Spec-Panel' }
SpPresenter >> isDockableWindow [
	
	^ false
]

{ #category : '*Spec-Panel' }
SpPresenter >> withDockableWindowDo: aBlock [

	^ self dockableWindow ifNotNil: aBlock
]
