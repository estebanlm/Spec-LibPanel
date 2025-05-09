Class {
	#name : 'GtkAdapterActionPanelWindowManager',
	#superclass : 'GtkAdapterActionManager',
	#category : 'Spec-Panel-Adapter',
	#package : 'Spec-Panel',
	#tag : 'Adapter'
}

{ #category : 'private - actions' }
GtkAdapterActionPanelWindowManager >> installContextMenuOn: panelWindow [

	"install context menu"
	super installContextMenuOn: panelWindow.
	"install also a hamburger menu"
	self installHamburgerMenuOn: panelWindow
]

{ #category : 'private - actions' }
GtkAdapterActionPanelWindowManager >> installHamburgerMenuOn: panelWindow [
	| menu |
	
	menu := GtkMenuButton new
		iconName: 'open-menu-symbolic';
		menuModel: self buildMenuModel;
		yourself.
		
	panelWindow titlebar packEnd: menu
]
