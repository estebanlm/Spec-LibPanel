Extension { #name : 'SpAbstractPresenter' }

{ #category : '*Spec-Panel' }
SpAbstractPresenter >> asDockableWindow [

	^ DockPanelWindowPresenter presenter: self
]
