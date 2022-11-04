!classDefinition: #OOStackTest category: 'Stack-Exercise'!
TestCase subclass: #OOStackTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStackTest methodsFor: 'test' stamp: 'HernanWilkinson 5/7/2012 11:30'!
test01StackShouldBeEmptyWhenCreated

	| stack |
	
	stack := OOStack new.
	
	self assert: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:29:55'!
test02PushAddElementsToTheStack

	| stack |
	
	stack := OOStack new.
	stack push: 'something'.
	
	self deny: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:01'!
test03PopRemovesElementsFromTheStack

	| stack |
	
	stack := OOStack new.
	stack push: 'something'.
	stack pop.
	
	self assert: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:09'!
test04PopReturnsLastPushedObject

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'something'.
	stack push: pushedObject.
	
	self assert: stack pop = pushedObject! !

!OOStackTest methodsFor: 'test' stamp: 'NR 9/16/2021 17:40:17'!
test05StackBehavesLIFO

	| stack firstPushedObject secondPushedObject |
	
	stack := OOStack new.
	firstPushedObject := 'firstSomething'.
	secondPushedObject := 'secondSomething'.
	
	stack push: firstPushedObject.
	stack push: secondPushedObject.
	
	self assert: stack pop = secondPushedObject.
	self assert: stack pop = firstPushedObject.
	self assert: stack isEmpty 
	! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:20'!
test06TopReturnsLastPushedObject

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'something'.
	
	stack push: pushedObject.
	
	self assert: stack top = pushedObject.
	! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:24'!
test07TopDoesNotRemoveObjectFromStack

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'something'.
	
	stack push: pushedObject.
	
	self assert: stack size = 1.
	stack top.
	self assert: stack size = 1.
	! !

