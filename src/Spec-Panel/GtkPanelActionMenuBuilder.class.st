"
creates a `GMenu` from the defined actions and groups. 
"
Class {
	#name : 'GtkPanelActionMenuBuilder',
	#superclass : 'GtkActionVisitor',
	#instVars : [
		'menu',
		'root'
	],
	#category : 'Spec-Panel-Adapter',
	#package : 'Spec-Panel',
	#tag : 'Adapter'
}

{ #category : 'private' }
GtkPanelActionMenuBuilder >> allPrefixes [
	"| allPrefixes |

	allPrefixes := super allPrefixes.
	allPrefixes isEmptyOrNil ifTrue: [ ^ allPrefixes ].
	
	^ allPrefixes first 
		ifNotNil: [ allPrefixes allButFirst ]
		ifNil: [ allPrefixes ]"
	^ super allPrefixes
]

{ #category : 'visiting' }
GtkPanelActionMenuBuilder >> appendSection: aMenu label: aName to: parentMenu [
	
	parentMenu 
		appendLabel: nil
		section: menu
]

{ #category : 'visiting' }
GtkPanelActionMenuBuilder >> appendSubmenu: aMenu label: aName to: parentMenu [
	
	parentMenu 
		appendLabel: aName 
		submenu: menu
]

{ #category : 'accessing' }
GtkPanelActionMenuBuilder >> root [

	^ root
]

{ #category : 'visiting' }
GtkPanelActionMenuBuilder >> visit: anObject [

	root := GMenu new.
	super visit: anObject.
	^ root
]

{ #category : 'visiting' }
GtkPanelActionMenuBuilder >> visitCommand: aCommand [
	
	aCommand isVisible ifFalse: [ ^ self ].
	(self actionNameFor: aCommand) crTrace.
	menu 
		appendLabel: aCommand dynamicName 
		actionName: (self actionNameFor: aCommand)
]

{ #category : 'visiting' }
GtkPanelActionMenuBuilder >> visitCommandGroup: aCommandGroup [
	| oldMenu |
	
	oldMenu := menu.
	menu := menu 
		ifNotNil: [ GMenu new ]
		ifNil: [ root ].
	[ 
		super visitCommandGroup: aCommandGroup.
	  	oldMenu ifNotNil: [
			aCommandGroup displayStrategy 
				appendGroup: menu 
				label: aCommandGroup name
				to: oldMenu
				in: self ]
	]	
	ensure: [ 
		menu := oldMenu ]
]
