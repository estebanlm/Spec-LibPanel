Class {
	#name : 'SpPanelToast',
	#superclass : 'Object',
	#instVars : [
		'title'
	],
	#category : 'Spec-Panel-Presenter',
	#package : 'Spec-Panel',
	#tag : 'Presenter'
}

{ #category : 'converting' }
SpPanelToast >> asAdwToast [

	^ AdwToast newTitle: (self title ifNil: [ 'Unnamed' ])
]

{ #category : 'accessing' }
SpPanelToast >> title [

	^ title
]

{ #category : 'accessing' }
SpPanelToast >> title: aString [

	title := aString
]
