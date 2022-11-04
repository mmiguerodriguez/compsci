!classDefinition: #CartTest category: 'TusLibros'!
TestCase subclass: #CartTest
	instanceVariableNames: 'testObjectsFactory'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:10'!
test01NewCartsAreCreatedEmpty

	self assert: testObjectsFactory createCart isEmpty! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:10'!
test02CanNotAddItemsThatDoNotBelongToStore

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self 
		should: [ cart add: testObjectsFactory itemNotSellByTheStore ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:10'!
test03AfterAddingAnItemTheCartIsNotEmptyAnymore

	| cart |
	
	cart := testObjectsFactory createCart.
	
	cart add: testObjectsFactory itemSellByTheStore.
	self deny: cart isEmpty ! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:10'!
test04CanNotAddNonPositiveNumberOfItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self 
		should: [cart add: 0 of: testObjectsFactory itemSellByTheStore ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidQuantityErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:10'!
test05CanNotAddMoreThanOneItemNotSellByTheStore

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self 
		should: [cart add: 2 of: testObjectsFactory itemNotSellByTheStore  ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:11'!
test06CartRemembersAddedItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	cart add: testObjectsFactory itemSellByTheStore.
	self assert: (cart includes: testObjectsFactory itemSellByTheStore)! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:11'!
test07CartDoesNotHoldNotAddedItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self deny: (cart includes: testObjectsFactory itemSellByTheStore)! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:11'!
test08CartRemembersTheNumberOfAddedItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	cart add: 2 of: testObjectsFactory itemSellByTheStore.
	self assert: (cart occurrencesOf: testObjectsFactory itemSellByTheStore) = 2! !


!CartTest methodsFor: 'setup' stamp: 'HernanWilkinson 6/17/2013 18:09'!
setUp 

	testObjectsFactory := StoreTestObjectsFactory new.! !


!classDefinition: #CashierTest category: 'TusLibros'!
TestCase subclass: #CashierTest
	instanceVariableNames: 'testObjectsFactory debitBehavior'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:50'!
test01CanNotCheckoutAnEmptyCart

	| salesBook |
	
	salesBook := OrderedCollection new.
	self 
		should: [ Cashier 
			toCheckout: testObjectsFactory createCart 
			charging: testObjectsFactory notExpiredCreditCard 
			throught: self
			on: testObjectsFactory today
			registeringOn:  salesBook ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cashier cartCanNotBeEmptyErrorMessage.
			self assert: salesBook isEmpty ]! !

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:51'!
test02CalculatedTotalIsCorrect

	| cart cashier |
	
	cart := testObjectsFactory createCart.
	cart add: 2 of: testObjectsFactory itemSellByTheStore.
	
	cashier :=  Cashier
		toCheckout: cart 
		charging: testObjectsFactory notExpiredCreditCard 
		throught: self
		on: testObjectsFactory today 
		registeringOn: OrderedCollection new.
		
	self assert: cashier checkOut = (testObjectsFactory itemSellByTheStorePrice * 2)! !

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:51'!
test03CanNotCheckoutWithAnExpiredCreditCart

	| cart salesBook |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSellByTheStore.
	salesBook := OrderedCollection new.
	
	self
		should: [ Cashier 
				toCheckout: cart 
				charging: testObjectsFactory expiredCreditCard 
				throught: self
				on: testObjectsFactory today
				registeringOn: salesBook ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self assert: anError messageText = Cashier canNotChargeAnExpiredCreditCardErrorMessage.
			self assert: salesBook isEmpty ]! !

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 19:04'!
test04CheckoutRegistersASale

	| cart cashier salesBook total |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSellByTheStore.
	salesBook := OrderedCollection new.
 
	cashier:= Cashier 
		toCheckout: cart 
		charging: testObjectsFactory notExpiredCreditCard
		throught: self
		on: testObjectsFactory today
		registeringOn: salesBook.
		
	total := cashier checkOut.
					
	self assert: salesBook size = 1.
	self assert: salesBook first total = total.! !

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 19:00'!
test05CashierChargesCreditCardUsingMerchantProcessor

	| cart cashier salesBook total creditCard debitedAmout debitedCreditCard  |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSellByTheStore.
	creditCard := testObjectsFactory notExpiredCreditCard.
	salesBook := OrderedCollection new.
 
	cashier:= Cashier 
		toCheckout: cart 
		charging: creditCard
		throught: self
		on: testObjectsFactory today
		registeringOn: salesBook.
		
	debitBehavior := [ :anAmount :aCreditCard | 
		debitedAmout := anAmount.
		debitedCreditCard := aCreditCard ].
	total := cashier checkOut.
					
	self assert: debitedCreditCard = creditCard.
	self assert: debitedAmout = total.! !

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:59'!
test06CashierDoesNotSaleWhenTheCreditCardHasNoCredit

	| cart cashier salesBook creditCard |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSellByTheStore.
	creditCard := testObjectsFactory notExpiredCreditCard.
	salesBook := OrderedCollection new.
 	debitBehavior := [ :anAmount :aCreditCard | self error: Cashier creditCardHasNoCreditErrorMessage].
	
	cashier:= Cashier 
		toCheckout: cart 
		charging: creditCard
		throught: self
		on: testObjectsFactory today
		registeringOn: salesBook.
		
	self 
		should: [cashier checkOut ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cashier creditCardHasNoCreditErrorMessage.
			self assert: salesBook isEmpty ]! !


!CashierTest methodsFor: 'setup' stamp: 'HernanWilkinson 6/17/2013 19:03'!
setUp 

	testObjectsFactory := StoreTestObjectsFactory new.
	debitBehavior := [ :anAmount :aCreditCard | ]! !


!CashierTest methodsFor: 'merchant processor protocol' stamp: 'HernanWilkinson 6/17/2013 19:02'!
debit: anAmount from: aCreditCard 

	^debitBehavior value: anAmount value: aCreditCard ! !


!classDefinition: #TusLibrosInterfaceTest category: 'TusLibros'!
TestCase subclass: #TusLibrosInterfaceTest
	instanceVariableNames: 'testObjectsFactory shouldAuthenticate currentTime debitBehaviour clients'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!TusLibrosInterfaceTest methodsFor: 'setup' stamp: 'MR 11/11/2021 16:22:56'!
setUp 

	testObjectsFactory := StoreTestObjectsFactory new.
	shouldAuthenticate _ true.
	currentTime _ DateAndTime today.
	debitBehaviour _ [:anAmount :aCreditCard |].
	
	clients _ OrderedCollection with: 'Ryan' with: 'Guido' with: 'Pepe'.! !


!TusLibrosInterfaceTest methodsFor: 'tests' stamp: 'MR 11/11/2021 15:34:07'!
test01CannotCreateCartWithInvalidUsernameOrPassword

	| interface catalogue transactionsList |
	
	catalogue _ testObjectsFactory defaultCatalog.
	transactionsList _ OrderedCollection new.
	shouldAuthenticate _ false.
	interface _ TusLibrosInterface through: self withCatalogue: catalogue registeringOn: transactionsList.
	
	self 
		should: [interface createCartFor: 'Ryan' with: 'Rugby2021']
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: TusLibrosInterface invalidLoginErrorMessage equals: anError messageText].! !

!TusLibrosInterfaceTest methodsFor: 'tests' stamp: 'MR 11/11/2021 15:34:05'!
test02NewlyCreatedCartShouldBeEmpty

	| interface cartContents cartId catalogue transactionsList |
	
	catalogue _ testObjectsFactory defaultCatalog.
	transactionsList _ OrderedCollection new.
	interface _ TusLibrosInterface through: self withCatalogue: catalogue registeringOn: transactionsList.
	
	cartId _ interface createCartFor: 'Guido' with: '123456'.
	cartContents _ interface listCart: cartId.
	
	self assert: 1 equals: cartId.
	self assert: cartContents isEmpty. ! !

!TusLibrosInterfaceTest methodsFor: 'tests' stamp: 'MR 11/11/2021 15:34:02'!
test03CartsHaveUniqueIds

	| interface validUser1 password cart1Id cart2Id validUser2 catalogue transactionsList |
	
	catalogue _ testObjectsFactory defaultCatalog.
	transactionsList _ OrderedCollection new.
	interface _ TusLibrosInterface through: self withCatalogue: catalogue registeringOn: transactionsList.
	validUser1 _ 'Guido'.
	validUser2 _ 'Migue'.
	password _ 'juancho'.
	
	cart1Id _ interface createCartFor: validUser1 with: password.
	cart2Id _ interface createCartFor: validUser2 with: password.
	
	self deny: cart1Id = cart2Id.! !

!TusLibrosInterfaceTest methodsFor: 'tests' stamp: 'MR 11/11/2021 15:34:00'!
test04CartShouldContainAllItemsAddedToIt

	| interface cartId cartContents bookIsbn catalogue transactionsList |
	
	catalogue _ testObjectsFactory defaultCatalog.
	transactionsList _ OrderedCollection new.
	interface _ TusLibrosInterface through: self withCatalogue: catalogue registeringOn: transactionsList.
	bookIsbn _ testObjectsFactory itemSellByTheStore.
	
	cartId _ interface createCartFor: 'Guido' with: 'Juancho'.
	interface addToCart: cartId item: bookIsbn amount: 10.
	
	cartContents _ interface listCart: cartId.
	
	self assert: 10 equals: (cartContents occurrencesOf: bookIsbn).
	self assert: 10 equals: cartContents size.! !

!TusLibrosInterfaceTest methodsFor: 'tests' stamp: 'MR 11/11/2021 15:33:58'!
test05CannotListCartUsingAnInvalidCartId

	| interface catalogue transactionsList |
	
	catalogue _ testObjectsFactory defaultCatalog.
	transactionsList _ OrderedCollection new.
	interface _ TusLibrosInterface through: self withCatalogue: catalogue registeringOn: transactionsList.
	
	self 
		should: [interface listCart: 1]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: TusLibrosInterface invalidCartErrorMessage equals: anError messageText].! !

!TusLibrosInterfaceTest methodsFor: 'tests' stamp: 'MR 11/11/2021 15:33:54'!
test06CannotAddToCartInactiveFor30min

	| interface catalogue cartId bookIsbn transactionsList |
	
	catalogue _ testObjectsFactory defaultCatalog.
	transactionsList _ OrderedCollection new.
	interface _ TusLibrosInterface through: self withCatalogue: catalogue registeringOn: transactionsList.
	bookIsbn _ testObjectsFactory itemSellByTheStore.
	cartId _ interface createCartFor: 'Guido' with: 'Juancho'.
	
	currentTime _ currentTime + (Duration minutes: 32).
	
	self 
		should: [interface addToCart: cartId item: bookIsbn amount: 1]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: TusLibrosInterface invalidCartErrorMessage equals: anError messageText].! !

