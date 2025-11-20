"
https://gnome.pages.gitlab.gnome.org/libpanel/panel-1.0/class.Workbench.html
"
Class {
	#name : 'PanelWorkbench',
	#superclass : 'GtkWindowGroup',
	#traits : 'LibTPanel',
	#classTraits : 'LibTPanel classTrait',
	#instVars : [
		'workspaces'
	],
	#category : 'Panel',
	#package : 'Panel'
}

{ #category : 'instance creation' }
PanelWorkbench class >> new [

	^ self panel_workbench_new initialize
]

{ #category : 'private' }
PanelWorkbench class >> panel_workbench_new [

	^ self ffiCall: #(PanelWorkbench* panel_workbench_new (void))
]

{ #category : 'accessing' }
PanelWorkbench >> addWorkspace: aWorkspace [

	self keepWorkspace: aWorkspace.
	self basicAddWorkspace: aWorkspace
]

{ #category : 'private' }
PanelWorkbench >> basicAddWorkspace: workspace [

	self ffiCall: #(void panel_workbench_add_workspace (self, PanelWorkspace* workspace))



]

{ #category : 'accessing' }
PanelWorkbench >> focusWorkspace: workspace [

	self ffiCall: #(void panel_workbench_focus_workspace (self, PanelWorkspace* workspace))
]

{ #category : 'initialization' }
PanelWorkbench >> initialize [

	super initialize.
	workspaces := #()
]

{ #category : 'private' }
PanelWorkbench >> keepWorkspace: aWorkspace [

	workspaces := workspaces copyWith: aWorkspace
]
