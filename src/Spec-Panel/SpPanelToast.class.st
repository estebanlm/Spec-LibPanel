Class {
	#name : 'SpPanelToast',
	#superclass : 'Object',
	#instVars : [
		'title',
		'action',
		'actionLabel',
		'timeout'
	],
	#category : 'Spec-Panel-Presenter',
	#package : 'Spec-Panel',
	#tag : 'Presenter'
}

{ #category : 'accessing' }
SpPanelToast >> action [

	^ action
]

{ #category : 'accessing' }
SpPanelToast >> action: aBlock [

	action := aBlock
]

{ #category : 'accessing' }
SpPanelToast >> actionLabel [

	^ actionLabel
]

{ #category : 'accessing' }
SpPanelToast >> actionLabel: aString [

	actionLabel := aString
]

{ #category : 'accessing' }
SpPanelToast >> timeout [ 

	^ timeout
]

{ #category : 'accessing' }
SpPanelToast >> timeout: seconds [ 
	"0 - infinite"

	timeout := seconds
]

{ #category : 'accessing' }
SpPanelToast >> title [

	^ title
]

{ #category : 'accessing' }
SpPanelToast >> title: aString [

	title := aString
]