!TusLibrosInterfaceTest methodsFor: 'tests' stamp: 'MR 11/11/2021 15:33:52'!
test07CannotListCartInactiveFor30min

	| interface catalogue cartId transactionsList |
	
	catalogue _ testObjectsFactory defaultCatalog.
	transactionsList _ OrderedCollection new.
	interface _ TusLibrosInterface through: self withCatalogue: catalogue registeringOn: transactionsList.
	cartId _ interface createCartFor: 'Guido' with: 'Juancho'.
	
	currentTime _ currentTime + (Duration minutes: 300).
	
	self 
		should: [interface listCart: cartId]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: TusLibrosInterface invalidCartErrorMessage equals: anError messageText].! !

!TusLibrosInterfaceTest methodsFor: 'tests' stamp: 'MR 11/11/2021 15:33:49'!
test08CheckingOutAValidCartRegistersTransaction

	| interface catalogue cartId bookIsbn transactionId transactionsList creditCard |
	
	catalogue _ testObjectsFactory defaultCatalog.
	transactionsList _ OrderedCollection new.
	creditCard _ testObjectsFactory notExpiredCreditCard.
	interface _ TusLibrosInterface through: self withCatalogue: catalogue registeringOn: transactionsList.
	cartId _ interface createCartFor: 'Guido' with: 'Juancho'.
	
	bookIsbn _ testObjectsFactory itemSellByTheStore.
	
	cartId _ interface createCartFor: 'Guido' with: 'Juancho'.
	interface addToCart: cartId item: bookIsbn amount: 10.
	
	transactionId _ interface checkout: cartId charging: creditCard.
	
	self assert: transactionId equals: transactionsList first.
	self assert: 1 equals: transactionsList size.! !

