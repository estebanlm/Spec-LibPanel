Extension { #name : 'SpAbstractPresenter' }

{ #category : '*Spec-Panel' }
SpAbstractPresenter >> asDockableWindow [

	^ DockDockableWindowPresenter presenter: self
]
