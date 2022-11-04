!classDefinition: #CartTest category: 'TusLibros'!
TestCase subclass: #CartTest
	instanceVariableNames: 'testObjectsFactory'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CartTest methodsFor: 'tests' stamp: 'MR 11/2/2021 15:18:19'!
test01NewCartsAreCreatedEmpty

	self assert: testObjectsFactory createCart isEmpty! !

!CartTest methodsFor: 'tests' stamp: 'MR 11/2/2021 15:57:09'!
test02CanNotAddItemsThatDoNotBelongToStore

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self 
		should: [ cart add: testObjectsFactory itemNotSellByTheStore ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidItemErrorMessage.
			self assert: cart isEmpty 
		]! !

!CartTest methodsFor: 'tests' stamp: 'MR 11/2/2021 15:18:27'!
test03AfterAddingAnItemTheCartIsNotEmptyAnymore

	| cart |
	
	cart := testObjectsFactory createCart.
	
	cart add: testObjectsFactory itemSellByTheStore.
	self deny: cart isEmpty ! !

!CartTest methodsFor: 'tests' stamp: 'MR 11/2/2021 15:18:53'!
test04CanNotAddNonPositiveNumberOfItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self 
		should: [cart add: 0 of: testObjectsFactory itemSellByTheStore ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidQuantityErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'MR 11/2/2021 15:18:58'!
test05CanNotAddMoreThanOneItemNotSellByTheStore

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self 
		should: [cart add: 2 of: testObjectsFactory itemNotSellByTheStore  ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'MR 11/2/2021 15:19:02'!
test06CartRemembersAddedItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	cart add: testObjectsFactory itemSellByTheStore.
	self assert: (cart includes: testObjectsFactory itemSellByTheStore)! !

!CartTest methodsFor: 'tests' stamp: 'MR 11/2/2021 15:19:05'!
test07CartDoesNotHoldNotAddedItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self deny: (cart includes: testObjectsFactory itemSellByTheStore)! !

!CartTest methodsFor: 'tests' stamp: 'MR 11/2/2021 15:19:10'!
test08CartRemembersTheNumberOfAddedItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	cart add: 2 of: testObjectsFactory itemSellByTheStore.
	self assert: (cart occurrencesOf: testObjectsFactory itemSellByTheStore) = 2! !


!CartTest methodsFor: 'setup' stamp: 'MR 11/2/2021 15:18:00'!
setUp

	testObjectsFactory := StoreTestObjectsFactory new.! !


!classDefinition: #CashierTest category: 'TusLibros'!
TestCase subclass: #CashierTest
	instanceVariableNames: 'testObjectsFactory merchantProcessor'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CashierTest methodsFor: 'tests' stamp: 'MR 11/4/2021 09:58:20'!
test09CashierCannotCheckoutEmptyCart
	| cart creditCard salesBook clientName |

	salesBook := Bag new.
	cart := testObjectsFactory createCart.
	creditCard := testObjectsFactory createValidCreditCard.
	clientName := creditCard name.

	self
		should: [Cashier toCheckout: cart withCreditCard: creditCard onDate: testObjectsFactory today registerAt: salesBook forClient: clientName andMerchantProcessor: merchantProcessor]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cashier invalidCheckoutErrorMessage.
		]! !

!CashierTest methodsFor: 'tests' stamp: 'MR 11/4/2021 09:58:28'!
test10CashierCheckoutCartWithMultipleItemsHasCorrectPrice
	| cart cashier creditCard salesBook |
	
	salesBook := Bag new.
	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSellByTheStore.
	cart add: testObjectsFactory itemSellByTheStore.
	
	creditCard := testObjectsFactory createValidCreditCard.
	
	cashier := Cashier toCheckout: cart withCreditCard: creditCard onDate: testObjectsFactory today registerAt: salesBook forClient: creditCard name andMerchantProcessor: merchantProcessor.
	
	self assert: 20 equals: (cashier checkout).! !

!CashierTest methodsFor: 'tests' stamp: 'MR 11/4/2021 09:58:48'!
test11CashierCannotCheckoutCartWithExpiredCreditCard
	| cart expiredCreditCard salesBook |
	
	salesBook := Bag new.
	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSellByTheStore.
	
	expiredCreditCard := testObjectsFactory createExpiredCreditCard.
	
	self 
		should: [Cashier toCheckout: cart withCreditCard: expiredCreditCard onDate: testObjectsFactory today registerAt: salesBook forClient: expiredCreditCard name andMerchantProcessor: merchantProcessor]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cashier invalidCheckoutErrorMessage.
		]! !

