"
A presenter to model the statusbar that is included in `SpPanelWindowPresenter`. 
This presenter can be accessed through `SpPanelWindowPresenter>>#statusbar`

"
Class {
	#name : 'SpPanelStatusbarPresenter',
	#superclass : 'SpAbstractWidgetPresenter',
	#instVars : [
		'#prefixPresenters',
		'#suffixPresenters',
		'#messagePresenter => ProcessLocalSlot',
		'#messageQueue',
		'#ownerPanelWindow'
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

{ #category : 'api' }
SpPanelStatusbarPresenter >> clearMessage [
	
	messagePresenter ifNil: [ ^ self ].
	
	self remove: messagePresenter.
	messagePresenter := nil.
	"flush it"
	[ self messageQueue nextOrNil isNil ] whileFalse
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

{ #category : 'private' }
SpPanelStatusbarPresenter >> messagePresenter [

	messagePresenter ifNil: [
		messagePresenter := self newLabel.
		self addPrefix: messagePresenter ].

	^ messagePresenter
]

{ #category : 'private' }
SpPanelStatusbarPresenter >> messageQueue [
		
	^ messageQueue ifNil:[ messageQueue := LIFOQueue new ]
]

{ #category : 'api' }
SpPanelStatusbarPresenter >> ownerPanelWindow [
	"statusbar can be already instantiated on a panel window. 
	 If this value is set, the adapter build will try to take it from the panel window itself
	 instead trying to create a new one."
	
	^ ownerPanelWindow
]

{ #category : 'api' }
SpPanelStatusbarPresenter >> ownerPanelWindow: aPanelWindowPresenter [
	"statusbar can be already instantiated on a panel window. 
	 If this value is set, the adapter build will try to take it from the panel window itself
	 instead trying to create a new one."
	
	ownerPanelWindow := aPanelWindowPresenter
]

{ #category : 'api' }
SpPanelStatusbarPresenter >> popMessage [
	"a convenuence method to push messages in the status bar"
	| nextMessage |
	
	messagePresenter ifNil: [ ^ self ].
	
	nextMessage := self messageQueue nextOrNil.
	nextMessage
		ifNotNil: [ self messagePresenter label: nextMessage ]
		ifNil: [ self clearMessage ]
]

{ #category : 'api' }
SpPanelStatusbarPresenter >> prefixPresenters [

	^ prefixPresenters value
]

{ #category : 'api' }
SpPanelStatusbarPresenter >> pushMessage: aString [
	"a convenuence method to push messages in the status bar"
	
	self messagePresenter label: (self messageQueue push: aString)
]

{ #category : 'api' }
SpPanelStatusbarPresenter >> remove: aPresenter [

	(prefixPresenters includes: aPresenter) 
		ifTrue: [ prefixPresenters remove: aPresenter ].
	(suffixPresenters includes: aPresenter) 
		ifTrue: [ suffixPresenters remove: aPresenter ]
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
SpPanelStatusbarPresenter >> restoreMessage [
	| lastMessage |

	lastMessage := self messageQueue peek.
	lastMessage ifNil: [ ^ self ].
	
	self labelPresenter label: lastMessage
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
