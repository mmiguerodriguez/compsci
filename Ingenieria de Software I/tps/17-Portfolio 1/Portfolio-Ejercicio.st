!classDefinition: #PortfolioTest category: 'Portfolio-Ejercicio'!
TestCase subclass: #PortfolioTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!PortfolioTest methodsFor: 'tests' stamp: 'RI 10/15/2021 15:32:03'!
test01PortfolioStartsWithBalanceOfZero

	| portfolio |
	
	portfolio _ self createPortfolioWithAccounts: {} andPortfolios: {}.
	
	self assert: 0 equals: portfolio balance.! !

!PortfolioTest methodsFor: 'tests' stamp: 'GRC 10/15/2021 20:00:13'!
test02PortfolioWithMultipleAccountsHasSumOfBalances

	| portfolio cuenta1 cuenta2 |
	
	cuenta1 _ self createAccountWithDepositAmounts: {50} andWithdrawalAmounts: {}.
	cuenta2 _ self createAccountWithDepositAmounts: {100} andWithdrawalAmounts: {}.
	portfolio _ self createPortfolioWithAccounts: {cuenta1. cuenta2} andPortfolios: {}.
	
	self assert: 150 equals: portfolio balance.! !

!PortfolioTest methodsFor: 'tests' stamp: 'GRC 10/15/2021 20:00:18'!
test03PortfolioWithPorfolioHasSumOfBalances

	| portfolio1 portfolio2 cuenta1 cuenta2 |
	
	cuenta1 _ self createAccountWithDepositAmounts: {50} andWithdrawalAmounts: {}.
	cuenta2 _ self createAccountWithDepositAmounts: {100} andWithdrawalAmounts: {}.
	portfolio2 _ self createPortfolioWithAccounts: {cuenta2} andPortfolios: {}.
	portfolio1 _ self createPortfolioWithAccounts: {cuenta1} andPortfolios: {portfolio2}.
	
	self assert: 150 equals: portfolio1 balance.! !

!PortfolioTest methodsFor: 'tests' stamp: 'GRC 10/15/2021 20:00:23'!
test04PortfolioStartsWithNoTransactions

	| portfolio |
	
	portfolio _ self createPortfolioWithAccounts: {} andPortfolios: {}.
	
	self assert: portfolio transactions isEmpty.! !

!PortfolioTest methodsFor: 'tests' stamp: 'GRC 10/15/2021 20:00:29'!
test05PortfolioHasAccountsTransactions

	| portfolio cuenta1 cuenta2 transacciones |
	
	transacciones _ OrderedCollection new. 
	
	cuenta1 _ self createAccountWithDepositAmounts: {50} andWithdrawalAmounts: {}.
	cuenta2 _ self createAccountWithDepositAmounts: {100. 10} andWithdrawalAmounts: {}.
	
	transacciones addAll: cuenta1 transactions.
	transacciones addAll: cuenta2 transactions.
	
	portfolio _ self createPortfolioWithAccounts: {cuenta1. cuenta2} andPortfolios: {}.
		
	self assert: transacciones equals: portfolio transactions.! !

!PortfolioTest methodsFor: 'tests' stamp: 'GRC 10/15/2021 20:00:34'!
test06PortfolioHasPortfoliosTransactions

	| portfolio1 portfolio2 cuenta1 cuenta2 transacciones |
	
	transacciones _ OrderedCollection new. 
	
	cuenta1 _ self createAccountWithDepositAmounts: {50} andWithdrawalAmounts: {}.
	cuenta2 _ self createAccountWithDepositAmounts: {100. 10} andWithdrawalAmounts: {}.
	
	transacciones addAll: cuenta1 transactions.
	transacciones addAll: cuenta2 transactions.
	
	portfolio2 _ self createPortfolioWithAccounts: {cuenta2} andPortfolios: {}. 
	portfolio1 _ self createPortfolioWithAccounts: {cuenta1} andPortfolios: {portfolio2}.
	
	self assert: transacciones equals: portfolio1 transactions.! !

