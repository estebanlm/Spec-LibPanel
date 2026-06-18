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
GtkAdapterActionPanelWidgetManager >> afterPlacedInstallActionGroupShortcuts: actionGroup on: aPanelWindow [

	logger trace.

	actionGroup allCommands 
		select: [ :each | each hasShortcutKey ]
		thenDo: [ :each | 
			self 
				maybeAddShortcutForCommand: each 
				ofGroup: actionGroup
				to: aPanelWindow ]
]

{ #category : 'actions' }
GtkAdapterActionPanelWidgetManager >> afterPlacedInstallOn: aPanelWindow [
	
	"self presenter internalActions ifNotNil: [ :actionGroup |
		self afterPlacedInstallActionGroup: actionGroup on: aPanelWindow ]."
	self actions ifNotNil: [ :actionGroup |
		self afterPlacedInstallActionGroup: actionGroup on: aPanelWindow. 
		self afterPlacedInstallActionGroupShortcuts: actionGroup on: aPanelWindow ]
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

{ #category : 'private' }
GtkAdapterActionPanelWidgetManager >> maybeAddShortcutForCommand: aCommand ofGroup: actionGroup to: aPanelWindow [
	| shortcut actionName |

	logger trace: aCommand.

	actionName := '{1}.{2}' format: { actionGroup id. aCommand id }.
	logger debug: actionName.
	aPanelWindow addGlobalShortcutControllerWith: [ :aController |
		(aController includesShortcutToActionNamed: actionName) not
			ifTrue: [
				logger debug: 'ADDING'.
				aCommand shortcutKey withAllKeyCombinationsDo: [ :aKeyCombination |
					aKeyCombination isForPlatform ifTrue: [  
						shortcut := GtkShortcut 
							newKeyCombination: aKeyCombination 
							actionName: actionName.
						aController addShortcut: shortcut ] ] ]
			ifFalse: [
				logger debug: 'SKIPPING' ] ]
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
