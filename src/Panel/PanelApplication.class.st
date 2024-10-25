Class {
	#name : 'PanelApplication',
	#superclass : 'AdwApplication',
	#traits : 'LibTPanel',
	#classTraits : 'LibTPanel classTrait',
	#category : 'Panel',
	#package : 'Panel'
}

{ #category : 'private' }
PanelApplication class >> gtk_application_new: application_id flags: flags [

	^ self ffiCall: #(PanelApplication* panel_application_new (
		const char* application_id,
		GApplicationFlags flags))
]