!PortfolioTest methodsFor: 'tests' stamp: 'GRC 10/15/2021 20:00:41'!
test07PortfolioCannotAddItself

	| portfolio |
	
	portfolio _ self createPortfolioWithAccounts: {} andPortfolios: {}.
	
	self should: [portfolio add: portfolio] 
		raise: Error
		withExceptionDo: [:anError | self assert: FinancialService cannotAddExistingServiceErrorDescription equals: anError messageText].! !

!PortfolioTest methodsFor: 'tests' stamp: 'MR 10/18/2021 14:35:18'!
test08PortfolioCannotAddAPortfolioThatContainsIt

	| portfolio1 portfolio2 |
	
	portfolio1 _ self createPortfolioWithAccounts: {} andPortfolios: {}.
	portfolio2 _ self createPortfolioWithAccounts: {} andPortfolios: {portfolio1}.
	
	self should: [portfolio1 add: portfolio2]
		raise: Error
		withExceptionDo: [:anError | self assert: FinancialService cannotAddExistingServiceErrorDescription equals: anError messageText].! !

!PortfolioTest methodsFor: 'tests' stamp: 'GRC 10/15/2021 20:00:56'!
test09PortfolioCannotAddExistingAccount

	| portfolio cuenta |
	
	cuenta _ self createAccountWithDepositAmounts: {} andWithdrawalAmounts: {}.
	portfolio _ self createPortfolioWithAccounts: {cuenta} andPortfolios: {}.
		
	self should: [portfolio add: cuenta]
		raise: Error
		withExceptionDo: [:anError | self assert: FinancialService cannotAddExistingServiceErrorDescription equals: anError messageText].! !

!PortfolioTest methodsFor: 'tests' stamp: 'GRC 10/15/2021 20:01:01'!
test10PortfolioCannotAddAccountExistingInPortfolioGroup

	| portfolio1 portfolio2 cuenta |
	
	cuenta _ self createAccountWithDepositAmounts: {} andWithdrawalAmounts: {}.
	portfolio2 _ self createPortfolioWithAccounts: {cuenta} andPortfolios: {}.
	portfolio1 _ self createPortfolioWithAccounts: {} andPortfolios: {portfolio2 }.
	
	self should: [portfolio1 add: cuenta]
		raise: Error
		withExceptionDo: [:anError | self assert: FinancialService cannotAddExistingServiceErrorDescription equals: anError messageText].! !

!PortfolioTest methodsFor: 'tests' stamp: 'GRC 10/15/2021 20:01:06'!
test11PortfolioCannotAddPortfolioWithExistingAccount

	| portfolio1 portfolio2 portfolio3 cuenta |
	
	cuenta _ self createAccountWithDepositAmounts: {} andWithdrawalAmounts: {}.
	portfolio3 _ self createPortfolioWithAccounts: {cuenta} andPortfolios: {}.
	portfolio2 _ self createPortfolioWithAccounts: {} andPortfolios: {portfolio3}.
	portfolio1 _ self createPortfolioWithAccounts: {cuenta} andPortfolios: {}.
	
	self should: [portfolio1 add: portfolio2]
		raise: Error
		withExceptionDo: [:anError | self assert: FinancialService cannotAddExistingServiceErrorDescription equals: anError messageText].! !

!PortfolioTest methodsFor: 'tests' stamp: 'GRC 10/15/2021 20:01:10'!
test12PortfolioStartsWithNoRegisteredTransactions

	| portfolio cuenta transaccion |
	
	portfolio _ self createPortfolioWithAccounts: {} andPortfolios: {}.
	cuenta _ self createAccountWithDepositAmounts: {50} andWithdrawalAmounts: {}.
	
	transaccion _ cuenta transactions first.
	
	self deny: (portfolio hasRegistered: transaccion).! !

!PortfolioTest methodsFor: 'tests' stamp: 'GRC 10/15/2021 20:01:15'!
test13PortfolioHasAccountTransactionsRegistered

	| portfolio cuenta transaccion |
	
	cuenta _ self createAccountWithDepositAmounts: {50} andWithdrawalAmounts: {}.
	portfolio _ self createPortfolioWithAccounts: {cuenta} andPortfolios: {}.
	
	transaccion _ cuenta transactions first.
	
	self assert: (portfolio hasRegistered: transaccion).! !

