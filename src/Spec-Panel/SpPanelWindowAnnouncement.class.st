Class {
	#name : 'SpPanelWindowAnnouncement',
	#superclass : 'Announcement',
	#instVars : [
		'success'
	],
	#category : 'Spec-Panel-Announcement',
	#package : 'Spec-Panel',
	#tag : 'Announcement'
}

{ #category : 'accessing' }
SpPanelWindowAnnouncement >> beFailed [

	self success: false
]

{ #category : 'accessing' }
SpPanelWindowAnnouncement >> beSuccess [

	self success: true
]

{ #category : 'initialization' }
SpPanelWindowAnnouncement >> initialize [

	super initialize.
	success := true
]

{ #category : 'testing' }
SpPanelWindowAnnouncement >> isFailed [

	^ self isSuccess not
]

{ #category : 'testing' }
SpPanelWindowAnnouncement >> isSuccess [

	^ success
]

{ #category : 'accessing' }
SpPanelWindowAnnouncement >> success: aBoolean [

	success := aBoolean
]
