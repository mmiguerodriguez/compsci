!classDefinition: #CartTests category: 'TusLibros'!
TestCase subclass: #CartTests
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CartTests methodsFor: 'as yet unclassified' stamp: 'RI 11/1/2021 14:42:29'!
test01NewCartStartsEmpty

	| cart |
	
	cart _ Cart new.
	
	self assert: true equals: cart books isEmpty .! !

!CartTests methodsFor: 'as yet unclassified' stamp: 'RI 11/1/2021 14:44:08'!
test02CartWithABookIsNotEmpty

	| cart |
	
	cart _ Cart new.
	cart addBook: '1' withAmount: 2.
	
	self assert: 2 equals: (cart books at: '1').
	self assert: 1 equals: cart books size.! !

!CartTests methodsFor: 'as yet unclassified' stamp: 'RI 11/1/2021 14:47:01'!
test03AddingExistingBookToACartModifiesAmount

	| cart |
	
	cart _ Cart new.
	cart addBook: '1' withAmount: 2.
	cart addBook: '1' withAmount: 2.	
	
	self assert: 4 equals: (cart books at: '1').
	self assert: 1 equals: cart books size.! !

!CartTests methodsFor: 'as yet unclassified' stamp: 'RI 11/1/2021 15:16:15'!
test04CartWithMultipleBooksListsThemCorrectly

	| cart |
	
	cart _ Cart new.
	cart addBook: '1' withAmount: 2.
	cart addBook: '1' withAmount: 2.	
	cart addBook: '2' withAmount: 3.		
	
	self assert: '1|4|2|3' equals: (cart listBooks).! !

!CartTests methodsFor: 'as yet unclassified' stamp: 'RI 11/1/2021 15:35:50'!
test05AddingNegativeOrZeroAmountOfBooksThrowsError

	| cart |
	
	cart _ Cart new.
	
	self should: [cart addBook: '1' withAmount: 0.]
		raise: Error
		withExceptionDo: [:anError | self assert: Cart cannotAddInvalidAmountOfBooks equals: anError messageText].! !

!CartTests methodsFor: 'as yet unclassified' stamp: 'RI 11/1/2021 15:35:31'!
test06AddingNotIntegerAmountOfBooksThrowsError

	| cart |
	
	cart _ Cart new.
	
	self should: [cart addBook: '1' withAmount: 1.5.]
		raise: Error
		withExceptionDo: [:anError | self assert: Cart cannotAddInvalidAmountOfBooks equals: anError messageText].! !


!classDefinition: #Cart category: 'TusLibros'!
Object subclass: #Cart
	instanceVariableNames: 'books'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cart methodsFor: 'as yet unclassified' stamp: 'RI 11/1/2021 15:34:29'!
addBook: anISBN withAmount: anAmount
	
	| originalAmount |
	
	((anAmount < 1) or: [anAmount isInteger not]) ifTrue: [^self error: Cart cannotAddInvalidAmountOfBooks].
	
	originalAmount _ books at: anISBN ifAbsent: [
		^books add: anISBN->anAmount. 
	].

	books at: anISBN put: originalAmount + anAmount.! !

!Cart methodsFor: 'as yet unclassified' stamp: 'RI 11/1/2021 14:24:04'!
books
	^books.! !

!Cart methodsFor: 'as yet unclassified' stamp: 'RI 11/1/2021 14:38:00'!
initialize

	books _ Dictionary new.! !

!Cart methodsFor: 'as yet unclassified' stamp: 'RI 11/1/2021 15:14:46'!
listBooks
	| result |
	
	result _ ''.
	
	books keys sort do: [:aKey | result _ result , aKey , '|' , (books at: aKey) asString , '|'].
	
	^result copyFrom: 1 to: (result size - 1).! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: 'TusLibros'!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'as yet unclassified' stamp: 'RI 11/1/2021 15:34:49'!
cannotAddInvalidAmountOfBooks
	
	^'Invalid amount of book to be added.'.! !
