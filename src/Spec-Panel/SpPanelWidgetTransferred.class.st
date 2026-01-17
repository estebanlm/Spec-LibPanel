"
Announced when the PanelWidget has been transferred from one window to another.
"
Class {
	#name : 'SpPanelWidgetTransferred',
	#superclass : 'Announcement',
	#instVars : [
		'fromWindow',
		'toWindow'
	],
	#category : 'Spec-Panel-Announcement',
	#package : 'Spec-Panel',
	#tag : 'Announcement'
}

{ #category : 'instance creation' }
SpPanelWidgetTransferred class >> from: aWindow to: anotherWindow [

	^ self new 
		from: aWindow to: anotherWindow;
		yourself
]

{ #category : 'initialization' }
SpPanelWidgetTransferred >> from: aWindow to: anotherWindow [

	fromWindow := aWindow.
	toWindow := anotherWindow
]

{ #category : 'accessing' }
SpPanelWidgetTransferred >> fromWindow [

	^ fromWindow
]

{ #category : 'accessing' }
SpPanelWidgetTransferred >> toWindow [

	^ toWindow
]
