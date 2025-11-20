"
https://gnome.pages.gitlab.gnome.org/libpanel/panel-1.0/class.Application.html
"
Class {
	#name : 'PanelApplication',
	#superclass : 'AdwApplication',
	#traits : 'LibTPanel',
	#classTraits : 'LibTPanel classTrait',
	#category : 'Panel',
	#package : 'Panel'
}

{ #category : 'examples' }
PanelApplication class >> example [
	| workspace workbench headerBar |
	
	GEngine current ifNotNil: [ 
		GEngine current applicationClass = self ifFalse: [ 
			self error: 'An engine with a different application is already running.' ] ].
	
	GEngine current ifNil: [ 
		GtkEngine new 
			applicationClass: PanelApplication;
			run ].

	GRunLoop defer: [ 	
		workbench := PanelWorkbench new.
		workspace := PanelDocumentWorkspaceWindow new.	
		workbench addWorkspace: workspace.
		workbench focusWorkspace: workspace.

		headerBar := AdwHeaderBar new.	
		workspace titlebar: headerBar.
		
		headerBar titleWidget: (GtkLabel newLabel: 'LibPanel Example').

		1 to: 5 do: [ :index |
			workspace 
				addWidget: (PanelWidget new
					title: 'Test: ', index asString;
					canMaximize: true;
					child: (GtkScrolledWindow newWidget: (GtkTextView new
						text: Smalltalk allClasses atRandom comment;
						yourself));
					yourself)  
				at: PanelPosition center ].
	
		workspace 
			addWidget: (PanelWidget new
				title: 'Start';
				canMaximize: true;
				child: (GtkLabel newLabel: 'Start');
				yourself)  
			at: PanelPosition start.
		
	 	workspace dock revealStart: true ]
]

{ #category : 'private' }
PanelApplication class >> gtk_application_new: application_id flags: flags [

	^ self ffiCall: #(PanelApplication* panel_application_new (
		const char* application_id,
		GApplicationFlags flags))
]
