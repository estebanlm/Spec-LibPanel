Class {
	#name : 'PanelWorkbench',
	#superclass : 'GtkWidget',
	#traits : 'LibTPanel',
	#classTraits : 'LibTPanel classTrait',
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