!PortfolioTest methodsFor: 'tests' stamp: 'GRC 10/15/2021 20:01:19'!
test14PortfolioHasPortfoliosTransactionsRegistered

	| portfolio1 portfolio2 portfolio3 cuenta transaccion |
	
	cuenta _ self createAccountWithDepositAmounts: {50} andWithdrawalAmounts: {}.
	portfolio3 _ self createPortfolioWithAccounts: {cuenta} andPortfolios: {}.
	portfolio2 _ self createPortfolioWithAccounts: {} andPortfolios: {portfolio3}.
	portfolio1 _ self createPortfolioWithAccounts: {} andPortfolios: {portfolio2}.
	
	transaccion _ cuenta transactions first .
	
	self assert: (portfolio1 hasRegistered: transaccion).! !

!PortfolioTest methodsFor: 'tests' stamp: 'GRC 10/15/2021 20:02:14'!
test15PortfolioCannotAddPortfolioWithExistingAccountInTree

	| portfolio1 portfolio2 portfolio3 portfolio4 cuenta1 cuenta2 |
	
	cuenta1 _ self createAccountWithDepositAmounts: {50} andWithdrawalAmounts: {}.
	cuenta2 _ self createAccountWithDepositAmounts: {100} andWithdrawalAmounts: {}.
	
	portfolio3 _ self createPortfolioWithAccounts: {cuenta1} andPortfolios: {}.
	portfolio1 _ self createPortfolioWithAccounts: {} andPortfolios: {portfolio3}.
	portfolio2 _ self createPortfolioWithAccounts: {cuenta2} andPortfolios: {portfolio3}.
	
	portfolio4 _ self createPortfolioWithAccounts: {cuenta2} andPortfolios: {}.
	
	self should: [portfolio3 add: portfolio4]
		raise: Error
		withExceptionDo: [:anError | self assert: FinancialService cannotAddExistingServiceErrorDescription equals: anError messageText].! !

!PortfolioTest methodsFor: 'tests' stamp: 'GRC 10/15/2021 20:02:49'!
test16PortfolioCannotAddExistingAccountInTree

	| portfolio1 portfolio2 portfolio3 portfolio4 cuenta1 cuenta2 |
	
	cuenta1 _ self createAccountWithDepositAmounts: {50} andWithdrawalAmounts: {}.
	cuenta2 _ self createAccountWithDepositAmounts: {100} andWithdrawalAmounts: {}.
	
	portfolio3 _ self createPortfolioWithAccounts: {cuenta1} andPortfolios: {}.
	portfolio1 _ self createPortfolioWithAccounts: {} andPortfolios: {portfolio3}.
	portfolio2 _ self createPortfolioWithAccounts: {cuenta2} andPortfolios: {portfolio3}.
	
	self should: [portfolio3 add: cuenta2]
		raise: Error
		withExceptionDo: [:anError | self assert: FinancialService cannotAddExistingServiceErrorDescription equals: anError messageText].! !


!PortfolioTest methodsFor: 'creation' stamp: 'RI 10/15/2021 15:10:43'!
createAccountWithDepositAmounts: aDepositAmountsList andWithdrawalAmounts: aWithdrawalAmountsList 
	
	| account |
	account _ ReceptiveAccount new.
	
	aDepositAmountsList do: [:anAmount | Deposit register: anAmount on: account ].
	aWithdrawalAmountsList do: [:anAmount | Withdraw register: anAmount on: account ].
	
	^account.! !

!PortfolioTest methodsFor: 'creation' stamp: 'GRC 10/15/2021 18:34:29'!
createPortfolioWithAccounts: anAccountsList andPortfolios: aPortfoliosList 
	
	| portfolio |
	portfolio _ Portfolio new.
	
	anAccountsList do: [:anAccount | portfolio add: anAccount ].
	aPortfoliosList do: [:aPortfolio| portfolio add: aPortfolio ].
	
	^portfolio.! !


