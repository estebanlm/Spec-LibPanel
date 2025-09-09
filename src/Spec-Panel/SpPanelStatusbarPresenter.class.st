"
A presenter to model the statusbar that is included in `SpPanelWindowPresenter`. 
IT CANNOT BE INSTANTIATED BY ITSELF!

This presenter can just be accessed through `SpPanelWindowPresenter>>#statusbar`

"
Class {
	#name : 'SpPanelStatusbarPresenter',
	#superclass : 'SpAbstractWidgetPresenter',
	#instVars : [
		'prefixPresenters',
		'suffixPresenters'
	],
	#category : 'Spec-Panel-Presenter',
	#package : 'Spec-Panel',
	#tag : 'Presenter'
}

{ #category : 'specs' }
SpPanelStatusbarPresenter class >> adapterName [

	^ #PanelStatusbarAdapter
]

{ #category : 'api' }
SpPanelStatusbarPresenter >> addPrefix: aPresenter [

	aPresenter owner: self.
	prefixPresenters add: aPresenter
]

{ #category : 'api' }
SpPanelStatusbarPresenter >> addSuffix: aPresenter [

	aPresenter owner: self.
	suffixPresenters add: aPresenter
	
]

{ #category : 'initialization' }
SpPanelStatusbarPresenter >> initialize [

	super initialize.
	prefixPresenters := OrderedCollection new asValueHolder.
	suffixPresenters := OrderedCollection new asValueHolder.
	
	self whenPrefixAddedDo: [ :aPresenter | 
		self withAdapterDo: [ :anAdapter | 
			anAdapter addPrefix: aPresenter ] ].
			
	self whenSuffixAddedDo: [ :aPresenter | 
		self withAdapterDo: [ :anAdapter | 
			anAdapter addSuffix: aPresenter ] ].
			
	self whenRemovedDo: [ :aPresenter | 
		self withAdapterDo: [ :anAdapter | 
			anAdapter remove: aPresenter ] ]
]

{ #category : 'api' }
SpPanelStatusbarPresenter >> prefixPresenters [

	^ prefixPresenters value
]

{ #category : 'api' }
SpPanelStatusbarPresenter >> remove: aPresenter [

	prefixPresenters remove: aPresenter ifAbsent: [ ].
	suffixPresenters remove: aPresenter ifAbsent: [ ]
]

{ #category : 'api' }
SpPanelStatusbarPresenter >> removeAll [

	self application defer: [
		prefixPresenters value copy 
			do: [ :each | prefixPresenters remove: each ].
		suffixPresenters value copy 
			do: [ :each | suffixPresenters remove: each ] ]
]

{ #category : 'api' }
SpPanelStatusbarPresenter >> suffixPresenters [

	^ suffixPresenters value
]

{ #category : 'api - events' }
SpPanelStatusbarPresenter >> whenPrefixAddedDo: aBlock [ 

	prefixPresenters whenAddedDo: aBlock
]

{ #category : 'api - events' }
SpPanelStatusbarPresenter >> whenRemovedDo: aBlock [ 

	prefixPresenters whenRemovedDo: aBlock.	
	suffixPresenters whenRemovedDo: aBlock
]

{ #category : 'api - events' }
SpPanelStatusbarPresenter >> whenSuffixAddedDo: aBlock [ 

	suffixPresenters whenAddedDo: aBlock
]
