"
https://gnome.pages.gitlab.gnome.org/libpanel/panel-1.0/class.Grid.html
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

{ #category : 'private' }
PanelGrid >> basicForEachFrame: callback [

	self ffiCall: #(void panel_grid_foreach_frame (
		self,
  		"PanelFrameCallback"GCallback callback,
  		"gpointer user_data"NULL))
]

{ #category : 'signaling' }
PanelGrid >> connectCreateFrame: aBlock [

	self 
		connect: 'create-frame' 
		signature: #(void *( void *handle, gpointer user_data ))
		do: [ :self_handle :user_data | aBlock value ]
]

{ #category : 'enumerating' }
PanelGrid >> forEachFrameDo: aBlock [ 
	| callback |
	
	callback := GCallback 
		signature: #(void (void *frameHandle, gpointer user_data)) 
		block: [ :frameHandle :user_data |
			aBlock value: (PanelFrame fromHandleUnowned: frameHandle) ].
		
	self basicForEachFrame: callback
]