!classDefinition: #ReceptiveAccountTest category: 'Portfolio-Ejercicio'!
TestCase subclass: #ReceptiveAccountTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:13:44'!
test01ReceptiveAccountHaveZeroAsBalanceWhenCreated 

	| account |
	
	account := ReceptiveAccount new.

	self assert: 0 equals: account balance.
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:13:48'!
test02DepositIncreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount  new.
	Deposit register: 100 on: account.
		
	self assert: 100 equals: account balance.
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:13:52'!
test03WithdrawDecreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	Withdraw register: 50 on: account.
		
	self assert: 50 equals: account balance.
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:32'!
test04WithdrawValueMustBePositive 

	| account withdrawValue |
	
	account := ReceptiveAccount new.
	withdrawValue := 50.
	
	self assert: withdrawValue equals: (Withdraw register: withdrawValue on: account) value
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:46'!
test05ReceptiveAccountKnowsRegisteredTransactions 

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 on: account.
	withdraw := Withdraw register: 50 on: account.
		
	self assert: (account hasRegistered: deposit).
	self assert: (account hasRegistered: withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 5/17/2021 17:29:53'!
test06ReceptiveAccountDoNotKnowNotRegisteredTransactions

	| deposit withdraw account |
	
	account := ReceptiveAccount new.
	deposit :=  Deposit for: 200.
	withdraw := Withdraw for: 50.
		
	self deny: (account hasRegistered: deposit).
	self deny: (account hasRegistered:withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:14:01'!
test07AccountKnowsItsTransactions 

	| account1 deposit1 |
	
	account1 := ReceptiveAccount new.
	
	deposit1 := Deposit register: 50 on: account1.
		
	self assert: 1 equals: account1 transactions size.
	self assert: (account1 transactions includes: deposit1).
! !


!classDefinition: #AccountTransaction category: 'Portfolio-Ejercicio'!
Object subclass: #AccountTransaction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!AccountTransaction methodsFor: 'value' stamp: 'HernanWilkinson 9/12/2011 12:25'!
value 

	self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountTransaction class' category: 'Portfolio-Ejercicio'!
AccountTransaction class
	instanceVariableNames: ''!

!AccountTransaction class methodsFor: 'instance creation' stamp: 'NR 10/17/2019 03:22:00'!
register: aValue on: account

	| transaction |
	
	transaction := self for: aValue.
	account register: transaction.
		
	^ transaction! !


!classDefinition: #Deposit category: 'Portfolio-Ejercicio'!
AccountTransaction subclass: #Deposit
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Deposit methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:45'!
initializeFor: aValue

	value := aValue ! !


!Deposit methodsFor: 'value' stamp: 'GRC 10/14/2021 21:33:58'!
addToBalance: aBalance

	^aBalance + value.! !

!Deposit methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:38'!
value

	^ value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Deposit class' category: 'Portfolio-Ejercicio'!
Deposit class
	instanceVariableNames: ''!

!Deposit class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:38'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #Withdraw category: 'Portfolio-Ejercicio'!
AccountTransaction subclass: #Withdraw
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Withdraw methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:46'!
initializeFor: aValue

	value := aValue ! !


!Withdraw methodsFor: 'value' stamp: 'GRC 10/14/2021 21:33:39'!
addToBalance: aBalance

	^aBalance - value.! !

!Withdraw methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:33'!
value

	^ value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Withdraw class' category: 'Portfolio-Ejercicio'!
Withdraw class
	instanceVariableNames: ''!

!Withdraw class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:33'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #FinancialService category: 'Portfolio-Ejercicio'!
Object subclass: #FinancialService
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!FinancialService methodsFor: 'assertions' stamp: 'MR 10/18/2021 15:44:20'!
noNodesInCommon: aFinancialServiceToAdd

	(self = aFinancialServiceToAdd) ifTrue: [self error: FinancialService cannotAddExistingServiceErrorDescription].! !

!FinancialService methodsFor: 'assertions' stamp: 'MR 10/18/2021 14:46:44'!
notIncludedInTree: aFinancialServiceToAdd

	self subclassResponsibility.! !


!FinancialService methodsFor: 'accessing' stamp: 'GRC 10/15/2021 19:58:47'!
balance

	self subclassResponsibility.! !

!FinancialService methodsFor: 'accessing' stamp: 'GRC 10/15/2021 19:59:15'!
hasRegistered: aTransaction

	self subclassResponsibility.! !

!FinancialService methodsFor: 'accessing' stamp: 'GRC 10/15/2021 19:59:56'!
transactions

	self subclassResponsibility.! !


!FinancialService methodsFor: 'initialization' stamp: 'GRC 10/15/2021 19:59:47'!
initialize

	self subclassResponsibility.! !


!FinancialService methodsFor: 'adding' stamp: 'GRC 10/15/2021 19:58:27'!
add: aFinancialService	

	self subclassResponsibility.! !

!FinancialService methodsFor: 'adding' stamp: 'MR 10/18/2021 14:20:39'!
addParent: aPortfolio! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'FinancialService class' category: 'Portfolio-Ejercicio'!
FinancialService class
	instanceVariableNames: ''!

!FinancialService class methodsFor: 'errors' stamp: 'GRC 10/15/2021 18:44:27'!
cannotAddExistingServiceErrorDescription

	^'Cannot add existing financial service'.! !


!classDefinition: #Portfolio category: 'Portfolio-Ejercicio'!
FinancialService subclass: #Portfolio
	instanceVariableNames: 'parentPortfolios financialServices'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Portfolio methodsFor: 'assertions' stamp: 'MR 10/18/2021 15:44:20'!
noNodesInCommon: aFinancialServiceToAdd

	(self = aFinancialServiceToAdd) ifTrue: [self error: FinancialService cannotAddExistingServiceErrorDescription].
	
	financialServices do: [:aFinancialService | 
		aFinancialService noNodesInCommon: aFinancialServiceToAdd.
		aFinancialServiceToAdd noNodesInCommon: aFinancialService.
	].

! !

!Portfolio methodsFor: 'assertions' stamp: 'MR 10/18/2021 15:44:20'!
notIncludedInTree: aFinancialServiceToAdd

	parentPortfolios isEmpty 
		ifTrue: (self noNodesInCommon: aFinancialServiceToAdd)
		ifFalse: (parentPortfolios do: [:aPortfolio | aPortfolio notIncludedInTree: aFinancialServiceToAdd ]).
		! !


!Portfolio methodsFor: 'initialization' stamp: 'MR 10/18/2021 14:19:03'!
initialize

	parentPortfolios _ OrderedCollection new.
	
	financialServices _ OrderedCollection new.! !


!Portfolio methodsFor: 'adding' stamp: 'MR 10/18/2021 15:30:03'!
add: aFinancialService	

	self notIncludedInTree: aFinancialService.
	
	financialServices add: aFinancialService.
	aFinancialService addParent: self.! !

!Portfolio methodsFor: 'adding' stamp: 'MR 10/18/2021 14:18:59'!
addParent: aPortfolio

	parentPortfolios add: aPortfolio.! !


!Portfolio methodsFor: 'accessing' stamp: 'MR 10/18/2021 14:55:34'!
balance

	^financialServices sum: [:aFinancialService | aFinancialService balance] ifEmpty: [0].! !

!Portfolio methodsFor: 'accessing' stamp: 'MR 10/18/2021 14:55:30'!
hasRegistered: aTransaction

	^financialServices anySatisfy: [:aFinancialService | aFinancialService hasRegistered: aTransaction].! !

!Portfolio methodsFor: 'accessing' stamp: 'MR 10/18/2021 14:55:59'!
transactions
	
	^(financialServices collect: [:aFinancialService | aFinancialService transactions]) flatten.! !


!classDefinition: #ReceptiveAccount category: 'Portfolio-Ejercicio'!
FinancialService subclass: #ReceptiveAccount
	instanceVariableNames: 'transactions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!ReceptiveAccount methodsFor: 'initialization' stamp: 'NR 10/17/2019 15:06:56'!
initialize

	transactions := OrderedCollection new.! !


!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
register: aTransaction

	transactions add: aTransaction 
! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'MR 10/18/2021 14:53:09'!
transactions 

	^ transactions! !


!ReceptiveAccount methodsFor: 'balance' stamp: 'GRC 10/14/2021 21:31:57'!
balance

	^transactions inject: 0 into: [ :totalBalance :aTransaction | aTransaction addToBalance: totalBalance ].! !


!ReceptiveAccount methodsFor: 'testing' stamp: 'GRC 10/15/2021 19:56:48'!
hasRegistered: aTransaction

	^ transactions includes: aTransaction 
! !
