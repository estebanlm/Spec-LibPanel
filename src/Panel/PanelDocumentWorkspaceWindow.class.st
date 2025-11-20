"
As PanelDocumentWorkspace is an abstract class of libpanel, we require a concrete implementation (which is this one).

"
Class {
	#name : 'PanelDocumentWorkspaceWindow',
	#superclass : 'PanelDocumentWorkspace',
	#traits : 'GTClass',
	#classTraits : 'GTClass classTrait',
	#category : 'Panel',
	#package : 'Panel'
}

{ #category : 'signaling' }
PanelDocumentWorkspaceWindow >> connectCreateFrame: aBlock [

	self 
		connect: 'create-frame' 
		signature: #(void* (void* selfHandle, void* position, gpointer user_data)) 
		do: [ :self_handle :position :user_data |
			aBlock value: (PanelPosition fromHandleUnreferenced: position) ]
]
