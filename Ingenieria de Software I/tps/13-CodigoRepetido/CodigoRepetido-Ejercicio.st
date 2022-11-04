!classDefinition: #CantSuspend category: 'CodigoRepetido-Ejercicio'!
Error subclass: #CantSuspend
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!


!classDefinition: #NotFound category: 'CodigoRepetido-Ejercicio'!
Error subclass: #NotFound
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!


!classDefinition: #CustomerBookTest category: 'CodigoRepetido-Ejercicio'!
TestCase subclass: #CustomerBookTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!

!CustomerBookTest methodsFor: 'testing' stamp: 'GRC 9/8/2021 14:18:34'!
test01AddingCustomerShouldNotTakeMoreThan50Milliseconds

	| customerBook addingACustomer |
	
	customerBook := CustomerBook new.
	addingACustomer := [customerBook addCustomerNamed: 'John Lennon'.].
	
	self assertThat: addingACustomer takesLessThan: 50 * millisecond.! !

!CustomerBookTest methodsFor: 'testing' stamp: 'GRC 9/8/2021 14:19:17'!
test02RemovingCustomerShouldNotTakeMoreThan100Milliseconds

	| customerBook paulMcCartney removingACustomer |
	
	customerBook := CustomerBook new.
	paulMcCartney := 'Paul McCartney'.
	
	customerBook addCustomerNamed: paulMcCartney.
	removingACustomer := [customerBook removeCustomerNamed: paulMcCartney.].
	
	self assertThat: removingACustomer takesLessThan: 100 * millisecond.
	
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'GRC 9/8/2021 14:50:48'!
test03CanNotAddACustomerWithEmptyName 

	| customerBook addingAnEmptyCustomerName expectedErrorMessageAndEmptyCustomerBook anErrorMessage |
			
	customerBook := CustomerBook new.
		
	addingAnEmptyCustomerName := [customerBook addCustomerNamed: ''.].
	expectedErrorMessageAndEmptyCustomerBook := [:anError |
		self assert: anError messageText = CustomerBook customerCanNotBeEmptyErrorMessage.
		self assert: customerBook isEmpty].
	anErrorMessage := Error.
	
	self checkThat: addingAnEmptyCustomerName failsWith: anErrorMessage andVerifies: expectedErrorMessageAndEmptyCustomerBook.! !

!CustomerBookTest methodsFor: 'testing' stamp: 'GRC 9/8/2021 14:53:04'!
test04CanNotRemoveAnInvalidCustomer
	
	| customerBook johnLennon removingANonRegisteredCustomer customerListOnlyHasJohnLennon aNotFoundMessage |
			
	customerBook := CustomerBook new.
	johnLennon := 'John Lennon'.
	customerBook addCustomerNamed: johnLennon.
		
	removingANonRegisteredCustomer := [customerBook removeCustomerNamed: 'Paul McCartney'.].
	customerListOnlyHasJohnLennon := self customerBookOnlyHasJohnLennonConditions: customerBook.
	aNotFoundMessage := NotFound.
	
	self checkThat: removingANonRegisteredCustomer failsWith: aNotFoundMessage andVerifies: customerListOnlyHasJohnLennon.
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'GRC 9/8/2021 14:16:21'!
test05SuspendingACustomerShouldNotRemoveItFromCustomerBook

	| customerBook paulMcCartney|
	
	customerBook := CustomerBook new.
	paulMcCartney := 'Paul McCartney'.
	
	customerBook addCustomerNamed: paulMcCartney.
	customerBook suspendCustomerNamed: paulMcCartney.
	
	self assertThat: customerBook hasActiveCustomers: 0 hasSuspendedCustomers: 1 hasTotalCustomers: 1. 
	self assert: (customerBook includesCustomerNamed: paulMcCartney).
	

	
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'GRC 9/8/2021 14:16:21'!
test06RemovingASuspendedCustomerShouldRemoveItFromCustomerBook

	| customerBook paulMcCartney|
	
	customerBook := CustomerBook new.
	paulMcCartney := 'Paul McCartney'.
	
	customerBook addCustomerNamed: paulMcCartney.
	customerBook suspendCustomerNamed: paulMcCartney.
	customerBook removeCustomerNamed: paulMcCartney.
	
	self assertThat: customerBook hasActiveCustomers: 0 hasSuspendedCustomers: 0 hasTotalCustomers: 0. 
	self deny: (customerBook includesCustomerNamed: paulMcCartney).


	
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'GRC 9/8/2021 14:55:01'!
test07CanNotSuspendAnInvalidCustomer
	
	| customerBook johnLennon suspendingANonRegisteredCustomer customerBookOnlyHasJohnLennon aCantSuspendMessage |
			
	customerBook := CustomerBook new.
	johnLennon := 'John Lennon'.
	customerBook addCustomerNamed: johnLennon.
		
	suspendingANonRegisteredCustomer := [customerBook suspendCustomerNamed: 'George Harrison'.].
	customerBookOnlyHasJohnLennon := self customerBookOnlyHasJohnLennonConditions: customerBook.
	aCantSuspendMessage := CantSuspend.
	
	self checkThat: suspendingANonRegisteredCustomer failsWith: aCantSuspendMessage andVerifies: customerBookOnlyHasJohnLennon.
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'GRC 9/8/2021 14:53:05'!
test08CanNotSuspendAnAlreadySuspendedCustomer
	
	| customerBook johnLennon suspendingAnAlreadySuspendedCustomer customerListOnlyHasJohnLennon aCantSuspendMessage |
			
	customerBook := CustomerBook new.
	johnLennon := 'John Lennon'.
	customerBook addCustomerNamed: johnLennon.
	customerBook suspendCustomerNamed: johnLennon.
	
	suspendingAnAlreadySuspendedCustomer := [ customerBook suspendCustomerNamed: johnLennon. ].
	customerListOnlyHasJohnLennon := self customerBookOnlyHasJohnLennonConditions: customerBook.
	aCantSuspendMessage := CantSuspend.
	
	self checkThat: suspendingAnAlreadySuspendedCustomer failsWith: aCantSuspendMessage andVerifies: customerListOnlyHasJohnLennon.