!CashierTest methodsFor: 'tests' stamp: 'MR 11/4/2021 09:58:51'!
test12CashierCheckoutAddsBooksToSalesBook
	| cart cashier creditCard salesBook |
	
	salesBook := Bag new.
	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSellByTheStore.
	cart add: testObjectsFactory itemSellByTheStore.
	
	creditCard := testObjectsFactory createValidCreditCard.

	cashier := Cashier toCheckout: cart withCreditCard: creditCard onDate: testObjectsFactory today registerAt: salesBook forClient: creditCard name andMerchantProcessor: merchantProcessor.
	cashier checkout.
	
	self assert: 2 equals: (salesBook occurrencesOf: testObjectsFactory itemSellByTheStore).
	
! !

!CashierTest methodsFor: 'tests' stamp: 'MR 11/4/2021 09:58:54'!
test13CashierCannotCheckoutWhenCreditCardHasNotEnoughFunds
	| cart cashier creditCard salesBook |
	
	salesBook := Bag new.
	cart := testObjectsFactory createCart.
	10 timesRepeat: [cart add: testObjectsFactory itemSellByTheStore.].
	
	creditCard := testObjectsFactory createValidCreditCard.

	cashier := Cashier toCheckout: cart withCreditCard: creditCard onDate: testObjectsFactory today registerAt: salesBook forClient: creditCard name andMerchantProcessor: merchantProcessor.
	
	self 
		should: [cashier checkout]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cashier invalidCheckoutErrorMessage.
		].
	
! !

!CashierTest methodsFor: 'tests' stamp: 'MR 11/4/2021 09:58:59'!
test14CashierCannotCheckoutWhenClientIsNotCreditCardOwner
	| cart cashier creditCard salesBook clientName |
	
	salesBook := Bag new.
	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSellByTheStore.
	
	creditCard := testObjectsFactory createValidCreditCard.
	clientName := 'Pepe'.
	
	cashier := Cashier toCheckout: cart withCreditCard: creditCard onDate: testObjectsFactory today registerAt: salesBook forClient: clientName andMerchantProcessor: merchantProcessor.
	
	self 
		should: [cashier checkout]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cashier invalidCheckoutErrorMessage.
		].
	
! !

!CashierTest methodsFor: 'tests' stamp: 'MR 11/4/2021 09:59:03'!
test15CashierCheckoutsCorrectlyWithValidCreditCardAndClient
	| cart cashier creditCard salesBook |
	
	salesBook := Bag new.
	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSellByTheStore.
	
	creditCard := testObjectsFactory createValidCreditCard.

	cashier := Cashier toCheckout: cart withCreditCard: creditCard onDate: testObjectsFactory today registerAt: salesBook forClient: creditCard name andMerchantProcessor: merchantProcessor.
	
	self assert: 10 equals: cashier checkout.
	
! !

!CashierTest methodsFor: 'tests' stamp: 'MR 11/4/2021 10:46:14'!
test16CashierCannotCheckoutWhenCreditCardDoesNotExist
	| cart cashier invalidCreditCard salesBook |
	
	salesBook := Bag new.
	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSellByTheStore.
	
	invalidCreditCard := testObjectsFactory createInvalidCreditCard.
	
	cashier := Cashier toCheckout: cart withCreditCard: invalidCreditCard onDate: testObjectsFactory today registerAt: salesBook forClient: invalidCreditCard name andMerchantProcessor: merchantProcessor.
	
	self 
		should: [cashier checkout]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cashier invalidCheckoutErrorMessage.
		].
	
! !


!CashierTest methodsFor: 'setup' stamp: 'MR 11/4/2021 09:54:17'!
setUp

	testObjectsFactory := StoreTestObjectsFactory new.
	merchantProcessor := MerchantProcessorSimulator new.! !


!classDefinition: #MerchantProcessorSimulator category: 'TusLibros'!
TestCase subclass: #MerchantProcessorSimulator
	instanceVariableNames: 'creditCards'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!MerchantProcessorSimulator methodsFor: 'debiting' stamp: 'MR 11/4/2021 10:44:44'!
debit: aTransactionAmount on: aCreditCard forClient: aClientName 
	
	(self assertCardExists: aCreditCard) ifFalse: [^'1|Credit card does not exist'].
	(self assertCardHasEnoughFunds: aCreditCard for: aTransactionAmount) ifFalse: [^'1|Credit card has no funds'].
	(self assertCardIsNotStolen: aCreditCard usedBy: aClientName) ifFalse: [^'1|Client is not credit card owner'].

	^'0|OK'.! !


!MerchantProcessorSimulator methodsFor: 'asserting' stamp: 'MR 11/4/2021 10:44:33'!
assertCardExists: aCreditCard
	^creditCards includesKey: (aCreditCard number).! !

