"
A manager for texts, they have some differences with the standar manager: 

- there is already a context menu, the actions we define add ""extras"" to it.
- the CR keybinding, if present, needs to be handled different (using the ""activate"" signal).
"
Class {
	#name : 'GtkAdapterActionPanelWidgetManager',
	#superclass : 'GtkAdapterActionManager',
	#category : 'Spec-Panel-Adapter',
	#package : 'Spec-Panel',
	#tag : 'Adapter'
}

{ #category : 'private' }
GtkAdapterActionPanelWidgetManager >> actions [

	^ self presenter actions
]

{ #category : 'accessing' }
GtkAdapterActionPanelWidgetManager >> hasContextMenu [

	^ true
]

{ #category : 'private - actions' }
GtkAdapterActionPanelWidgetManager >> installContextMenuOn: gtkWidget [

	hasContextMenu := true.	
	gtkWidget menuModel: (GtkActionMenuBuilder new visit: self actions)
]

{ #category : 'actions' }
GtkAdapterActionPanelWidgetManager >> installGroupsOn: gtkWidget [
		
	self presenter internalActions ifNotNil: [ :actionGroup |
		self installGroup: actionGroup on: gtkWidget ].
	self actions ifNotNil: [ :actionGroup |
		self installGroup: actionGroup on: gtkWidget ]
]

{ #category : 'actions' }
GtkAdapterActionPanelWidgetManager >> showContextMenu [

	self adapter innerWidgetDo: [ :w |
		w activateAction: 'menu.popup' ]
]