!TusLibrosInterfaceTest methodsFor: 'tests' stamp: 'MR 11/11/2021 15:33:47'!
test09TransactionsHaveUniqueIds

	| interface catalogue cartId1 bookIsbn transactionId1 transactionsList creditCard cartId2 transactionId2 |
	
	catalogue _ testObjectsFactory defaultCatalog.
	transactionsList _ OrderedCollection new.
	creditCard _ testObjectsFactory notExpiredCreditCard.
	interface _ TusLibrosInterface through: self withCatalogue: catalogue registeringOn: transactionsList.
	
	bookIsbn _ testObjectsFactory itemSellByTheStore.
	
	cartId1 _ interface createCartFor: 'Guido' with: 'Juancho'.
	interface addToCart: cartId1 item: bookIsbn amount: 10.
	transactionId1 _ interface checkout: cartId1 charging: creditCard.
	
	cartId2 _ interface createCartFor: 'Pepe' with: 'Juancho'.
	interface addToCart: cartId2 item: bookIsbn amount: 5.
	transactionId2 _ interface checkout: cartId2 charging: creditCard.
	
	self assert: transactionId1 equals: transactionsList first.
	self assert: transactionId2 equals: (transactionsList at: 2).
	self deny: transactionId1 = transactionId2.
	self assert: 2 equals: transactionsList size.! !

!TusLibrosInterfaceTest methodsFor: 'tests' stamp: 'MR 11/11/2021 15:33:40'!
test10CheckingOutACartDeletesIt

	| interface catalogue cartId bookIsbn transactionsList creditCard |
	
	catalogue _ testObjectsFactory defaultCatalog.
	transactionsList _ OrderedCollection new.
	creditCard _ testObjectsFactory notExpiredCreditCard.
	interface _ TusLibrosInterface through: self withCatalogue: catalogue registeringOn: transactionsList.
	
	bookIsbn _ testObjectsFactory itemSellByTheStore.
	
	cartId _ interface createCartFor: 'Guido' with: 'Juancho'.
	interface addToCart: cartId item: bookIsbn amount: 10.
	
	interface checkout: cartId charging: creditCard.
	
	self 
		should: [interface listCart: cartId]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: TusLibrosInterface invalidCartErrorMessage equals: anError messageText].
	
	! !

