Class {
	#name : 'BaselineOfPanel',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfPanel',
	#package : 'BaselineOfPanel'
}

{ #category : 'baselines' }
BaselineOfPanel >> baseline: spec [
	<baseline>
	
	spec for: #common do: [ 
		spec 
			package: 'Panel';
			package: 'Spec-Panel' ]
]
