Class {
	#name : 'DockWorkspacePresenterTest',
	#superclass : 'SpSpecTest',
	#category : 'Spec-Panel-Tests',
	#package : 'Spec-Panel',
	#tag : 'Tests'
}

{ #category : 'accessing' }
DockWorkspacePresenterTest >> application [

	^ SpApplication new
		useBackend: #Gtk;
		yourself
]

{ #category : 'accessing' }
DockWorkspacePresenterTest >> classToTest [

	^ DockDockWindowPresenter
]

{ #category : 'running' }
DockWorkspacePresenterTest >> tearDown [

	presenter ifNotNil: #close.
	super tearDown
]

{ #category : 'tests' }
DockWorkspacePresenterTest >> testAddPresenterAt [
	| dockablePresenter |

	"first test add before opening"
	presenter 
		addPresenter: (SpLabelPresenter new
			label: 'START';
			yourself)
		at: DockArea start.
		
	self openInstance.
	
	self assert: presenter presenters size equals: 1.
	dockablePresenter := presenter presenters first.
	self assert: dockablePresenter dockArea equals: DockArea start.
	self assert: dockablePresenter adapter notNil.
	self assert: dockablePresenter adapter widgetTitle equals: dockablePresenter title.
	
	"now test add after opening"
	presenter 
		addPresenter: (SpLabelPresenter new
			label: 'CENTER';
			yourself)
		at: DockArea center.
		
	self assert: presenter presenters size equals: 2.
	dockablePresenter := presenter presenters last.
	self assert: dockablePresenter dockArea equals: DockArea center.
	self assert: dockablePresenter adapter notNil.
	self assert: dockablePresenter adapter widgetTitle equals: dockablePresenter title
]

{ #category : 'tests' }
DockWorkspacePresenterTest >> testAddingAPresenterInAreaShowsIt [
		
	self openInstance.

	self deny: (presenter isAreaVisible: DockArea start).
	
	presenter 
		addPresenter: (SpLabelPresenter new
			label: 'START';
			yourself)
		at: DockArea start.
		
	self assert: (presenter isAreaVisible: DockArea start)
]

{ #category : 'tests - showing' }
DockWorkspacePresenterTest >> testClose [

	presenter build.
	presenter open.
	self assert: presenter isOpen.
	presenter close.
	self assert: presenter isClosed
]

{ #category : 'tests' }
DockWorkspacePresenterTest >> testInitialExtent [

	presenter initialExtent: 400@400.
	self openInstance.
	self assert: presenter adapter widgetSize equals: 400@400
]

{ #category : 'tests - showing' }
DockWorkspacePresenterTest >> testOpen [

	presenter build.
	self assert: presenter adapter notNil.
	self deny: presenter adapter widgetIsVisible.
	presenter open.
	self assert: presenter adapter widgetIsVisible
]

{ #category : 'tests' }
DockWorkspacePresenterTest >> testTitle [

	presenter title: 'Test'.
	self openInstance.
	self assert: presenter title equals: 'Test'.
self assert: presenter adapter widgetTitle equals: 'Test'.
	
	presenter title: 'Test modified'.
	self assert: presenter title equals: 'Test modified'.
	self assert: presenter adapter widgetTitle equals: 'Test modified'
	
]

{ #category : 'tests - events' }
DockWorkspacePresenterTest >> testWhenClosedDo [
	| closed |

	closed := false.
	presenter whenClosedDo: [ closed := true ].
	self openInstance.
	presenter close.
	self assert: closed
]

{ #category : 'tests - events' }
DockWorkspacePresenterTest >> testWhenTitleChangedDo [
	| changed |

	changed := false.
	presenter whenTitleChangedDo: [ :aString | changed := true ].
	presenter title: 'Test'.
	
	self assert: changed
]

{ #category : 'tests - events' }
DockWorkspacePresenterTest >> testWhenWillCloseDo [
	| willClose closed |

	willClose := false.
	closed := false.
	presenter whenWillCloseDo: [ :ann | willClose := true ].
	presenter whenClosedDo: [ closed := willClose ].
	self openInstance.
	presenter close.
	self assert: willClose.
	self assert: closed
]