! !


!CustomerBookTest methodsFor: 'assertions' stamp: 'GRC 9/8/2021 14:16:21'!
assertThat: aCustomerBook hasActiveCustomers: aNumberOfActiveCustomers hasSuspendedCustomers: aNumberOfSuspendedCustomers hasTotalCustomers: aNumberOfCustomers
	self assert: aNumberOfActiveCustomers equals: aCustomerBook numberOfActiveCustomers.
	self assert: aNumberOfSuspendedCustomers equals: aCustomerBook numberOfSuspendedCustomers.
	self assert: aNumberOfCustomers equals: aCustomerBook numberOfCustomers.! !

!CustomerBookTest methodsFor: 'assertions' stamp: 'GRC 9/8/2021 14:16:37'!
assertThat: aClosure takesLessThan: aTimeInMilliseconds

	| millisecondsBeforeRunning millisecondsAfterRunning |

	millisecondsBeforeRunning := Time millisecondClockValue * millisecond.
	aClosure value.
	millisecondsAfterRunning := Time millisecondClockValue * millisecond.
	
	self assert: (millisecondsAfterRunning-millisecondsBeforeRunning) < aTimeInMilliseconds.! !

!CustomerBookTest methodsFor: 'assertions' stamp: 'GRC 9/8/2021 14:30:14'!
checkThat: aClosure failsWith: anErrorMessage andVerifies: aSequenceOfAssertions 

	[ aClosure value.
	self fail ]
		on: anErrorMessage
		do: aSequenceOfAssertions.! !


!CustomerBookTest methodsFor: 'auxiliaries' stamp: 'GRC 9/8/2021 14:53:04'!
customerBookOnlyHasJohnLennonConditions: aCustomerBook

	 ^[self assert: aCustomerBook numberOfCustomers = 1.
		self assert: (aCustomerBook includesCustomerNamed: 'John Lennon') ].! !


!classDefinition: #CustomerBook category: 'CodigoRepetido-Ejercicio'!
Object subclass: #CustomerBook
	instanceVariableNames: 'suspended active'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!

!CustomerBook methodsFor: 'testing' stamp: 'NR 4/3/2019 10:14:26'!
includesCustomerNamed: aName

	^(active includes: aName) or: [ suspended includes: aName ]! !

!CustomerBook methodsFor: 'testing' stamp: 'NR 4/3/2019 10:14:26'!
isEmpty
	
	^active isEmpty and: [ suspended isEmpty ]! !


!CustomerBook methodsFor: 'initialization' stamp: 'NR 9/17/2020 07:23:04'!
initialize

	active := OrderedCollection new.
	suspended:= OrderedCollection new.! !


!CustomerBook methodsFor: 'customer management' stamp: 'NR 4/3/2019 10:14:26'!
addCustomerNamed: aName

	aName isEmpty ifTrue: [ self signalCustomerNameCannotBeEmpty ].
	((active includes: aName) or: [suspended includes: aName]) ifTrue: [ self signalCustomerAlreadyExists ].
	
	active add: aName ! !

!CustomerBook methodsFor: 'customer management' stamp: 'NR 4/3/2019 10:14:26'!
numberOfActiveCustomers
	
	^active size! !

!CustomerBook methodsFor: 'customer management' stamp: 'NR 4/3/2019 10:14:26'!
numberOfCustomers
	
	^active size + suspended size! !

!CustomerBook methodsFor: 'customer management' stamp: 'NR 9/19/2018 17:36:09'!
numberOfSuspendedCustomers
	
	^suspended size! !

!CustomerBook methodsFor: 'customer management' stamp: 'GRC 9/8/2021 14:10:01'!
removeCustomerNamed: aName 
 
	active remove: aName ifAbsent: [
		suspended remove: aName ifAbsent: [
			^NotFound signal.
		]
	].
! !

!CustomerBook methodsFor: 'customer management' stamp: 'HernanWilkinson 7/6/2011 17:52'!
signalCustomerAlreadyExists 

	self error: self class customerAlreadyExistsErrorMessage! !

!CustomerBook methodsFor: 'customer management' stamp: 'HernanWilkinson 7/6/2011 17:51'!
signalCustomerNameCannotBeEmpty 

	self error: self class customerCanNotBeEmptyErrorMessage ! !

!CustomerBook methodsFor: 'customer management' stamp: 'NR 4/3/2019 10:14:26'!
suspendCustomerNamed: aName 
	
	(active includes: aName) ifFalse: [^CantSuspend signal].
	
	active remove: aName.
	
	suspended add: aName
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CustomerBook class' category: 'CodigoRepetido-Ejercicio'!
CustomerBook class
	instanceVariableNames: ''!

!CustomerBook class methodsFor: 'error messages' stamp: 'NR 4/12/2021 16:39:13'!
customerAlreadyExistsErrorMessage

	^'customer already exists!!!!!!'! !

!CustomerBook class methodsFor: 'error messages' stamp: 'NR 4/12/2021 16:39:09'!
customerCanNotBeEmptyErrorMessage

	^'customer name cannot be empty!!!!!!'! !
