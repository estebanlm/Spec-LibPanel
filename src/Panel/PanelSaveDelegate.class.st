"
https://gnome.pages.gitlab.gnome.org/libpanel/panel-1.0/class.SaveDelegate.html
"
Class {
	#name : 'PanelSaveDelegate',
	#superclass : 'GObject',
	#traits : 'LibTPanel',
	#classTraits : 'LibTPanel classTrait',
	#category : 'Panel',
	#package : 'Panel'
}

{ #category : 'private' }
PanelSaveDelegate class >> gNew [

	^ self ffiCall: #(PanelSaveDelegate* panel_save_delegate_new (void))
]

{ #category : 'instance creation' }
PanelSaveDelegate class >> new [

	^ self gNew initialize
]

{ #category : 'signaling' }
PanelSaveDelegate >> connectClose: aBlock [

	self 
		connect: 'close' 
		signature: #(void (void *delegate, gpointer user_data)) 
		do: [ :delegate :user_data | aBlock value ]
]

{ #category : 'signaling' }
PanelSaveDelegate >> connectDiscard: aBlock [

	self 
		connect: 'discard' 
		signature: #(void (void *delegate, gpointer user_data)) 
		do: [ :delegate :user_data | aBlock value ]
]

{ #category : 'signaling' }
PanelSaveDelegate >> connectSave: aBlock [

	self 
		connect: 'save' 
		signature: #(void (void *delegate, gpointer user_data)) 
		do: [ :delegate :user_data | aBlock value ]
]

{ #category : 'accessing' }
PanelSaveDelegate >> finish: result error: error [

	self ffiCall: #(gboolean panel_save_delegate_save_finish (
  		self,
  		"GAsyncResult*"void *result,
  		"GError** "void *error))
]

{ #category : 'accessing' }
PanelSaveDelegate >> saveAsync: callback [

	self ffiCall: #(void panel_save_delegate_save_async (
  	self,
  	"GCancellable* cancellable"NULL,
  	"GAsyncReadyCallback"GCallback callback,
  	"gpointer user_data"NULL))
]

{ #category : 'accessing' }
PanelSaveDelegate >> subtitle [

	self ffiCall: #(char* panel_save_delegate_get_subtitle (self))
]

{ #category : 'accessing' }
PanelSaveDelegate >> subtitle: subtitle [

	self ffiCall: #(void panel_save_delegate_set_subtitle (self, const char* subtitle))
]

{ #category : 'accessing' }
PanelSaveDelegate >> title [

	self ffiCall: #(char* panel_save_delegate_get_title (self))
]

{ #category : 'accessing' }
PanelSaveDelegate >> title: title [

	self ffiCall: #(void panel_save_delegate_set_title (self, const char* title))
]