!TusLibrosInterfaceTest methodsFor: 'tests' stamp: 'MR 11/11/2021 15:33:38'!
test11CannotCheckOutInvalidCart

	| interface catalogue transactionsList creditCard |
	
	catalogue _ testObjectsFactory defaultCatalog.
	transactionsList _ OrderedCollection new.
	creditCard _ testObjectsFactory notExpiredCreditCard.
	interface _ TusLibrosInterface through: self withCatalogue: catalogue registeringOn: transactionsList.
	
	self 
		should: [interface checkout: 1 charging: creditCard.]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: TusLibrosInterface invalidCartErrorMessage equals: anError messageText].
	
	! !

!TusLibrosInterfaceTest methodsFor: 'tests' stamp: 'MR 11/11/2021 15:33:36'!
test12CannotCheckOutCartInactiveFor30min

	| interface catalogue transactionsList creditCard bookIsbn cartId |
	
	catalogue _ testObjectsFactory defaultCatalog.
	transactionsList _ OrderedCollection new.
	creditCard _ testObjectsFactory notExpiredCreditCard.
	interface _ TusLibrosInterface through: self withCatalogue: catalogue registeringOn: transactionsList.
	bookIsbn _ testObjectsFactory itemSellByTheStore.
	
	cartId _ interface createCartFor: 'Guido' with: 'Juancho'.
	interface addToCart: cartId item: bookIsbn amount: 10.
	
	currentTime _ currentTime + (Duration minutes: 300).
	
	self 
		should: [interface checkout: cartId charging: creditCard.]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: TusLibrosInterface invalidCartErrorMessage equals: anError messageText].
	
	! !

!TusLibrosInterfaceTest methodsFor: 'tests' stamp: 'MR 11/11/2021 15:33:34'!
test13AddToCartOperationUpdatesLastModificationTime

	| interface catalogue transactionsList bookIsbn cartId |
	
	catalogue _ testObjectsFactory defaultCatalog.
	transactionsList _ OrderedCollection new.
	interface _ TusLibrosInterface through: self withCatalogue: catalogue registeringOn: transactionsList.
	bookIsbn _ testObjectsFactory itemSellByTheStore.
	
	cartId _ interface createCartFor: 'Guido' with: 'Juancho'.
	
	currentTime _ currentTime + (Duration minutes: 25).
	
	interface addToCart: cartId item: bookIsbn amount: 10.
	
	currentTime _ currentTime + (Duration minutes: 10).
	
	self assert: 10 equals: ((interface listCart: cartId) size).
	
	! !

!TusLibrosInterfaceTest methodsFor: 'tests' stamp: 'MR 11/11/2021 15:33:32'!
test14ListCartOperationUpdatesLastModificationTime

	| interface catalogue transactionsList cartId |
	
	catalogue _ testObjectsFactory defaultCatalog.
	transactionsList _ OrderedCollection new.
	interface _ TusLibrosInterface through: self withCatalogue: catalogue registeringOn: transactionsList.
	
	cartId _ interface createCartFor: 'Guido' with: 'Juancho'.
	
	currentTime _ currentTime + (Duration minutes: 25).
	
	interface listCart: cartId.
	
	currentTime _ currentTime + (Duration minutes: 10).
	
	self assert: 0 equals: ((interface listCart: cartId) size).
	
	! !

!TusLibrosInterfaceTest methodsFor: 'tests' stamp: 'MR 11/11/2021 15:16:02'!
test15ListClientPurchasesWithoutCheckoutsIsEmpty

	| interface catalogue transactionsList purchases |
	
	catalogue _ testObjectsFactory defaultCatalog.
	transactionsList _ OrderedCollection new.
	interface _ TusLibrosInterface through: self withCatalogue: catalogue registeringOn: transactionsList.
	
	purchases _ interface listPurchasesFor: 'Guido' with: '123456'.
	
	self assert: purchases keys isEmpty.! !

!TusLibrosInterfaceTest methodsFor: 'tests' stamp: 'MR 11/11/2021 15:16:57'!
test16ListClientPurchasesHasCorrectPurchases

	| interface catalogue transactionsList purchases cartId bookIsbn creditCard |
	
	catalogue _ testObjectsFactory defaultCatalog.
	transactionsList _ OrderedCollection new.
	creditCard _ testObjectsFactory notExpiredCreditCard.
	interface _ TusLibrosInterface through: self withCatalogue: catalogue registeringOn: transactionsList.
	bookIsbn _ testObjectsFactory itemSellByTheStore.
	
	cartId _ interface createCartFor: 'Guido' with: '123456'.
	interface addToCart: cartId item: bookIsbn amount: 10.
	interface checkout: cartId charging: creditCard.
	
	purchases _ interface listPurchasesFor: 'Guido' with: '123456'.
	
	self assert: 1 equals: purchases keys size.
	self assert: 10 equals: (purchases at: bookIsbn).! !

