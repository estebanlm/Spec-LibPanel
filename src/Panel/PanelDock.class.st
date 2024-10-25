Class {
	#name : 'PanelDock',
	#superclass : 'GtkWidget',
	#traits : 'LibTPanel',
	#classTraits : 'LibTPanel classTrait',
	#category : 'Panel',
	#package : 'Panel'
}

{ #category : 'private' }
PanelDock class >> gtkNew [

	^ self ffiCall: #(PanelDock *panel_dock_new #(void))
]

{ #category : 'instance creation' }
PanelDock class >> new [

	^ self gtkNew initialize
]

{ #category : 'signaling' }
PanelDock >> connectCreateFrame: aBlock [

	self 
		connect: 'create-frame' 
		signature: #(void* (void* handle, void* position, gpointer data)) 
		do: aBlock
]
