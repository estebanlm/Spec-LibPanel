Class {
	#name : 'GtkDockableWindowAdapter',
	#superclass : 'GtkAdapter',
	#category : 'Spec-Panel-Adapter',
	#package : 'Spec-Panel',
	#tag : 'Adapter'
}

{ #category : 'building' }
GtkDockableWindowAdapter >> addModelTo: panelWidget [
	| childWidget |

	childWidget := SpBindings
		value: self presenter application adapterBindings
		during: [ self presenter presenter build ].
	panelWidget 
		title: self presenter title;
		child: childWidget;
		connectPresented: [
			self announcePresented.
			self presenter presenter takeKeyboardFocus ].
		
	self presenter whenModifiedChangedDo: [ :aBoolean |
		self updateModifiedTo: aBoolean ]
]

{ #category : 'private' }
GtkDockableWindowAdapter >> announcePresented [

	self presenter announce: (DockDockableWindowPresented new 
		window: self presenter;
		yourself)
]

{ #category : 'private - updating' }
GtkDockableWindowAdapter >> updateModifiedTo: aBoolean [

	self widgetDo: [ :w | w modified: aBoolean ]
]

{ #category : 'building' }
GtkDockableWindowAdapter >> widgetClass [

	^ PanelWidget
]

{ #category : 'test support' }
GtkDockableWindowAdapter >> widgetTitle [
	
	^ self widgetDo: [ :w | w title ]
]
