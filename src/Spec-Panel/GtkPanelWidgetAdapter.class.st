Class {
	#name : 'GtkPanelWidgetAdapter',
	#superclass : 'GtkAdapter',
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

{ #category : 'building' }
GtkPanelWidgetAdapter >> addModelTo: panelWidget [
	| childWidget |

	"panels are maximizable by default"
	panelWidget canMaximize: true.

	panelWidget saveDelegate: (PanelSaveDelegate new
		title: self presenter title;
		connectSave: [ self runInSystem: [ self announceSave ] ];
		connectDiscard: [ self runInSystem: [ self announceDiscard ] ];
		connectClose: [ "self announceDiscard" ];
		yourself).
	panelWidget connectDestroy: [ self announceClosed ].
				
	childWidget := SpBindings
		value: self presenter application adapterBindings
		during: [ self presenter presenter build ].

	panelWidget 
		title: self presenter title;
		child: childWidget.
	
	self presenter windowIcon 
		ifNotNil: [ :aForm | panelWidget icon: aForm asGdkPaintable ].
	
	"Events"
	panelWidget
		connectPresented: [
			self runInSystem: [  
				self announcePresented.
				self presenter presenter takeKeyboardFocus ] ];
		addFocusEnterEvent: [ :event |
			self runInSystem: [ self announceFocusEnter ] ];
		addFocusLeaveEvent: [ :event |
			self runInSystem: [ self announceFocusLeave ] ].
	
	self presenter isModified
		ifTrue: [ panelWidget modified: true ].
	self presenter whenModifiedChangedDo: [ :aBoolean |
		self updateModifiedTo: aBoolean ]
]

{ #category : 'private - announcing' }
GtkPanelWidgetAdapter >> announceClosed [
	self presenter windowClosed
]

{ #category : 'private - announcing' }
GtkPanelWidgetAdapter >> announceDiscard [
	| ann |

	ann := DockPanelWindowDiscard new.
	self presenter announce: ann.
	ann isSuccess ifTrue: [ 
		self forceClose ]
]

{ #category : 'private - announcing' }
GtkPanelWidgetAdapter >> announceFocusEnter [

	self presenter announce: (DockPanelWindowFocusReceived new 
		window: self presenter;
		yourself)
]

{ #category : 'private - announcing' }
GtkPanelWidgetAdapter >> announceFocusLeave [

	self presenter announce: (DockPanelWindowFocusLost new 
		window: self presenter;
		yourself)
]

{ #category : 'private - announcing' }
GtkPanelWidgetAdapter >> announcePresented [

	self presenter announce: (DockPanelWindowPresented new 
		window: self presenter;
		yourself)
]

{ #category : 'private - announcing' }
GtkPanelWidgetAdapter >> announceSave [
	| ann |

	ann := DockPanelWindowSave new.
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
		self contentWidget withObjectReferenceDo: [ 
			w withObjectReferenceDo: [ 
				w perform: aSelector ] ] ]
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

{ #category : 'building' }
GtkPanelWidgetAdapter >> widgetClass [

	^ PanelWidget
]

{ #category : 'test support' }
GtkPanelWidgetAdapter >> widgetTitle [
	
	^ self widgetDo: [ :w | w title ]
]