!MerchantProcessorSimulator methodsFor: 'asserting' stamp: 'MR 11/4/2021 11:02:10'!
assertCardHasEnoughFunds: aCreditCard for: aTransactionAmount.
	^(creditCards at: (aCreditCard number)) >= aTransactionAmount.! !

!MerchantProcessorSimulator methodsFor: 'asserting' stamp: 'MR 11/4/2021 10:43:41'!
assertCardIsNotStolen: aCreditCard usedBy: aClientName.
	^aCreditCard belongsTo: aClientName.! !


!MerchantProcessorSimulator methodsFor: 'initialization' stamp: 'MR 11/4/2021 10:29:12'!
initialize

	creditCards := Dictionary new.
	
	creditCards 
		add: 4545565667677878 -> 50;
	 	add: 4545565667677879 -> 30;
	 	add: 4545565667677877 -> 0.! !


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


!Cart methodsFor: 'assertions' stamp: 'MR 11/1/2021 19:38:04'!
assertIsValidItem: anItem

	(catalog includesKey: anItem) ifFalse: [ self error: self invalidItemErrorMessage ]! !

!Cart methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 17:51'!
assertIsValidQuantity: aQuantity

	aQuantity strictlyPositive ifFalse: [ self error: self invalidQuantityErrorMessage ]! !


!Cart methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 17:48'!
initializeAcceptingItemsOf: aCatalog

	catalog := aCatalog.
	items := OrderedCollection new.! !


!Cart methodsFor: 'queries' stamp: 'MR 11/4/2021 10:57:58'!
calculatePrice
	^items inject: 0 into: [:itemsTotal :anItem | itemsTotal + catalog at: anItem].
	! !

!Cart methodsFor: 'queries' stamp: 'MR 11/1/2021 19:46:47'!
items

	^items.! !

!Cart methodsFor: 'queries' stamp: 'HernanWilkinson 6/17/2013 17:45'!
occurrencesOf: anItem

	^items occurrencesOf: anItem  ! !


!Cart methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 17:44'!
includes: anItem

	^items includes: anItem ! !

!Cart methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 17:44'!
isEmpty
	
	^items isEmpty ! !


!Cart methodsFor: 'adding' stamp: 'HernanWilkinson 6/17/2013 17:44'!
add: anItem

	^ self add: 1 of: anItem ! !

!Cart methodsFor: 'adding' stamp: 'HernanWilkinson 6/17/2013 17:51'!
add: aQuantity of: anItem

	self assertIsValidQuantity: aQuantity.
	self assertIsValidItem: anItem.

	1 to: aQuantity do: [ :aNumber | items add: anItem ]! !


!Cart methodsFor: 'checkout - private' stamp: 'MR 11/4/2021 10:58:02'!
registerItemsOn: aSalesBook
	aSalesBook addAll: items.
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: 'TusLibros'!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 17:48'!
acceptingItemsOf: aCatalog

	^self new initializeAcceptingItemsOf: aCatalog ! !


!Cart class methodsFor: 'category-name' stamp: 'MR 11/1/2021 19:28:58'!
invalidCheckoutErrorMessage
	^'Cannot checkout this cart'.! !


!classDefinition: #Cashier category: 'TusLibros'!
Object subclass: #Cashier
	instanceVariableNames: 'catalog cart creditCard date salesBook clientName merchantProcessor'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cashier methodsFor: 'checkout' stamp: 'MR 11/4/2021 11:00:19'!
checkout
	| price result |
		
	cart registerItemsOn: salesBook.
	
	price _ cart calculatePrice.
	result _ merchantProcessor debit: price on: creditCard forClient: clientName.
	
	(result = '0|OK') ifTrue: [^price].
	^self error: Cashier invalidCheckoutErrorMessage.! !


!Cashier methodsFor: 'initialization' stamp: 'MR 11/4/2021 09:59:24'!
initializeToCheckout: aCart withCreditCard: aCreditCard onDate: aDate registerAt: aSalesBook forClient: aClientName andMerchantProcessor: aMerchantProcessor  
	cart := aCart.
	creditCard := aCreditCard.
	date := aDate.
	salesBook := aSalesBook.
	clientName := aClientName.
	merchantProcessor := aMerchantProcessor.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cashier class' category: 'TusLibros'!
Cashier class
	instanceVariableNames: ''!

!Cashier class methodsFor: 'instance creation' stamp: 'MR 11/4/2021 10:48:50'!
toCheckout: aCart withCreditCard: aCreditCard onDate: aDate registerAt: aSalesBook forClient: aClientName andMerchantProcessor: aMerchantProcessor   

	self assertCardIsNotExpired: aCreditCard on: aDate.
	self assertCartIsNotEmpty: aCart.

	^self new initializeToCheckout: aCart withCreditCard: aCreditCard onDate: aDate registerAt: aSalesBook forClient: aClientName andMerchantProcessor: aMerchantProcessor.! !


