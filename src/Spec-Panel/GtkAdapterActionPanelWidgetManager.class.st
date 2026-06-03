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

{ #category : 'private' }
GtkAdapterActionPanelWidgetManager >> activateActionName: aName onPanelWidget: panelWidgetHandle [
	| panelWidget |
	
	logger trace: aName.
	
	panelWidget := PanelWidget fromHandleUnowned: panelWidgetHandle. 
	panelWidget activateAction: aName
]

{ #category : 'actions' }
GtkAdapterActionPanelWidgetManager >> afterPlacedInstallActionGroup: anActionGroup on: aPanelDocumentWorkspace [
	| panelActionGroup panelGroupName |

	logger trace.
	
	panelGroupName := anActionGroup id.

	panelActionGroup := aPanelDocumentWorkspace actionGroups 
		at: panelGroupName
		ifAbsent: [ GSimpleActionGroup new ].
		
	anActionGroup entries 
		select: [ :eachAction | eachAction isCommand ]
		thenDo: [ :eachAction |
			panelActionGroup actions
				detect: [ :eachGAction | eachGAction name = eachAction id ]
				ifNone: [ 
					| newGAction |
					newGAction := (GSimpleAction newName: eachAction id type: GVariantType newUint64)
						connectActivate: [ :parameterHandle |
							| handle |
							handle := ExternalAddress fromAddress: (GVariant fromHandleUnowned: parameterHandle) getUint64.
							handle isNullOrNil ifFalse: [
								self 
									activateActionName: ('{1}.{2}' format: { panelGroupName. eachAction id })  
									onPanelWidget: handle ] ];
						yourself.
					panelActionGroup insert: newGAction ] ].
					
	(aPanelDocumentWorkspace hasActionGroupNamed: panelGroupName) ifFalse: [
		aPanelDocumentWorkspace insertActionGroup: panelGroupName actions: panelActionGroup ]
]

{ #category : 'actions' }
GtkAdapterActionPanelWidgetManager >> afterPlacedInstallOn: aPanelWindow [
	
	"self presenter internalActions ifNotNil: [ :actionGroup |
		self afterPlacedInstallActionGroup: actionGroup on: aPanelWindow ]."
	self actions ifNotNil: [ :actionGroup |
		self afterPlacedInstallActionGroup: actionGroup on: aPanelWindow ]
]

{ #category : 'accessing' }
GtkAdapterActionPanelWidgetManager >> hasContextMenu [

	^ true
]

{ #category : 'private - actions' }
GtkAdapterActionPanelWidgetManager >> installContextMenuOn: gtkWidget [

	hasContextMenu := true.	
	gtkWidget menuModel: ((self newActionMenuBuilderOn: gtkWidget) visit: self actions)
]

{ #category : 'actions' }
GtkAdapterActionPanelWidgetManager >> installGroupsOn: gtkWidget [
		
	self presenter internalActions ifNotNil: [ :actionGroup |
		self installGroup: actionGroup on: gtkWidget ].
	self actions ifNotNil: [ :actionGroup |
		self installGroup: actionGroup on: gtkWidget ]
]

{ #category : 'private - factory' }
GtkAdapterActionPanelWidgetManager >> newActionMenuBuilderOn: gtkWidget [
	
	logger trace: gtkWidget.
	
	^ GtkActionWithReferenceMenuBuilder new
		widget: gtkWidget;
		yourself
]

{ #category : 'actions' }
GtkAdapterActionPanelWidgetManager >> showContextMenu [

	self adapter innerWidgetDo: [ :w |
		w activateAction: 'menu.popup' ]
]
