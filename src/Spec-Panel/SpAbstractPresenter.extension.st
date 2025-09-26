Extension { #name : 'SpAbstractPresenter' }

{ #category : '*Spec-Panel' }
SpAbstractPresenter >> asDockableWindow [
	
	self owner ifNil: [ 
		self error: 'Dockable presenter should have an owner' ].
	
	^ (SpPanelWidgetPresenter owner: self owner)
		presenter: self;
		yourself
]