!TusLibrosInterfaceTest methodsFor: 'tests' stamp: 'MR 11/11/2021 15:17:21'!
test17ListDifferentClientPurchasesHasAllPurchases

	| interface catalogue transactionsList purchases cartId bookIsbn creditCard |
	
	catalogue _ testObjectsFactory defaultCatalog.
	transactionsList _ OrderedCollection new.
	creditCard _ testObjectsFactory notExpiredCreditCard.
	interface _ TusLibrosInterface through: self withCatalogue: catalogue registeringOn: transactionsList.
	bookIsbn _ testObjectsFactory itemSellByTheStore.
	
	cartId _ interface createCartFor: 'Guido' with: '123456'.
	interface addToCart: cartId item: bookIsbn amount: 10.
	interface checkout: cartId charging: creditCard.

	cartId _ interface createCartFor: 'Guido' with: '123456'.
	interface addToCart: cartId item: bookIsbn amount: 5.
	interface checkout: cartId charging: creditCard.

	purchases _ interface listPurchasesFor: 'Guido' with: '123456'.
	
	self assert: 1 equals: purchases keys size.
	self assert: 15 equals: (purchases at: bookIsbn).! !

!TusLibrosInterfaceTest methodsFor: 'tests' stamp: 'MR 11/11/2021 16:01:25'!
test18CannotListClientPurchasesWithInvalidCredentials

	| interface catalogue transactionsList |
	
	catalogue _ testObjectsFactory defaultCatalog.
	transactionsList _ OrderedCollection new.
	interface _ TusLibrosInterface through: self withCatalogue: catalogue registeringOn: transactionsList.
	
	shouldAuthenticate _ false.
	
	self 
		should: [interface listPurchasesFor: 'Guido' with: '123456']
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: TusLibrosInterface invalidLoginErrorMessage equals: anError messageText].! !


!TusLibrosInterfaceTest methodsFor: 'restApi' stamp: 'MR 11/11/2021 16:19:27'!
clients
	^clients.! !

!TusLibrosInterfaceTest methodsFor: 'restApi' stamp: 'GRC 11/8/2021 20:47:37'!
currentTime

	^currentTime.
	
	! !

!TusLibrosInterfaceTest methodsFor: 'restApi' stamp: 'GRC 11/8/2021 21:33:41'!
debit: anAmount from: aCreditCard 
	
	^debitBehaviour value: anAmount value: aCreditCard! !

!TusLibrosInterfaceTest methodsFor: 'restApi' stamp: 'GRC 11/8/2021 13:58:54'!
login: aUsername with: aPassword

	shouldAuthenticate ifFalse: [^self error: TusLibrosInterface invalidLoginErrorMessage].
	
	! !

!TusLibrosInterfaceTest methodsFor: 'restApi' stamp: 'RI 11/9/2021 15:38:52'!
today
	
	^testObjectsFactory today.! !


!classDefinition: #Cart category: 'TusLibros'!
Object subclass: #Cart
	instanceVariableNames: 'catalog items'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cart methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 17:45'!
invalidItemErrorMessage
	
	^'Item is not in catalog'! !

!Cart methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 17:45'!
invalidQuantityErrorMessage
	
	^'Invalid number of items'! !


!Cart methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 18:06'!
assertIsValidItem: anItem

	(catalog includesKey: anItem) ifFalse: [ self error: self invalidItemErrorMessage ]! !

!Cart methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 17:51'!
assertIsValidQuantity: aQuantity

	aQuantity strictlyPositive ifFalse: [ self error: self invalidQuantityErrorMessage ]! !


!Cart methodsFor: 'initialization' stamp: 'GRC 11/8/2021 13:49:40'!
initializeAcceptingItemsOf: aCatalog

	catalog := aCatalog.
	items := Bag new.! !


!Cart methodsFor: 'queries' stamp: 'GRC 11/8/2021 13:51:45'!
occurrencesOf: anItem

	^items occurrencesOf: anItem! !


!Cart methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 17:44'!
includes: anItem

	^items includes: anItem ! !

!Cart methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 17:44'!
isEmpty
	
	^items isEmpty ! !


!Cart methodsFor: 'total' stamp: 'HernanWilkinson 6/17/2013 19:09'!
total

	^ items sum: [ :anItem | catalog at: anItem ]! !


!Cart methodsFor: 'adding' stamp: 'HernanWilkinson 6/17/2013 17:44'!
add: anItem

	^ self add: 1 of: anItem ! !

