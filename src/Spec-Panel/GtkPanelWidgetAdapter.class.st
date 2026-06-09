"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  State a one line summary. For example, ""I represent a paragraph of text"".

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them.

Public API and Key Messages

- message one
- message two
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.

Internal Representation and Key Implementation Points.


    Implementation Points
"
Class {
	#name : 'GtkPanelWidgetAdapter',
	#superclass : 'GtkAdapter',
	#instVars : [
		'deferredActions'
	],
	#category : 'Spec-Panel-Adapter',
	#package : 'Spec-Panel',
	#tag : 'Adapter'
}

{ #category : 'private - building' }
GtkPanelWidgetAdapter >> addActionsTo: gtkWindow [

	super addActionsTo: gtkWindow.
	"this part is now defined at the presenter level (which is where it belongs)"
	"self addDefaultKeyBindings: gtkWindow"
]

{ #category : 'private - building' }
GtkPanelWidgetAdapter >> addDefaultKeyBindings: gtkWindow [
	| actionGroup |
	
	actionGroup := self defaultActionGroup.
	actionGroup ifNil: [ ^ self ].

	self ensureActionManager
		installGroup: actionGroup 
		on: gtkWindow
]

{ #category : 'accessing' }
GtkPanelWidgetAdapter >> addDeferredAction: aBlock [

	deferredActions ifNil: [ deferredActions := #() ].
	deferredActions := deferredActions copyWith: aBlock
]

{ #category : 'private' }
GtkPanelWidgetAdapter >> addModelTo: panelWidget [
	| childWidget |
	
	"panels are maximizable by default"
	panelWidget canMaximize: true.

	panelWidget saveDelegate: (PanelSaveDelegate new
		title: self presenter title;
		connectSave: [ self runInSystem: [ self announceSave ] ];
		connectDiscard: [ self runInSystem: [ self announceDiscard ] ];
		connectClose: [ self announceClosed ];
		yourself).
	panelWidget connectDestroy: [ self runInSystem: [ self widgetDestroyed ] ].

	childWidget := SpBindings 
		value: self presenter application adapterBindings 
		during: [ self presenter presenter build ].

	panelWidget
		title: self presenter title;
		child: childWidget.

	self presenter windowIcon 
		ifNotNil: [ :aForm | panelWidget icon: (aForm asGdkPaintableOnApplication: self presenter application) ]. 
	
	"Events"
	panelWidget
		connectPresented: [ self presented ];
		addFocusEnterEvent: [ :event | self runInSystem: [ self announceFocusEnter ] ];
		addFocusLeaveEvent: [ :event | self runInSystem: [ self announceFocusLeave ] ].

	self presenter isPinned ifTrue: [ 
		"this needs to be deferred because in fact, there pinned action lives at the 
		 parent (a PanelFrame), so we need to wait until the widget is placed"
		self addDeferredAction: [ panelWidget pinned: true ] ].
	self presenter whenPinnedChangedDo: [ :aBoolean | self updatePinnedTo: aBoolean ].
	self presenter isModified ifTrue: [ panelWidget modified: true ].
	self presenter whenModifiedChangedDo: [ :aBoolean | self updateModifiedTo: aBoolean ].

	self presenter whenWindowIconChangedDo: [ :aForm | self updateWindowIconTo: aForm ]
]

{ #category : 'private - announcing' }
GtkPanelWidgetAdapter >> announceClosed [

	"already announced?"
	self presenter isClosed ifTrue: [ ^ self ].
	
	logger trace.

	self innerWidget getHandle beNull.
	
	self runInSystem: [ 
		self presenter windowClosed ]
]

{ #category : 'private - announcing' }
GtkPanelWidgetAdapter >> announceDiscard [
	| ann |

	ann := SpPanelWindowDiscard new.
	self presenter announce: ann.
	ann isSuccess ifTrue: [ 
		self forceClose ]
]

{ #category : 'private - announcing' }
GtkPanelWidgetAdapter >> announceFocusEnter [

	self presenter announce: (SpPanelWindowFocusReceived new 
		window: self presenter;
		yourself)
]

{ #category : 'private - announcing' }
GtkPanelWidgetAdapter >> announceFocusLeave [

	self presenter announce: (SpPanelWindowFocusLost new 
		window: self presenter;
		yourself)
]

{ #category : 'private - announcing' }
GtkPanelWidgetAdapter >> announcePresented [

	self presenter announce: (SpPanelWindowPresented new 
		window: self presenter;
		yourself)
]

{ #category : 'private - announcing' }
GtkPanelWidgetAdapter >> announceSave [
	| ann |

	ann := SpPanelWindowSave new.
	self presenter announce: ann.
	ann isSuccess ifTrue: [ 
		self forceClose ]
]

{ #category : 'accessing' }
GtkPanelWidgetAdapter >> close [

	self performClose: #close
]

{ #category : 'accessing' }
GtkPanelWidgetAdapter >> closeFromKeyboard [

	self close
]

{ #category : 'private' }
GtkPanelWidgetAdapter >> contentWidget [

	^ self presenter presenter adapter widget
]

{ #category : 'private - building' }
GtkPanelWidgetAdapter >> defaultActionGroup [
		
	^ SpActionGroup new 
		name: 'adapterWindowActions';
		addActionWith: [ :action | action 
			name: 'closeWindow';
			shortcutKey: $w actionModifier;
			action: [ self closeFromKeyboard ] ];
		yourself
]

{ #category : 'private' }
GtkPanelWidgetAdapter >> forceClose [

	self performClose: #forceClose
]

{ #category : 'accessing' }
GtkPanelWidgetAdapter >> markBusy [

	self widgetDo: [ :w | w markBusy ]
]

{ #category : 'accessing' }
GtkPanelWidgetAdapter >> maximize [

	self widgetDo: [ :w | w maximize ]
]

{ #category : 'testing' }
GtkPanelWidgetAdapter >> needsAttention [

	^ self widgetDo: [ :w | w needsAttention ]
]

{ #category : 'accessing' }
GtkPanelWidgetAdapter >> needsAttention: aBoolean [

	self widgetDo: [ :w | w needsAttention: aBoolean ]
]

{ #category : 'private - actions' }
GtkPanelWidgetAdapter >> newActionManager [

	^ GtkAdapterActionPanelWidgetManager on: self
]

{ #category : 'private' }
GtkPanelWidgetAdapter >> performClose: aSelector [

	logger trace: aSelector.

	self widgetDo: [ :w | 
		"it may be that somehow somehow this has already been done 
		 (if everything is fine, and close has already been done, handle should be NULL now)"
		w isValidHandle ifTrue: [ 
			w perform: aSelector ] ].
	
	"apparently force close is not triggering the close element"
	aSelector == #forceClose
		ifTrue: [ self announceClosed ]
]

{ #category : 'private' }
GtkPanelWidgetAdapter >> presented [
	
	self updateParent.
	self updatePosition.
	self runInSystem: [
		self announcePresented ]
]

{ #category : 'private - deferring' }
GtkPanelWidgetAdapter >> processDeferredActions [

	deferredActions ifNil: [ ^ self ].
	deferredActions do: [ :each | each value ].
	deferredActions := nil
]

{ #category : 'accessing' }
GtkPanelWidgetAdapter >> raise [

	self innerWidgetDo: [ :w | w raise ]
]

{ #category : 'accessing' }
GtkPanelWidgetAdapter >> title: aString [
	| newTitle |
	
	newTitle := aString ifNil: [ '' ].
	self widgetDo: [ :w |
		w title: newTitle.
		w saveDelegate title: newTitle ]
]

{ #category : 'private' }
GtkPanelWidgetAdapter >> transferFrom: oldWindow toWindowWithHandle: newWindowHandle [
	| newWindow |
	
	newWindow := self presenter application windows
		detect: [ :each | each adapter innerWidget getHandle = newWindowHandle ].
	oldWindow basicRemovePresenter: self presenter.
	newWindow basicAddPresenter: self presenter.
	self presenter owner: newWindow.
	self runInSystem: [
		self presenter announce: (SpPanelWidgetTransferred from: oldWindow to: newWindow) ] 
]

{ #category : 'accessing' }
GtkPanelWidgetAdapter >> unmarkBusy [

	self widgetDo: [ :w | w unmarkBusy ]
]

{ #category : 'accessing' }
GtkPanelWidgetAdapter >> unmaximize [

	self widgetDo: [ :w | w unmaximize ]
]

{ #category : 'private - updating' }
GtkPanelWidgetAdapter >> updateModifiedTo: aBoolean [

	self widgetDo: [ :w | w modified: aBoolean ]
]

{ #category : 'private' }
GtkPanelWidgetAdapter >> updateParent [

	[ 
		| oldWindow |
		oldWindow := self presenter window. 
		oldWindow withAdapterDo: [ :oldAdapter | 
			oldAdapter innerWidget ifNotNil: [ :oldWidget |
				self innerWidget ifNotNil: [ :currentWidget |
					| rootHandle |
					rootHandle := currentWidget root getHandle.
					"just act if this is not the same"
					oldWidget getHandle = rootHandle 
						ifFalse: [ self transferFrom: oldWindow toWindowWithHandle: rootHandle ] ] ] ] ]
	on: Error 
	fork: [ :e | e pass ]
]

{ #category : 'private - updating' }
GtkPanelWidgetAdapter >> updatePinnedTo: aBoolean [

	self widgetDo: [ :w | w pinned: aBoolean ]
]

{ #category : 'private' }
GtkPanelWidgetAdapter >> updatePosition [
	| panelPosition presenterPanelPosition |

	presenterPanelPosition := self presenter panelPosition copy.
	presenterPanelPosition ifNil: [ ^ self ].
	
	panelPosition := self innerWidgetDo: [ :w | w position ].
	(panelPosition isNil or: [ panelPosition getHandle isNull ]) ifTrue: [ ^ self ].

	presenterPanelPosition fromPanelPosition: panelPosition.
	self presenter panelPosition: presenterPanelPosition
]

{ #category : 'private' }
GtkPanelWidgetAdapter >> updateWindowIconTo: aForm [

	self widgetDo: [ :w |
		w icon: (aForm 
			ifNotNil: [ aForm asGdkPaintableOnApplication: self presenter application ] 
			ifNil: [ GdkPaintable null ]) ]
]

{ #category : 'building' }
GtkPanelWidgetAdapter >> widgetClass [

	^ PanelWidget
]

{ #category : 'private' }
GtkPanelWidgetAdapter >> widgetDestroyed [

	logger trace. 
	
	self announceClosed
]

{ #category : 'test support' }
GtkPanelWidgetAdapter >> widgetTitle [
	
	^ self widgetDo: [ :w | w title ]
]

{ #category : 'private - updating' }
GtkPanelWidgetAdapter >> widgetWasPlacedOn: aPanelDocumentWorkspace [
	"internal plumbing used from GtkPanelWindowAdapter to inform this side a widget has been 
	 placed. When this can be in a more burocratic way by sending and subscribing to the 
	 SpPanelWidgetPlaced announcement, in this case this mechanism is valid because a 
	 PanelWindow can *just* have PanelWidgets, and I want to economize in announcer 
	 consumption.
	 Notice that this needs to be used careful and just for the most low-level functions"
	self processDeferredActions.
	self newActionManager afterPlacedInstallOn: aPanelDocumentWorkspace
]
