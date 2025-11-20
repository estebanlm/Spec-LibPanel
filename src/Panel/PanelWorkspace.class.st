"
https://gnome.pages.gitlab.gnome.org/libpanel/panel-1.0/class.Workspace.html
"
Class {
	#name : 'PanelWorkspace',
	#superclass : 'AdwApplicationWindow',
	#traits : 'LibTPanel',
	#classTraits : 'LibTPanel classTrait',
	#category : 'Panel',
	#package : 'Panel'
}

{ #category : 'instance creation' }
PanelWorkspace class >> gType [

	^ self ffiCall: #(gsize panel_workspace_get_type())
]

{ #category : 'instance creation' }
PanelWorkspace class >> new [

	^ GObject gObjectNew: self gType
]