!Cart methodsFor: 'adding' stamp: 'GRC 11/8/2021 14:04:13'!
add: aQuantity of: anItem

	self assertIsValidQuantity: aQuantity.
	self assertIsValidItem: anItem.
	
	items add: anItem withOccurrences: aQuantity.! !


!Cart methodsFor: 'contents - private' stamp: 'GRC 11/4/2021 20:53:35'!
items

	^items.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: 'TusLibros'!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 17:48'!
acceptingItemsOf: aCatalog

	^self new initializeAcceptingItemsOf: aCatalog ! !


!classDefinition: #CartInterface category: 'TusLibros'!
Object subclass: #CartInterface
	instanceVariableNames: 'cart modifiedAt dateAndTime clientId'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CartInterface methodsFor: 'initialization' stamp: 'RI 11/9/2021 16:07:18'!
initializeWithCart: aCart modifiedAt: aDateAndTime for: aClientId
	
	clientId _ aClientId.
	cart _ aCart.
	modifiedAt _ aDateAndTime.! !

!CartInterface methodsFor: 'initialization' stamp: 'MR 11/11/2021 16:05:14'!
isActiveAt: aDate

	| timeDifference |
	
	timeDifference _ (aDate - modifiedAt) totalMinutes.
	
	timeDifference > 30 ifTrue: [^self error: TusLibrosInterface invalidCartErrorMessage].! !


!CartInterface methodsFor: 'operations' stamp: 'MR 11/11/2021 16:06:55'!
add: anAmount of: anItem

	cart add: anAmount of: anItem.! !

!CartInterface methodsFor: 'operations' stamp: 'RI 11/9/2021 15:46:04'!
modifiedAt: aDateAndTime 

	modifiedAt _ aDateAndTime! !


!CartInterface methodsFor: 'accessing' stamp: 'MR 11/11/2021 15:52:41'!
cart

	^cart! !

!CartInterface methodsFor: 'accessing' stamp: 'RI 11/9/2021 16:08:27'!
clientId

	^clientId.! !

!CartInterface methodsFor: 'accessing' stamp: 'MR 11/11/2021 16:23:57'!
items
	^cart items.! !

!CartInterface methodsFor: 'accessing' stamp: 'RI 11/9/2021 15:45:49'!
modifiedAt

	^modifiedAt! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CartInterface class' category: 'TusLibros'!
CartInterface class
	instanceVariableNames: ''!

!CartInterface class methodsFor: 'instance creation' stamp: 'RI 11/9/2021 16:06:57'!
cart: aCart modifiedAt: aDateAndTime for: aClientId
	
	^self new initializeWithCart: aCart modifiedAt: aDateAndTime for: aClientId.! !


!classDefinition: #Cashier category: 'TusLibros'!
Object subclass: #Cashier
	instanceVariableNames: 'cart salesBook merchantProcessor creditCard total'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/17/2013 19:08'!
calculateTotal

	total := cart total.
	! !

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/17/2013 19:07'!
createSale

	^ Sale of: total
! !

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/17/2013 19:06'!
debitTotal

	merchantProcessor debit: total from: creditCard.
	! !

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/17/2013 19:06'!
registerSale

	salesBook add: self createSale! !


!Cashier methodsFor: 'checkout' stamp: 'HernanWilkinson 6/17/2013 19:06'!
checkOut

	self calculateTotal.
	self debitTotal.
	self registerSale.

	^ total! !


!Cashier methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 18:53'!
initializeToCheckout: aCart charging: aCreditCard throught: aMerchantProcessor registeringOn: aSalesBook
	
	cart := aCart.
	creditCard := aCreditCard.
	merchantProcessor := aMerchantProcessor.
	salesBook := aSalesBook! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cashier class' category: 'TusLibros'!
Cashier class
	instanceVariableNames: ''!

!Cashier class methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 18:22'!
assertIsNotEmpty: aCart 
	
	aCart isEmpty ifTrue: [self error: self cartCanNotBeEmptyErrorMessage ]! !

!Cashier class methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 18:23'!
assertIsNotExpired: aCreditCard on: aDate
	
	(aCreditCard isExpiredOn: aDate) ifTrue: [ self error: self canNotChargeAnExpiredCreditCardErrorMessage ]! !


!Cashier class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 18:51'!
toCheckout: aCart charging: aCreditCard throught: aMerchantProcessor on: aDate registeringOn: aSalesBook
	
	self assertIsNotEmpty: aCart.
	self assertIsNotExpired: aCreditCard on: aDate.
	
	^self new initializeToCheckout: aCart charging: aCreditCard throught: aMerchantProcessor registeringOn: aSalesBook! !


!Cashier class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 18:21'!
canNotChargeAnExpiredCreditCardErrorMessage
	
	^'Can not charge an expired credit card'! !

!Cashier class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 17:56'!
cartCanNotBeEmptyErrorMessage
	
	^'Can not check out an empty cart'! !

