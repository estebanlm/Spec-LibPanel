"
https://gnome.pages.gitlab.gnome.org/libpanel/class.Grid.html
"
Class {
	#name : 'PanelGrid',
	#superclass : 'GtkWidget',
	#traits : 'LibTPanel',
	#classTraits : 'LibTPanel classTrait',
	#category : 'Panel',
	#package : 'Panel'
}

{ #category : 'private' }
PanelGrid class >> gtkNew [

	^ self ffiCall: #(PanelGrid* panel_grid_new (void))
]

{ #category : 'instance creation' }
PanelGrid class >> new [

	^ self gtkNew initialize
]

{ #category : 'signaling' }
PanelGrid >> connectCreateFrame: aBlock [

	self 
		connect: 'create-frame' 
		signature: #(void *( void *handle, gpointer user_data ))
		do: [ :self_handle :user_data | aBlock value ]
]
