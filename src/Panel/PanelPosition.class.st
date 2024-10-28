"
https://gnome.pages.gitlab.gnome.org/libpanel/class.Position.html
"
Class {
	#name : 'PanelPosition',
	#superclass : 'GObject',
	#traits : 'LibTPanel',
	#classTraits : 'LibTPanel classTrait',
	#category : 'Panel',
	#package : 'Panel'
}

{ #category : 'instance creation' }
PanelPosition class >> bottom [

	^ self new area: PanelArea PANEL_AREA_BOTTOM
]

{ #category : 'instance creation' }
PanelPosition class >> center [

	^ self new area: PanelArea PANEL_AREA_CENTER
]

{ #category : 'instance creation' }
PanelPosition class >> end [

	^ self new area: PanelArea PANEL_AREA_END
]

{ #category : 'private' }
PanelPosition class >> gtkNew [

	^ self ffiCall: #(PanelPosition* panel_position_new (void))
]

{ #category : 'instance creation' }
PanelPosition class >> start [

	^ self new area: PanelArea PANEL_AREA_START
]

{ #category : 'instance creation' }
PanelPosition class >> top [

	^ self new area: PanelArea PANEL_AREA_TOP
]

{ #category : 'accessing' }
PanelPosition >> area [

	^ self ffiCall: #(PanelArea panel_position_get_area (self))
]

{ #category : 'accessing' }
PanelPosition >> area: area [

	^ self ffiCall: #(void panel_position_set_area (self, PanelArea area))
]
