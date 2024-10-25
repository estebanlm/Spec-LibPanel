Class {
	#name : 'LibPanel',
	#superclass : 'GObjectLibrary',
	#category : 'Panel',
	#package : 'Panel'
}

{ #category : 'accessing - platform' }
LibPanel >> unix64LibraryName [

	^ FFIUnix64LibraryFinder findLibrary: 'libpanel-1.so'
]
