"
ProgressBarInstaller installOnMethod: #MyClass >> myMethod.

"
Class {
	#name : #ProgressBarInstaller,
	#superclass : #Object,
	#instVars : [
		'newSource',
		'iterators'
	],
	#category : #ProgressBarInstaller
}

{ #category : #examples }
ProgressBarInstaller class >> example1 [

	self installOnMethod: FooClass >> #foo:.
"	self installOnMethod: FooClass >> #foo: iterator: #collect:.
	self installOnMethod: FooClass >> #foo: iterators: #(#do: #collect: select:).
	
	self installOnClass: FooClass.
	self installOnClass: FooClass iterator: #collect:.
	self installOnClass: FooClass iterator: #(#do: #collect: select:).

	self installOnPackage: FooClass.
	self installOnPackage: FooClass iterator: #collect:.
	self installOnPackage: FooClass iterator: #(#do: #collect: select:).	"
]

{ #category : #'instance creation' }
ProgressBarInstaller class >> installOnClass: aClassSymbol [

	^ self new installOnClass: aClassSymbol
]

{ #category : #'instance creation' }
ProgressBarInstaller class >> installOnClass: aClassSymbol iterator: aSelector [

	^ self new installOnClass: aClassSymbol iterator: aSelector
]

{ #category : #'instance creation' }
ProgressBarInstaller class >> installOnClass: aClassSymbol iterators: aCollection [

	^ self new installOnClass: aClassSymbol iterators: aCollection
]

{ #category : #'instance creation' }
ProgressBarInstaller class >> installOnMethod: aCompiledMethod [

	^ self new installOnMethod: aCompiledMethod
]

{ #category : #'instance creation' }
ProgressBarInstaller class >> installOnMethod: aCompiledMethod iterator: aSelector [

	^ self new installOnMethod: aCompiledMethod iterator: aSelector
]

{ #category : #'instance creation' }
ProgressBarInstaller class >> installOnMethod: aCompiledMethod iterators: aCollection [

	^ self new installOnMethod: aCompiledMethod iterators: aCollection
]

{ #category : #'instance creation' }
ProgressBarInstaller class >> installOnPackage: aPackageSymbol [

	^ self new installOnPackage: aPackageSymbol
]

{ #category : #accessing }
ProgressBarInstaller >> buildReplacementUsing: aSelector [

	^ '	[ : job |
		| index |
		index := 0.
		job title: ''Starting.''.
		``@collection ' , aSelector key , ' ``@arg1 ' ,
 	         aSelector value , self jobNotificationSource
]

{ #category : #accessing }
ProgressBarInstaller >> defaultIterators [

	^ Dictionary newFromPairs: { 
		'collect:' . 'thenDo:' .
		'select:' . 'thenDo:' .
		'reject:' . 'thenDo:' .
		'do:' . 'displayingProgress:' .
		'associationsDo:' . 'displayingProgress:' }
]

{ #category : #accessing }
ProgressBarInstaller >> installOnMethod: aCompiledMethod [

	self installOnMethod: aCompiledMethod iterators: self iterators
]

{ #category : #accessing }
ProgressBarInstaller >> installOnMethod: aCompiledMethod iterator: aSelector [
	" Answer a <String> with the new source for aCompiledMethod using aSelector, if there is no match answer an empty <String> "

	| rewriteRule |		
	rewriteRule := RBParseTreeRewriter new
		replace: '``@collection ' , aSelector key , '``@arg1'
		with: (self buildReplacementUsing: aSelector).
	(rewriteRule executeTree: aCompiledMethod parseTree)
		ifTrue: [ self newSource: rewriteRule tree newSource.
			^ self newSource ].
	^ String empty

]

{ #category : #accessing }
ProgressBarInstaller >> installOnMethod: aCompiledMethod iterators: aDictionary [

	aDictionary associations 
		select: [ : assocSelector | (self installOnMethod: aCompiledMethod iterator: assocSelector) notEmpty ]
		thenDo: [ : assocSelector | self installOnSystem: aCompiledMethod ]

]

{ #category : #accessing }
ProgressBarInstaller >> installOnSystem: aCompiledMethod [

	(Smalltalk at: aCompiledMethod classBinding key)
		compile: self newSource
	

]

{ #category : #accessing }
ProgressBarInstaller >> iterators [
	^ iterators
		ifNil: [ iterators := self defaultIterators ]
]

{ #category : #accessing }
ProgressBarInstaller >> iterators: anObject [
	iterators := anObject
]

{ #category : #accessing }
ProgressBarInstaller >> jobClass [

	SystemVersion current major >= 5
		ifTrue: [ ^ Smalltalk at: #Job ].
	SystemVersion current major = 4
		ifTrue: [ ^ Smalltalk at: #JobProgress ].
	self error: 'Pharo version not found'

]

{ #category : #accessing }
ProgressBarInstaller >> jobNotificationSource [

	^ '[ : fileEntry |
			index := index + 1.
			{1} current
				progress: (0.1 * index);
				title: ''Procesing...'', index asString ] ] asJob run' format: (Array with: self jobClass asString).

]

{ #category : #accessing }
ProgressBarInstaller >> newSource [
	^ newSource
]

{ #category : #accessing }
ProgressBarInstaller >> newSource: anObject [
	newSource := anObject
]