!OOStackTest methodsFor: 'test' stamp: 'HAW 4/14/2017 22:48:26'!
test08CanNotPopWhenThereAreNoObjectsInTheStack

	| stack  |
	
	stack := OOStack new.
	self
		should: [ stack pop ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:31'!
test09CanNotPopWhenThereAreNoObjectsInTheStackAndTheStackHadObjects

	| stack  |
	
	stack := OOStack new.
	stack push: 'something'.
	stack pop.
	
	self
		should: [ stack pop ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !

!OOStackTest methodsFor: 'test' stamp: 'GRC 9/20/2021 09:58:44'!
test10CanNotTopWhenThereAreNoObjectsInTheStack

	| stack  |
	
	stack := OOStack new.
	self
		should: [ stack top ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !


!classDefinition: #SentenceFinderByPrefixTest category: 'Stack-Exercise'!
TestCase subclass: #SentenceFinderByPrefixTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!SentenceFinderByPrefixTest methodsFor: 'testing' stamp: 'MR 9/19/2021 19:15:14'!
test01FindFromEmptyStackShouldBeEmpty
	| sentenceFinder anEmptyStack |
	
	anEmptyStack := OOStack new.
	sentenceFinder := SentenceFinderByPrefix new initializeWith: anEmptyStack.
	
	self assert: (sentenceFinder find: 'prefix') isEmpty.
	
	! !

!SentenceFinderByPrefixTest methodsFor: 'testing' stamp: 'MR 9/19/2021 20:06:40'!
test02FindSentecesWithOtherPrefixesShouldBeEmpty
	| sentenceFinder stack |
	
	stack := OOStack new.
	stack push: 'Maradona plays good'.
	stack push: 'Messi plays better'.
	sentenceFinder := SentenceFinderByPrefix new initializeWith: stack.
	
	self assert: (sentenceFinder find: 'Pele') isEmpty.
	
	! !

!SentenceFinderByPrefixTest methodsFor: 'testing' stamp: 'MR 9/19/2021 20:05:35'!
test03FindOnlyOneSentence
	| sentenceFinder stack expectedSentence |
	
	stack := OOStack new.
	stack push: 'Maradona plays good'.
	stack push: 'Messi plays better'.
	sentenceFinder := SentenceFinderByPrefix new initializeWith: stack.
	
	expectedSentence := OrderedCollection with: 'Messi plays better'.
	
	self assert: (sentenceFinder find: 'Messi') equals: expectedSentence.
	
	! !

!SentenceFinderByPrefixTest methodsFor: 'testing' stamp: 'MR 9/19/2021 20:08:02'!
test04FindMultipleSentences
	| sentenceFinder stack expectedSentence |
	
	stack := OOStack new.
	stack push: 'Maradona plays good'.
	stack push: 'The big brown fox'.
	stack push: 'Maradona won many titles'.
	
	sentenceFinder := SentenceFinderByPrefix new initializeWith: stack.
	expectedSentence := OrderedCollection with: 'Maradona plays good' with: 'Maradona won many titles'.
	
	self assert: (sentenceFinder find: 'Maradona') equals: expectedSentence.
	
	! !

!SentenceFinderByPrefixTest methodsFor: 'testing' stamp: 'GRC 9/20/2021 14:20:20'!
test05FindPreservesStack

	| stack expectedStack sentenceFinder |
	
	stack := OOStack new.
	stack push: 'Maradona plays good'.
	stack push: 'Maradona won many titles'.
	stack push: 'The big brown fox'.
	
	expectedStack := stack.
	
	sentenceFinder := SentenceFinderByPrefix new initializeWith: stack.
	sentenceFinder find: 'Maradona'.
	
	self assert: (self originalStack: expectedStack hasSameElements: sentenceFinder listSentences ).
	
	! !

!SentenceFinderByPrefixTest methodsFor: 'testing' stamp: 'MR 9/19/2021 19:49:53'!
test06FindIsCaseSensitive
	| sentenceFinder stack expectedSentence |
	
	stack := OOStack new.
	stack push: 'maradona plays good'.
	stack push: 'Maradona won many titles'.
	stack push: 'maradona is big'.
	
	sentenceFinder := SentenceFinderByPrefix new initializeWith: stack.
	expectedSentence := OrderedCollection with: 'Maradona won many titles'.
	
	self assert: (sentenceFinder find: 'Maradona') equals: expectedSentence.
	
	! !

!SentenceFinderByPrefixTest methodsFor: 'testing' stamp: 'MR 9/19/2021 19:53:47'!
test07FindWithEmptyPrefixThrowsError
	| sentenceFinder stack |
	
	stack := OOStack new.
	stack push: 'Maradona plays good'.
	stack push: 'Maradona won many titles'.
	
	sentenceFinder := SentenceFinderByPrefix new initializeWith: stack.
	
	self should: [sentenceFinder find: ''] raise: Error
       withExceptionDo: [ :anError | self assert: anError messageText equals: SentenceFinderByPrefix invalidPrefixError].! !

!SentenceFinderByPrefixTest methodsFor: 'testing' stamp: 'MR 9/19/2021 20:06:10'!
test08FindWithPrefixWithSpacesThrowsError
	| sentenceFinder stack |
	
	stack := OOStack new.
	stack push: 'Maradona plays good'.
	stack push: 'Maradona won many titles'.
	
	sentenceFinder := SentenceFinderByPrefix new initializeWith: stack.
	
	self should: [sentenceFinder find: 'La scaloneta'] raise: Error
       withExceptionDo: [ :anError | self assert: anError messageText equals: SentenceFinderByPrefix invalidPrefixError].! !

!SentenceFinderByPrefixTest methodsFor: 'testing' stamp: 'GRC 9/20/2021 14:22:57'!
test09FindReturnsAllSentences

	| sentenceFinder stack expectedSentence |
	
	stack := OOStack new.
	stack push: 'Maradona plays good'.
	stack push: 'Maradona won many titles'.
	
	sentenceFinder := SentenceFinderByPrefix new initializeWith: stack.
	expectedSentence := OrderedCollection with: 'Maradona plays good' with: 'Maradona won many titles'.
	
	self assert: (sentenceFinder find: 'Maradona') equals: expectedSentence.	! !

!SentenceFinderByPrefixTest methodsFor: 'testing' stamp: 'GRC 9/20/2021 14:32:04'!
test10OnlyFindsWithPrefixAtTheBeginning

	| sentenceFinder stack expectedSentence |
	
	stack := OOStack new.
	stack push: 'PSG number 30 is Messi'.
	stack push: 'CR7 << Messi'.
	stack push: 'Messi is the GOAT'.
	
	sentenceFinder := SentenceFinderByPrefix new initializeWith: stack.
	
	expectedSentence := OrderedCollection with: 'Messi is the GOAT'.
	
	self assert: (sentenceFinder find: 'Messi') equals: expectedSentence.
	
	! !


!SentenceFinderByPrefixTest methodsFor: 'assertions' stamp: 'GRC 9/20/2021 14:33:36'!
originalStack: anOriginalStack hasSameElements: anOrderedCollection

	| originalStackSentences |
	
	originalStackSentences := OrderedCollection new.
	
	[anOriginalStack isEmpty not] whileTrue: [| stackElement |
		stackElement := anOriginalStack pop.
		originalStackSentences addFirst: stackElement
	].

	^originalStackSentences = anOrderedCollection.! !


!classDefinition: #OOStack category: 'Stack-Exercise'!
Object subclass: #OOStack
	instanceVariableNames: 'topElement size'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStack methodsFor: 'initialization' stamp: 'GRC 9/20/2021 14:08:29'!
initialize
	
	topElement := StackBase new.
	
	size := 0.! !


!OOStack methodsFor: 'comparing' stamp: 'GRC 9/20/2021 13:58:14'!
isEmpty

	^size = 0.! !


!OOStack methodsFor: 'stackOperations' stamp: 'GRC 9/20/2021 14:08:29'!
pop	
	| element |
	element := self top.
	topElement := topElement previous.
	
	size := size - 1.
	^element.! !

!OOStack methodsFor: 'stackOperations' stamp: 'GRC 9/20/2021 14:08:29'!
push: anElement

	| newTop |.
	
	newTop := StackElement new initializeWith: anElement previous: topElement.
	
	topElement := newTop.
	
	size := size + 1.! !

!OOStack methodsFor: 'stackOperations' stamp: 'GRC 9/20/2021 13:59:56'!
size
	^size.! !

!OOStack methodsFor: 'stackOperations' stamp: 'GRC 9/20/2021 14:08:29'!
top

	^topElement value.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OOStack class' category: 'Stack-Exercise'!
OOStack class
	instanceVariableNames: ''!

!OOStack class methodsFor: 'error descriptions' stamp: 'NR 9/16/2021 17:39:43'!
stackEmptyErrorDescription
	
	^ 'stack is empty!!!!!!'! !


!classDefinition: #StackBase category: 'Stack-Exercise'!
OOStack subclass: #StackBase
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!StackBase methodsFor: 'accessing' stamp: 'GRC 9/20/2021 09:44:10'!
previous

	^self error: OOStack stackEmptyErrorDescription.! !

!StackBase methodsFor: 'accessing' stamp: 'GRC 9/20/2021 09:59:24'!
value

	^self error: OOStack stackEmptyErrorDescription.! !


!StackBase methodsFor: 'initialization' stamp: 'GRC 9/20/2021 09:50:23'!
initialize! !


!classDefinition: #StackElement category: 'Stack-Exercise'!
OOStack subclass: #StackElement
	instanceVariableNames: 'value previous'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!StackElement methodsFor: 'initialization' stamp: 'GRC 9/20/2021 10:03:03'!
initializeWith: aValue previous: aStackElement

	value := aValue.
	
	previous := aStackElement	.! !


!StackElement methodsFor: 'accessing' stamp: 'GRC 9/20/2021 09:43:09'!
previous

	^previous.! !

!StackElement methodsFor: 'accessing' stamp: 'GRC 9/20/2021 09:44:51'!
value

	^value.! !


!classDefinition: #SentenceFinderByPrefix category: 'Stack-Exercise'!
Object subclass: #SentenceFinderByPrefix
	instanceVariableNames: 'stack'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!SentenceFinderByPrefix methodsFor: 'assertions' stamp: 'GRC 9/20/2021 14:24:42'!
isValidPrefix: aPrefix

	(aPrefix = '' or: [aPrefix includesSubString: ' ']) ifTrue: [^self error: SentenceFinderByPrefix invalidPrefixError].! !


!SentenceFinderByPrefix methodsFor: 'auxiliaries - private' stamp: 'MR 9/19/2021 19:36:53'!
listSentences
	| sentences |
	
	sentences := OrderedCollection new.
	
	[stack isEmpty not] whileTrue: [| stackElement |
		stackElement := stack pop.
		sentences addFirst: stackElement
	].

	self rebuildStack: sentences.

	^sentences.! !

!SentenceFinderByPrefix methodsFor: 'auxiliaries - private' stamp: 'MR 9/19/2021 19:09:10'!
rebuildStack: sentences

	sentences do: [:sentence | stack push: sentence].! !


!SentenceFinderByPrefix methodsFor: 'operations' stamp: 'GRC 9/20/2021 14:17:13'!
find: aPrefix

	| sentences |
	
	self isValidPrefix: aPrefix.
	
	sentences := self listSentences.
	
	^sentences select: [:sentence | sentence beginsWith: aPrefix].




! !


!SentenceFinderByPrefix methodsFor: 'initialization' stamp: 'GRC 9/20/2021 14:21:42'!
initializeWith: aStack

	stack := aStack.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SentenceFinderByPrefix class' category: 'Stack-Exercise'!
SentenceFinderByPrefix class
	instanceVariableNames: ''!

!SentenceFinderByPrefix class methodsFor: 'as yet unclassified' stamp: 'MR 9/19/2021 19:55:38'!
invalidPrefixError
	^'El prefijo ingresado es invalido'.! !
