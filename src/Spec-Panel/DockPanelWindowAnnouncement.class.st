Class {
	#name : 'DockPanelWindowAnnouncement',
	#superclass : 'Announcement',
	#instVars : [
		'success'
	],
	#category : 'Spec-Panel-Announcement',
	#package : 'Spec-Panel',
	#tag : 'Announcement'
}

{ #category : 'accessing' }
DockPanelWindowAnnouncement >> beFailed [

	self success: false
]

{ #category : 'accessing' }
DockPanelWindowAnnouncement >> beSuccess [

	self success: true
]

{ #category : 'initialization' }
DockPanelWindowAnnouncement >> initialize [

	super initialize.
	success := true
]

{ #category : 'testing' }
DockPanelWindowAnnouncement >> isFailed [

	^ self isSuccess not
]

{ #category : 'testing' }
DockPanelWindowAnnouncement >> isSuccess [

	^ success
]

{ #category : 'accessing' }
DockPanelWindowAnnouncement >> success: aBoolean [

	success := aBoolean
]