!Cashier class methodsFor: 'error messages' stamp: 'MR 11/1/2021 19:47:38'!
invalidCheckoutErrorMessage
	^'Carrito invalido'.! !


!Cashier class methodsFor: 'asserting' stamp: 'MR 11/4/2021 10:48:50'!
assertCardIsNotExpired: aCreditCard on: aDate

	^(aCreditCard isValidOn: aDate) ifFalse: [^self error: Cashier invalidCheckoutErrorMessage].! !

!Cashier class methodsFor: 'asserting' stamp: 'MR 11/4/2021 10:48:41'!
assertCartIsNotEmpty: aCart

	aCart isEmpty ifTrue: [^self error: Cashier invalidCheckoutErrorMessage.].! !


!classDefinition: #CreditCard category: 'TusLibros'!
Object subclass: #CreditCard
	instanceVariableNames: 'name number expirationDate'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CreditCard methodsFor: 'initialization' stamp: 'MR 11/4/2021 10:34:17'!
initializeWithName: aName number: aNumber expirationMonth: anExpirationMonth expirationYear: anExpirationYear
	name _ aName.
	number _ aNumber.	
	expirationDate := GregorianMonthOfYear 
					year: (GregorianYear number: (anExpirationYear)) 
					month: (GregorianMonth numbered: (anExpirationMonth))! !


!CreditCard methodsFor: 'accessing' stamp: 'MR 11/4/2021 09:45:47'!
name
	^name.! !

!CreditCard methodsFor: 'accessing' stamp: 'MR 11/4/2021 09:45:50'!
number
	^number.! !


!CreditCard methodsFor: 'queries' stamp: 'MR 11/4/2021 10:31:18'!
belongsTo: aName

	^aName = name.! !

!CreditCard methodsFor: 'queries' stamp: 'MR 11/4/2021 10:36:09'!
isValidOn: aDate
	
	^aDate <= expirationDate.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CreditCard class' category: 'TusLibros'!
CreditCard class
	instanceVariableNames: ''!

!CreditCard class methodsFor: 'initialization' stamp: 'MR 11/4/2021 09:44:56'!
withName: aName number: aNumber expirationMonth: anExpirationMonth expirationYear: anExpirationYear
	^self new initializeWithName: aName number: aNumber expirationMonth: anExpirationMonth expirationYear: anExpirationYear.! !


!classDefinition: #StoreTestObjectsFactory category: 'TusLibros'!
Object subclass: #StoreTestObjectsFactory
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!StoreTestObjectsFactory methodsFor: 'creation' stamp: 'MR 11/2/2021 15:16:42'!
createCart
	
	^Cart acceptingItemsOf: self defaultCatalog! !

!StoreTestObjectsFactory methodsFor: 'creation' stamp: 'MR 11/4/2021 09:48:09'!
createExpiredCreditCard

	^CreditCard 
		withName: 'Mike Wazowsky'
		number: 4545565667677878
		expirationMonth: 02
		expirationYear: 2020.! !

!StoreTestObjectsFactory methodsFor: 'creation' stamp: 'MR 11/4/2021 10:46:28'!
createInvalidCreditCard

	^CreditCard 
		withName: 'Mike Wazowsky'
		number: 4545565667677810
		expirationMonth: 02
		expirationYear: 2025.! !

!StoreTestObjectsFactory methodsFor: 'creation' stamp: 'MR 11/4/2021 09:48:32'!
createValidCreditCard

	^CreditCard 
		withName: 'Mike Wazowsky'
		number: 4545565667677878
		expirationMonth: 02
		expirationYear: 2025.! !

!StoreTestObjectsFactory methodsFor: 'creation' stamp: 'MR 11/2/2021 15:16:27'!
defaultCatalog
	
	| dict |
	dict _ Dictionary new.
	
	dict at: self itemSellByTheStore put: 10.
	
	^dict.! !

!StoreTestObjectsFactory methodsFor: 'creation' stamp: 'MR 11/2/2021 15:16:15'!
itemNotSellByTheStore
	
	^'invalidBook'! !

!StoreTestObjectsFactory methodsFor: 'creation' stamp: 'MR 11/2/2021 15:15:59'!
itemSellByTheStore
	
	^ 'validBook'! !

!StoreTestObjectsFactory methodsFor: 'creation' stamp: 'MR 11/2/2021 15:35:03'!
today
	^GregorianMonthOfYear current.! !
