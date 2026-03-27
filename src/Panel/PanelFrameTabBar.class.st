"
https://gnome.pages.gitlab.gnome.org/libpanel/panel-1.0/class.FrameTabBar.html
"
Class {
	#name : 'PanelFrameTabBar',
	#superclass : 'PanelFrameHeader',
	#category : 'Panel',
	#package : 'Panel'
}

{ #category : 'private' }
PanelFrameTabBar class >> gtkNew [

	^ self ffiCall: #(PanelFrameTabBar *panel_frame_tab_bar_new (void))
]

{ #category : 'accessing' }
PanelFrameTabBar >> autohide: autohide [

	self ffiCall: #(void panel_frame_tab_bar_set_autohide (self, gboolean autohide))
]

{ #category : 'signaling' }
PanelFrameTabBar >> connectClosed: aBlock [
	"aBlock answer true if we will actually want proceed with the close, which we do by sending the 
	 original action (frame.close) of the button" 

	self flag: #HACK. "This is a mega-hack because I did not find a proper way to get the event 
	of frame closed"
	
	self 
		insertActionGroup: 'spec'
		actions: (GSimpleActionGroup new
			insert: ((GSimpleAction newName: 'close')
				connectActivate: [ 
					aBlock value 
						ifTrue: [ self activateAction: 'frame.close' ] ];
				yourself);
			yourself).
	
	self allConcreteWidgetChildren 
		detect: [ :each | 
			(each class = GtkButton) 
			and: [ each hasCssClass: 'frame-close-button' ] ]
		ifFound: [ :aButton | aButton actionName: 'spec.close' ]
]

{ #category : 'testing' }
PanelFrameTabBar >> isAutohide [

	^ self ffiCall: #(gboolean panel_frame_tab_bar_get_autohide (self))
]
