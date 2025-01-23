Class {
	#name : 'GtkPanelWidgetAdapter',
	#superclass : 'GtkAdapter',
	#category : 'Spec-Panel-Adapter',
	#package : 'Spec-Panel',
	#tag : 'Adapter'
}

{ #category : 'building' }
GtkPanelWidgetAdapter >> addModelTo: panelWidget [
	| childWidget |

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

	self widgetDo: [ :w | w close ]
]

{ #category : 'private' }
GtkPanelWidgetAdapter >> forceClose [

	self widgetDo: [ :w | w forceClose ]
]

{ #category : 'accessing' }
GtkPanelWidgetAdapter >> maximize [

	self widgetDo: [ :w | w maximize ]
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
