Class {
	#name : 'GtkDockPanelAdapter',
	#superclass : 'GtkAdapter',
	#category : 'Spec-Panel-Adapter',
	#package : 'Spec-Panel',
	#tag : 'Adapter'
}

{ #category : 'building' }
GtkDockPanelAdapter >> addModelTo: panelWidget [
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
GtkDockPanelAdapter >> announceClosed [

	self presenter windowClosed
]

{ #category : 'private - announcing' }
GtkDockPanelAdapter >> announceDiscard [
	| ann |

	ann := DockPanelWindowDiscard new.
	self presenter announce: ann.
	ann isSuccess ifTrue: [ 
		self forceClose ]
]

{ #category : 'private - announcing' }
GtkDockPanelAdapter >> announceFocusEnter [

	self presenter announce: (DockPanelWindowFocusReceived new 
		window: self presenter;
		yourself)
]

{ #category : 'private - announcing' }
GtkDockPanelAdapter >> announceFocusLeave [

	self presenter announce: (DockPanelWindowFocusLost new 
		window: self presenter;
		yourself)
]

{ #category : 'private - announcing' }
GtkDockPanelAdapter >> announcePresented [

	self presenter announce: (DockPanelWindowPresented new 
		window: self presenter;
		yourself)
]

{ #category : 'private - announcing' }
GtkDockPanelAdapter >> announceSave [
	| ann |

	ann := DockPanelWindowSave new.
	self presenter announce: ann.
	ann isSuccess ifTrue: [ 
		self forceClose ]
]

{ #category : 'accessing' }
GtkDockPanelAdapter >> close [ 

	self widgetDo: [ :w | w close ]
]

{ #category : 'private' }
GtkDockPanelAdapter >> forceClose [

	self widgetDo: [ :w | w forceClose ]
]

{ #category : 'accessing' }
GtkDockPanelAdapter >> maximize [

	self widgetDo: [ :w | w maximize ]
]

{ #category : 'accessing' }
GtkDockPanelAdapter >> raise [

	self innerWidgetDo: [ :w | w raise ]
]

{ #category : 'accessing' }
GtkDockPanelAdapter >> title: aString [
	| newTitle |
	
	newTitle := aString ifNil: [ '' ].
	self widgetDo: [ :w |
		w title: newTitle.
		w saveDelegate title: newTitle ]
]

{ #category : 'accessing' }
GtkDockPanelAdapter >> unmaximize [

	self widgetDo: [ :w | w unmaximize ]
]

{ #category : 'private - updating' }
GtkDockPanelAdapter >> updateModifiedTo: aBoolean [

	self widgetDo: [ :w | w modified: aBoolean ]
]

{ #category : 'building' }
GtkDockPanelAdapter >> widgetClass [

	^ PanelWidget
]

{ #category : 'test support' }
GtkDockPanelAdapter >> widgetTitle [
	
	^ self widgetDo: [ :w | w title ]
]