!Cashier class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 19:02'!
creditCardHasNoCreditErrorMessage
	
	^'Credit card has no credit'! !


!classDefinition: #ClientInterface category: 'TusLibros'!
Object subclass: #ClientInterface
	instanceVariableNames: 'purchasesList totalAmount'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!ClientInterface methodsFor: 'purchases' stamp: 'MR 11/11/2021 15:40:57'!
addPurchase: aCartId withAmount: aTotalAmount

	purchasesList add: aCartId.
	totalAmount _ totalAmount + aTotalAmount.! !

!ClientInterface methodsFor: 'purchases' stamp: 'MR 11/11/2021 15:45:59'!
listPurchases: aTusLibrosInterface

	| result |
	
	result _ Dictionary new.
	
	purchasesList do: [:aCartId | | purchase | 
		purchase _ aTusLibrosInterface itemsOfCart: aCartId.
		
		purchase asSet do: [:aBookIsbn | 
			result at: aBookIsbn ifAbsent: [result add: aBookIsbn->0].
			result at: aBookIsbn put: ((result at: aBookIsbn) + (purchase occurrencesOf: aBookIsbn)).
		]
	].

	^result.! !


!ClientInterface methodsFor: 'initialization' stamp: 'MR 11/11/2021 15:41:10'!
initialize
	purchasesList := OrderedCollection new.
	totalAmount := 0.! !


!classDefinition: #CreditCard category: 'TusLibros'!
Object subclass: #CreditCard
	instanceVariableNames: 'expiration'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CreditCard methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 18:39'!
isExpiredOn: aDate 
	
	^expiration start < (Month month: aDate monthIndex year: aDate yearNumber) start ! !


!CreditCard methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 18:38'!
initializeExpiringOn: aMonth 
	
	expiration := aMonth ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CreditCard class' category: 'TusLibros'!
CreditCard class
	instanceVariableNames: ''!

!CreditCard class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 18:38'!
expiringOn: aMonth 
	
	^self new initializeExpiringOn: aMonth! !


!classDefinition: #Sale category: 'TusLibros'!
Object subclass: #Sale
	instanceVariableNames: 'total'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Sale methodsFor: 'total' stamp: 'HernanWilkinson 6/17/2013 18:48'!
total
	
	^ total! !


!Sale methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 18:47'!
initializeTotal: aTotal

	total := aTotal ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Sale class' category: 'TusLibros'!
Sale class
	instanceVariableNames: ''!

!Sale class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 18:47'!
of: aTotal

	"should assert total is not negative or 0!!"
	^self new initializeTotal: aTotal ! !


!classDefinition: #StoreTestObjectsFactory category: 'TusLibros'!
Object subclass: #StoreTestObjectsFactory
	instanceVariableNames: 'today'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'HernanWilkinson 6/17/2013 18:08'!
itemNotSellByTheStore
	
	^'invalidBook'! !

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'HernanWilkinson 6/17/2013 18:08'!
itemSellByTheStore
	
	^ 'validBook'! !

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'HernanWilkinson 6/17/2013 18:08'!
itemSellByTheStorePrice
	
	^10! !


!StoreTestObjectsFactory methodsFor: 'cart' stamp: 'HernanWilkinson 6/17/2013 18:08'!
createCart
	
	^Cart acceptingItemsOf: self defaultCatalog! !

!StoreTestObjectsFactory methodsFor: 'cart' stamp: 'RI 11/9/2021 16:40:45'!
defaultCatalog
	
	^ Dictionary new
		at: self itemSellByTheStore put: self itemSellByTheStorePrice;
		yourself ! !


!StoreTestObjectsFactory methodsFor: 'credit card' stamp: 'HernanWilkinson 6/17/2013 18:37'!
expiredCreditCard
	
	^CreditCard expiringOn: (Month month: today monthIndex year: today yearNumber - 1)! !

!StoreTestObjectsFactory methodsFor: 'credit card' stamp: 'HernanWilkinson 6/17/2013 18:36'!
notExpiredCreditCard
	
	^CreditCard expiringOn: (Month month: today monthIndex year: today yearNumber + 1)! !


!StoreTestObjectsFactory methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 18:37'!
initialize

	today := DateAndTime now! !


!StoreTestObjectsFactory methodsFor: 'date' stamp: 'HernanWilkinson 6/17/2013 18:37'!
today
	
	^ today! !


!classDefinition: #TusLibrosInterface category: 'TusLibros'!
Object subclass: #TusLibrosInterface
	instanceVariableNames: 'nextCartId catalogue restApi transactionsIds clients activeCarts checkedOutCarts'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!TusLibrosInterface methodsFor: 'operations' stamp: 'MR 11/11/2021 16:06:37'!
addToCart: aCartId item: anItem amount: anAmount
	
	| cartInterface |
	
	self assertActiveCart: aCartId.
	
	cartInterface _ (activeCarts at: aCartId).
	
	cartInterface add: anAmount of: anItem.
	
	cartInterface modifiedAt: (restApi currentTime).
	! !

