Class {
	#name : 'PanelArea',
	#superclass : 'GEnumeration',
	#classVars : [
		'PANEL_AREA_BOTTOM',
		'PANEL_AREA_CENTER',
		'PANEL_AREA_END',
		'PANEL_AREA_START',
		'PANEL_AREA_TOP'
	],
	#category : 'Panel',
	#package : 'Panel'
}

{ #category : 'accessing enum' }
PanelArea class >> PANEL_AREA_BOTTOM [
	"This method was automatically generated"
	^ PANEL_AREA_BOTTOM
]

{ #category : 'accessing enum' }
PanelArea class >> PANEL_AREA_CENTER [
	"This method was automatically generated"
	^ PANEL_AREA_CENTER
]

{ #category : 'accessing enum' }
PanelArea class >> PANEL_AREA_END [
	"This method was automatically generated"
	^ PANEL_AREA_END
]

{ #category : 'accessing enum' }
PanelArea class >> PANEL_AREA_START [
	"This method was automatically generated"
	^ PANEL_AREA_START
]

{ #category : 'accessing enum' }
PanelArea class >> PANEL_AREA_TOP [
	"This method was automatically generated"
	^ PANEL_AREA_TOP
]

{ #category : 'enum declaration' }
PanelArea class >> enumDecl [
	"
	self initializeEnumeration.
	self rebuildEnumAccessors"

	^ #(
	PANEL_AREA_START     0
	PANEL_AREA_END       1
	PANEL_AREA_TOP       2
	PANEL_AREA_BOTTOM    3
	PANEL_AREA_CENTER    4
	)
]
