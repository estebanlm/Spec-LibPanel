Class {
	#name : 'GtkPanelStatusbarAdapter',
	#superclass : 'GtkAdapter',
	#category : 'Spec-Panel-Adapter',
	#package : 'Spec-Panel',
	#tag : 'Adapter'
}

{ #category : 'building' }
GtkPanelStatusbarAdapter >> addModelTo: gtkWidget [

	super addModelTo: gtkWidget.

	self presenter prefixPresenters
		withIndexDo: [ :eachPresenter :index | 
			self addPrefix: eachPresenter priority: index to: gtkWidget ].

	self presenter suffixPresenters 
		withIndexDo: [ :eachPresenter :index | 
			self addSuffix: eachPresenter priority: index to: gtkWidget ]	
]

{ #category : 'api' }
GtkPanelStatusbarAdapter >> addPrefix: aPresenter [

	self widgetDo: [ :w |
		self 
			addPrefix: aPresenter 
			priority: self presenter prefixPresenters size
			to: w ]
]

{ #category : 'api' }
GtkPanelStatusbarAdapter >> addPrefix: aPresenter priority: aNumber to: gtkWidget [

	aPresenter build.
	gtkWidget 
		addPrefix: aPresenter adapter widget 
		priority: aNumber
]

{ #category : 'api' }
GtkPanelStatusbarAdapter >> addSuffix: aPresenter [

	self widgetDo: [ :w |
		self 
			addSuffix: aPresenter 
			priority: self presenter suffixPresenters size
			to: w ]
]

{ #category : 'api' }
GtkPanelStatusbarAdapter >> addSuffix: aPresenter priority: aNumber to: gtkWidget [

	aPresenter build.
	gtkWidget 
		addSuffix: aPresenter adapter widget 
		priority: aNumber
]

{ #category : 'building' }
GtkPanelStatusbarAdapter >> newWidget [

	^ self panelWindow statusbar
]

{ #category : 'private' }
GtkPanelStatusbarAdapter >> panelWindow [

	"A panel status bar can just be built on the panel window"
	^ self presenter owner adapter innerWidget
]

{ #category : 'api' }
GtkPanelStatusbarAdapter >> remove: aPresenter [

	aPresenter ifNil: [ ^ self ].
	self widgetDo: [ :w | w remove: aPresenter adapter widget ]
]