!TusLibrosInterface methodsFor: 'operations' stamp: 'MR 11/11/2021 16:32:35'!
addTransaction
	| transactionId |
	
	transactionId _ transactionsIds size + 1.
	
	transactionsIds add: transactionId.
	
	^transactionId.! !

!TusLibrosInterface methodsFor: 'operations' stamp: 'MR 11/11/2021 16:32:41'!
checkout: aCartId charging: aCreditCard 
	
	| cartInterface cashier totalAmount client |
	
	self assertActiveCart: aCartId.
	
	cartInterface _ activeCarts at: aCartId.
	cashier _ Cashier toCheckout: (cartInterface cart) charging: aCreditCard throught: restApi on: restApi today registeringOn: OrderedCollection new.
	totalAmount _ cashier checkOut.
	
	client _ clients at: cartInterface clientId.
	client addPurchase: aCartId withAmount: totalAmount.
	
	self moveCartToCheckoutList: aCartId withInterface: cartInterface.
	
	^self addTransaction.! !

!TusLibrosInterface methodsFor: 'operations' stamp: 'MR 11/11/2021 16:22:14'!
createCartFor: aClientId with: aPassword

	| cart cartInterface |
	
	restApi login: aClientId with: aPassword.
	
	cart _ Cart acceptingItemsOf: catalogue.
	
	cartInterface _ CartInterface cart: cart modifiedAt: restApi currentTime for: aClientId.
	
	nextCartId _ nextCartId + 1.
	
	activeCarts add: nextCartId -> cartInterface.
	
	^nextCartId.! !

!TusLibrosInterface methodsFor: 'operations' stamp: 'MR 11/11/2021 16:23:50'!
itemsOfCart: aCartId 

	| cartInformation |
	
	cartInformation _ checkedOutCarts at: aCartId ifAbsent: [^self error: TusLibrosInterface invalidCartErrorMessage].
	
	^cartInformation items.! !

!TusLibrosInterface methodsFor: 'operations' stamp: 'MR 11/11/2021 16:23:20'!
listCart: aCartId 

	| cartInformation |

	self assertActiveCart: aCartId.
	
	cartInformation _ activeCarts at: aCartId.
	
	cartInformation modifiedAt: (restApi currentTime).
	
	^cartInformation cart items.! !

!TusLibrosInterface methodsFor: 'operations' stamp: 'MR 11/11/2021 15:56:37'!
listPurchasesFor: aClientId with: aPassword 
	
	| result client |
	
	restApi login: aClientId with: aPassword.
	
	result _ Dictionary new.
	
	client _ clients at: aClientId ifAbsent: [^result].	

	^client listPurchases: self.! !

!TusLibrosInterface methodsFor: 'operations' stamp: 'MR 11/11/2021 16:32:13'!
moveCartToCheckoutList: aCartId withInterface: aCartInterface 
	checkedOutCarts add: aCartId -> aCartInterface.
	activeCarts removeKey: aCartId.! !


!TusLibrosInterface methodsFor: 'initialization' stamp: 'MR 11/11/2021 16:27:57'!
through: aRestApi withCatalogue: aCatalogue registeringOn: aTransactionList 

	restApi _ aRestApi.
	catalogue _ aCatalogue.
	transactionsIds _ aTransactionList.
	
	activeCarts _ Dictionary new.
	checkedOutCarts _ Dictionary new.
	clients _ Dictionary new.
	
	nextCartId _ 0.
	
	aRestApi clients do: [:aClientId | clients add: aClientId -> ClientInterface new].
	
	! !


!TusLibrosInterface methodsFor: 'assertions' stamp: 'MR 11/11/2021 16:28:49'!
assertActiveCart: aCartId
	
	| cart |
	
	cart _ activeCarts at: aCartId ifAbsent: [^self error: TusLibrosInterface invalidCartErrorMessage].
	
	cart isActiveAt: restApi currentTime.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TusLibrosInterface class' category: 'TusLibros'!
TusLibrosInterface class
	instanceVariableNames: ''!

!TusLibrosInterface class methodsFor: 'error messages' stamp: 'GRC 11/4/2021 20:56:37'!
invalidCartErrorMessage
	
	^'invalid cart'.! !

!TusLibrosInterface class methodsFor: 'error messages' stamp: 'GRC 11/4/2021 20:07:35'!
invalidLoginErrorMessage
	
	^'invalid username or password'.! !


!TusLibrosInterface class methodsFor: 'instance creation' stamp: 'GRC 11/8/2021 21:35:57'!
through: anAuthenticationSystem withCatalogue: aCatalog registeringOn: aTransactionsList
	
	^self new through: anAuthenticationSystem withCatalogue: aCatalog registeringOn: aTransactionsList.! !
