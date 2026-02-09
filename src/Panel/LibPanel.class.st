Class {
	#name : 'LibPanel',
	#superclass : 'GObjectLibrary',
	#category : 'Panel',
	#package : 'Panel'
}

{ #category : 'accessing - platform' }
LibPanel >> macLibraryName [

	^ FFIMacLibraryFinder findLibrary: 'libpanel-1.1.dylib'
]

{ #category : 'accessing - platform' }
LibPanel >> unix64LibraryName [

	^ FFIUnix64LibraryFinder findAnyLibrary: #('libpanel-1.so' 'libpanel-1.so.1')
]

{ #category : 'accessing - platform' }
LibPanel >> win32LibraryName [

	^ FFIWindowsLibraryFinder findLibrary: 'libpanel-1-1.dll'
]
