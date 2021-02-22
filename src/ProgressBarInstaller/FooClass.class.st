Class {
	#name : #FooClass,
	#superclass : #Object,
	#category : #ProgressBarInstaller
}

{ #category : #accessing }
FooClass >> foo: aString [

	aString asFileReference entries 
		collect: [ : fileEntry | self openOnFileNamed: fileEntry fullName title: fileEntry fullName ]
]
