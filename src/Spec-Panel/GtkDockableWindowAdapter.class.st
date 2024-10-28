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
		child: childWidget
]

{ #category : 'building' }
GtkDockableWindowAdapter >> widgetClass [

	^ PanelWidget
]

{ #category : 'test support' }
GtkDockableWindowAdapter >> widgetTitle [
	
	^ self widgetDo: [ :w | w title ]
]
