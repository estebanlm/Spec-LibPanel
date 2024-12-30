Class {
	#name : 'GtkPanelWindowAdapter',
	#superclass : 'GtkAdapter',
	#category : 'Spec-Panel-Adapter',
	#package : 'Spec-Panel',
	#tag : 'Adapter'
}

{ #category : 'building' }
GtkPanelWindowAdapter >> addModelTo: panelWidget [
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
GtkPanelWindowAdapter >> announceClosed [

	self presenter windowClosed
]

{ #category : 'private - announcing' }
GtkPanelWindowAdapter >> announceDiscard [
	| ann |

	ann := DockPanelWindowDiscard new.
	self presenter announce: ann.
	ann isSuccess ifTrue: [ 
		self forceClose ]
]

{ #category : 'private - announcing' }
GtkPanelWindowAdapter >> announceFocusEnter [

	self presenter announce: (DockPanelWindowFocusReceived new 
		window: self presenter;
		yourself)
]

{ #category : 'private - announcing' }
GtkPanelWindowAdapter >> announceFocusLeave [

	self presenter announce: (DockPanelWindowFocusLost new 
		window: self presenter;
		yourself)
]

{ #category : 'private - announcing' }
GtkPanelWindowAdapter >> announcePresented [

	self presenter announce: (DockPanelWindowPresented new 
		window: self presenter;
		yourself)
]

{ #category : 'private - announcing' }
GtkPanelWindowAdapter >> announceSave [
	| ann |

	ann := DockPanelWindowSave new.
	self presenter announce: ann.
	ann isSuccess ifTrue: [ 
		self forceClose ]
]

{ #category : 'accessing' }
GtkPanelWindowAdapter >> close [ 

	self widgetDo: [ :w | w close ]
]

{ #category : 'private' }
GtkPanelWindowAdapter >> forceClose [

	self widgetDo: [ :w | w forceClose ]
]

{ #category : 'accessing' }
GtkPanelWindowAdapter >> maximize [

	self widgetDo: [ :w | w maximize ]
]

{ #category : 'accessing' }
GtkPanelWindowAdapter >> raise [

	self innerWidgetDo: [ :w | w raise ]
]

{ #category : 'accessing' }
GtkPanelWindowAdapter >> title: aString [

	self widgetDo: [ :w |
		w title: self presenter title.
		w saveDelegate title: self presenter title ]
]

{ #category : 'accessing' }
GtkPanelWindowAdapter >> unmaximize [

	self widgetDo: [ :w | w unmaximize ]
]

{ #category : 'private - updating' }
GtkPanelWindowAdapter >> updateModifiedTo: aBoolean [

	self widgetDo: [ :w | w modified: aBoolean ]
]

{ #category : 'building' }
GtkPanelWindowAdapter >> widgetClass [

	^ PanelWidget
]

{ #category : 'test support' }
GtkPanelWindowAdapter >> widgetTitle [
	
	^ self widgetDo: [ :w | w title ]
]
