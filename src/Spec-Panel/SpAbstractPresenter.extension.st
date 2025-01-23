Extension { #name : 'SpAbstractPresenter' }

{ #category : '*Spec-Panel' }
SpAbstractPresenter >> asDockableWindow [

	^ DockPanelPresenter presenter: self
]
