Class {
	#name : 'PanelPosition',
	#superclass : 'GObject',
	#category : 'Panel',
	#package : 'Panel'
}

{ #category : 'accessing' }
PanelPosition >> area [

	^ self ffiCall: #(PanelArea panel_position_get_area (self))
]
