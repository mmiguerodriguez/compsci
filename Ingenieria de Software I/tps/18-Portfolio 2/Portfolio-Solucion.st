!classDefinition: #PortfolioTest category: 'Portfolio-Solucion'!
TestCase subclass: #PortfolioTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:16:26'!
test01BalanceOfPortfolioWithoutAccountsIsZero

	self assert: 0 equals: Portfolio new balance! !

!PortfolioTest methodsFor: 'tests' stamp: 'NR 5/27/2021 17:36:04'!
test02BalanceOfPortfolioWithAccountsIsSumOfAccountsBalance

	| account portfolio |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	portfolio := Portfolio with: account.
	
	self assert: account balance equals: portfolio balance! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:23:25'!
test03BalanceOfPortfolioIsCalculatedRecursivelyOnPortfolios

	| simplePortfolioAccount simplePortfolio composedPortfolioAccount composedPortofolio |
	
	simplePortfolioAccount := ReceptiveAccount new.
	Deposit register: 100 on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount := ReceptiveAccount new.
	Withdraw register: 50 on: composedPortfolioAccount.
	composedPortofolio := Portfolio with: simplePortfolio with: composedPortfolioAccount.
	
	self assert: (composedPortfolioAccount balance + simplePortfolio balance) equals: composedPortofolio balance! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:43:15'!
test04PortfolioWithoutAccountsHasNoRegisteredTransaction

	self deny: (Portfolio new hasRegistered: (Deposit for: 100))! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:43:11'!
test05PortfolioHasRegisteredItsAccountsTransactions

	| account portfolio deposit |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 on: account.
	portfolio := Portfolio with: account.
	
	self assert: (portfolio hasRegistered: deposit)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:06'!
test06PortfolioLooksForRegisteredTransactionsRecursively

	| simplePortfolioAccount simplePortfolio composedPortfolioAccount composedPortfolio composedPortfolioAccountWithdraw simplePortfolioAccountDeposit |
	
	simplePortfolioAccount := ReceptiveAccount new.
	simplePortfolioAccountDeposit := Deposit register: 100 on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount := ReceptiveAccount new.
	composedPortfolioAccountWithdraw := Withdraw register: 50 on: composedPortfolioAccount.
	composedPortfolio := Portfolio with: simplePortfolio with: composedPortfolioAccount.
	
	self assert: (composedPortfolio hasRegistered: simplePortfolioAccountDeposit).
	self assert: (composedPortfolio hasRegistered: composedPortfolioAccountWithdraw)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:10'!
test07PortfolioHasNoTransactionWhenHasNoAccounts

	self assert: Portfolio new transactions isEmpty! !

!PortfolioTest methodsFor: 'tests' stamp: 'NR 6/22/2020 07:31:19'!
test08PortfolioTransactionsIncludesAllItsAccountsTransactions

	| account portfolio accountDeposit anotherAccount portfolioTransactions anotherAccountWithdraw |
	
	account := ReceptiveAccount new.
	accountDeposit := Deposit register: 100 on: account.
	anotherAccount := ReceptiveAccount new.
	anotherAccountWithdraw := Withdraw register: 100 on: account.
	portfolio := Portfolio with: account.
	
	portfolioTransactions := portfolio transactions.
	
	self assert: 2 equals: portfolioTransactions size.
	self assert: (portfolioTransactions includes: accountDeposit).
	self assert: (portfolioTransactions includes: anotherAccountWithdraw)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:20'!
test09PortfolioTransactionsAreCalculatedRecursively

	| simplePortfolioAccount simplePortfolio composedPortfolioAccount composedPortfolio composedPortfolioAccountWithdraw simplePortfolioAccountDeposit composedPortfolioTransactions |
	
	simplePortfolioAccount := ReceptiveAccount new.
	simplePortfolioAccountDeposit := Deposit register: 100 on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount := ReceptiveAccount new.
	composedPortfolioAccountWithdraw := Withdraw register: 50 on: composedPortfolioAccount.
	composedPortfolio := Portfolio with: simplePortfolio with: composedPortfolioAccount.
	
	composedPortfolioTransactions := composedPortfolio transactions.
	self assert: 2 equals: composedPortfolioTransactions size.
	self assert: (composedPortfolioTransactions includes: simplePortfolioAccountDeposit).
	self assert: (composedPortfolioTransactions includes: composedPortfolioAccountWithdraw)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:24'!
test10PortfolioCanNotIncludeTheSameAccountMoreThanOnce

	| account portfolio |
	
	account := ReceptiveAccount new.
	portfolio := Portfolio with: account.
	
	self 
		should: [ portfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: 1 equals: portfolio accountsSize.
			self assert: (portfolio accountsIncludes: account) ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:28'!
test11PortfolioCanNotIncludeAccountOfItsPortfolios

	| account simplePortfolio composedPortfolio |
	
	account := ReceptiveAccount new.
	simplePortfolio := Portfolio with: account.
	composedPortfolio := Portfolio with: simplePortfolio.
	
	self 
		should: [ composedPortfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: 1 equals: composedPortfolio accountsSize.
			self assert: (composedPortfolio accountsIncludes: simplePortfolio) ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:32'!
test12PortfolioCanNotIncludeItself

	| account simplePortfolio |
	
	account := ReceptiveAccount new.
	simplePortfolio := Portfolio with: account.
	
	self 
		should: [ simplePortfolio add: simplePortfolio ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: 1 equals: simplePortfolio accountsSize.
			self assert: (simplePortfolio accountsIncludes: account) ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 12:01:51'!
test13ComposedPortfolioCanNotHaveParentPortfolioAccount

	| account simplePortfolio composedPortfolio |
	
	account := ReceptiveAccount new.
	simplePortfolio := Portfolio new.
	composedPortfolio := Portfolio with: simplePortfolio.
	composedPortfolio add: account.
	
	self 
		should: [ simplePortfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: simplePortfolio accountsIsEmpty ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 12:12:16'!
test14ComposedPortfolioCanNotHaveAccountOfAnyRootParentRecursively

	| account leftParentPortfolio leftRootParentPortfolio portfolio rightParentPortfolio rightRootParentPortfolio |
	
	account := ReceptiveAccount new.
	portfolio := Portfolio new.
	leftParentPortfolio := Portfolio with: portfolio .
	leftRootParentPortfolio := Portfolio with: leftParentPortfolio.
	leftRootParentPortfolio add: account.
	
	rightParentPortfolio := Portfolio with: portfolio .
	rightRootParentPortfolio := Portfolio with: rightParentPortfolio.
	rightRootParentPortfolio add: account.

	self 
		should: [ portfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: portfolio accountsIsEmpty ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/29/2019 16:31:18'!
test15PortfolioCanNotIncludeAnyOfTheComposedAccountOfPortfolioToAdd

	| portfolioToAdd portfolioToModify rootPortfolio sharedAccount |
	
	sharedAccount := ReceptiveAccount new.
	portfolioToModify := Portfolio new.
	rootPortfolio := Portfolio with: sharedAccount with: portfolioToModify.
	portfolioToAdd := Portfolio with: sharedAccount.
	
	self 
		should: [ portfolioToModify add: portfolioToAdd ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError | 
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: portfolioToModify accountsIsEmpty ]! !


!classDefinition: #ReceptiveAccountTest category: 'Portfolio-Solucion'!
TestCase subclass: #ReceptiveAccountTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:19:48'!
test01ReceptiveAccountHaveZeroAsBalanceWhenCreated 

	| account |
	
	account := ReceptiveAccount new.

	self assert: 0 equals: account balance .
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:19:54'!
test02DepositIncreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount  new.
	Deposit register: 100 on: account.
		
	self assert: 100 equals: account balance .
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:02'!
test03WithdrawDecreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	Withdraw register: 50 on: account.
		
	self assert: 50 equals: account balance .
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

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:54'!
test06ReceptiveAccountDoNotKnowNotRegisteredTransactions

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit :=  Deposit for: 100.
	withdraw := Withdraw for: 50.
		
	self deny: (account hasRegistered: deposit).
	self deny: (account hasRegistered:withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:21:24'!
test07AccountKnowsItsTransactions 

	| account1 deposit1 |
	
	account1 := ReceptiveAccount new.
	
	deposit1 := Deposit register: 100 on: account1.
		
	self assert: 1 equals: account1 transactions size .
	self assert: (account1 transactions includes: deposit1).
! !


!classDefinition: #ReportTest category: 'Portfolio-Solucion'!
TestCase subclass: #ReportTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!ReportTest methodsFor: 'account summary tests' stamp: 'MR 10/25/2021 14:38:38'!
test01SummaryOfEmptyAccountOnlyHasBalance

	| cuenta summary |
	
	cuenta _ ReceptiveAccount new.
	summary _ AccountSummary for: cuenta.
	
	self assert: 'Balance = 0' equals: (summary createReport).

	! !

!ReportTest methodsFor: 'account summary tests' stamp: 'MR 10/25/2021 12:56:15'!
test02DepositsReflectOnAccountSummary

	| cuenta summary |
	
	cuenta _ ReceptiveAccount new.
	Deposit register: 50 on: cuenta.
	
	summary _ AccountSummary for: cuenta.
		
	self assert: 'Depósito por 50.\Balance = 50' withNewLines equals: (summary createReport).


	! !

!ReportTest methodsFor: 'account summary tests' stamp: 'MR 10/25/2021 12:56:21'!
test03WithdrawsReflectOnAccountSummary

	| cuenta summary |
	
	cuenta _ ReceptiveAccount new.
	Deposit register: 50 on: cuenta.
	Withdraw register: 100 on: cuenta.
	
	summary _ AccountSummary for: cuenta.
	
	self assert: 'Depósito por 50.\Extracción por 100.\Balance = -50' withNewLines equals: (summary createReport).

	! !

!ReportTest methodsFor: 'account summary tests' stamp: 'MR 10/25/2021 12:56:29'!
test04OutgoingTransfersReflectOnAccountSummary

	| cuenta1 cuenta2 summary |
	
	cuenta1 _ ReceptiveAccount new.
	cuenta2 _ ReceptiveAccount new.
	Deposit register: 50 on: cuenta1.
	Withdraw register: 100 on: cuenta1.
	Transfer from: cuenta1 to: cuenta2 withAmount: 25.
	
	summary _ AccountSummary for: cuenta1.
	
	self assert: 'Depósito por 50.\Extracción por 100.\Salida por transferencia de 25.\Balance = -75' withNewLines equals: (summary createReport).

	! !

!ReportTest methodsFor: 'account summary tests' stamp: 'MR 10/25/2021 12:56:41'!
test05IncomingTransfersReflectOnAccountSummary

	| cuenta1 cuenta2 summary |
	
	cuenta1 _ ReceptiveAccount new.
	cuenta2 _ ReceptiveAccount new.
	
	Deposit register: 50 on: cuenta1.
	Withdraw register: 100 on: cuenta1.
	Transfer from: cuenta1 to: cuenta2 withAmount: 25.
	Transfer from: cuenta2 to: cuenta1 withAmount: 40.
	
	summary _ AccountSummary for: cuenta1.
	
	self assert: 'Depósito por 50.\Extracción por 100.\Salida por transferencia de 25.\Entrada por transferencia de 40.\Balance = -35' withNewLines equals: (summary createReport).

	! !

!ReportTest methodsFor: 'account summary tests' stamp: 'MR 10/25/2021 14:16:32'!
test09SummaryOfEmptyPortfolioOnlyHasBalance

	| portfolio summary |
	
	portfolio _ Portfolio new.
	
	summary _ AccountSummary for: portfolio.
	
	self assert: 'Balance = 0' equals: (summary createReport).
	! !

!ReportTest methodsFor: 'account summary tests' stamp: 'MR 10/25/2021 14:16:40'!
test10PortfolioSummaryIncludesItsAccounts

	| portfolio cuenta1 cuenta2 summary |
	
	portfolio _ Portfolio new.
	cuenta1 _ ReceptiveAccount new.
	cuenta2 _ ReceptiveAccount new.
	
	Deposit register: 50 on: cuenta1.
	Deposit register: 100 on: cuenta2.	
	
	portfolio add: cuenta1.
	portfolio add: cuenta2.
	
	summary _ AccountSummary for: portfolio.
	
	self assert: 'Depósito por 50.\Depósito por 100.\Balance = 150' withNewLines equals: (summary createReport).! !

!ReportTest methodsFor: 'account summary tests' stamp: 'MR 10/25/2021 14:18:25'!
test11PortfolioSummaryIncludesItsPortfolios

	| portfolio1 portfolio2 portfolio3 cuenta1 cuenta2 cuenta3 cuenta4 summary |
	
	portfolio1 _ Portfolio new.
	portfolio2 _ Portfolio new.
	portfolio3 _ Portfolio new.
	cuenta1 _ ReceptiveAccount new.
	cuenta2 _ ReceptiveAccount new.
	cuenta3 _ ReceptiveAccount new.
	cuenta4 _ ReceptiveAccount new.
	
	Deposit register: 50 on: cuenta1.
	Deposit register: 100 on: cuenta2.	
	Withdraw register: 25 on: cuenta3.	
	Transfer from: cuenta3 to: cuenta4 withAmount: 50.
	
	portfolio1 add: cuenta1.
	portfolio1 add: cuenta2.
	portfolio2 add: cuenta3.
	portfolio3 add: cuenta4.
	portfolio1 add: portfolio2.
	portfolio1 add: portfolio3.
	
	summary _ AccountSummary for: portfolio1.
	
	self assert: 'Depósito por 50.\Depósito por 100.\Extracción por 25.\Salida por transferencia de 50.\Entrada por transferencia de 50.\Balance = 125' withNewLines equals: (summary createReport).! !


!ReportTest methodsFor: 'transfer net tests' stamp: 'MR 10/25/2021 12:57:41'!
test06EmptyAccountHasTransferNetOfZero

	| cuenta transferNet |
	
	cuenta _ ReceptiveAccount new.
	
	transferNet _ TransferNet for: cuenta.
	
	self assert: 0 equals: (transferNet createReport).

	! !

!ReportTest methodsFor: 'transfer net tests' stamp: 'MR 10/25/2021 14:15:54'!
test07OutgoingTransfersDecreaseTransferNet

	| cuenta1 cuenta2 transferNet |
	
	cuenta1 _ ReceptiveAccount new.
	cuenta2 _ ReceptiveAccount new.
	Transfer from: cuenta1 to: cuenta2 withAmount: 50.
	Transfer from: cuenta1 to: cuenta2 withAmount: 150.
	
	transferNet _ TransferNet for: cuenta1.
	
	self assert: -200 equals: (transferNet createReport).

	! !

!ReportTest methodsFor: 'transfer net tests' stamp: 'MR 10/25/2021 14:16:24'!
test08IncomingTransfersIncreaseTransferNet

	| cuenta1 cuenta2 transferNet |
	
	cuenta1 _ ReceptiveAccount new.
	cuenta2 _ ReceptiveAccount new.
	
	Transfer from: cuenta1 to: cuenta2 withAmount: 50.
	Transfer from: cuenta1 to: cuenta2 withAmount: 150.
	Transfer from: cuenta2 to: cuenta1 withAmount: 125.
	
	transferNet _ TransferNet for: cuenta1.
	
	self assert: -75 equals: (transferNet createReport).

	! !

!ReportTest methodsFor: 'transfer net tests' stamp: 'MR 10/25/2021 14:18:33'!
test12DepositAndWithdrawDontAffectTransferNet

	| cuenta1 cuenta2 transferNet |
	
	cuenta1 _ ReceptiveAccount new.
	cuenta2 _ ReceptiveAccount new.
	
	Transfer from: cuenta1 to: cuenta2 withAmount: 50.
	Deposit register: 100 on: cuenta1.
	Withdraw register: 50 on: cuenta1.
	Transfer from: cuenta1 to: cuenta2 withAmount: 150.
	Transfer from: cuenta2 to: cuenta1 withAmount: 125.
	
	transferNet _ TransferNet for: cuenta1.
	
	self assert: -75 equals: (transferNet createReport).
	! !


!ReportTest methodsFor: 'tree structure tests' stamp: 'MR 10/25/2021 16:07:16'!
test13TreeReportEmptyPortfolio

	| portfolio report |
	
	portfolio _ Portfolio named: 'Portfolio de prueba'.
	report _ TreeStructure for: portfolio.
	
	self assert: 'Portfolio de prueba' equals: report createReport.
	
	! !

!ReportTest methodsFor: 'tree structure tests' stamp: 'MR 10/25/2021 16:07:33'!
test14TreeReportWithAccount

	| portfolio cuenta report |
	
	portfolio _ Portfolio named: 'Portfolio de prueba'.
	cuenta _ ReceptiveAccount named: 'Cuenta de Ryan'.
	portfolio add: cuenta.
	
	report _ TreeStructure for: portfolio.
	
	self assert: 'Portfolio de prueba\  Cuenta de Ryan' withNewLines equals: report createReport.
	
	! !

!ReportTest methodsFor: 'tree structure tests' stamp: 'MR 10/25/2021 16:07:44'!
test15TreeReportWithMultipleAccounts

	| portfolio cuenta1 cuenta2 report |
	
	portfolio _ Portfolio named: 'Portfolio de prueba'.
	cuenta1 _ ReceptiveAccount named: 'Cuenta de Ryan'.
	cuenta2 _ ReceptiveAccount named: 'Cuenta de Guido'.
	portfolio add: cuenta1.
	portfolio add: cuenta2.
	
	report _ TreeStructure for: portfolio.
	
	self assert: 'Portfolio de prueba\  Cuenta de Ryan\  Cuenta de Guido' withNewLines equals: report createReport.
	
	! !

!ReportTest methodsFor: 'tree structure tests' stamp: 'MR 10/25/2021 16:08:53'!
test16TreeReportWithMultipleAccountsAndAPortfolio

	| portfolio1 portfolio2 cuenta1 cuenta2 report |
	
	portfolio1 _ Portfolio named: 'Portfolio de prueba'.
	portfolio2 _ Portfolio named: 'Portfolio de Migue'.
	cuenta1 _ ReceptiveAccount named: 'Cuenta de Ryan'.
	cuenta2 _ ReceptiveAccount named: 'Cuenta de Guido'.
	portfolio1 add: cuenta1.
	portfolio1 add: cuenta2.
	portfolio1 add: portfolio2.
	report _ TreeStructure for: portfolio1.
	
	self assert: 'Portfolio de prueba\  Cuenta de Ryan\  Cuenta de Guido\  Portfolio de Migue' withNewLines equals: report createReport.
	
	! !

!ReportTest methodsFor: 'tree structure tests' stamp: 'MR 10/25/2021 16:09:05'!
test17TreeReportWithMultipleAccountsAndMultiplePortfolios

	| portfolio1 portfolio2 cuenta1 cuenta2 cuenta3 report cuenta4 portfolio3 |
	
	portfolio1 _ Portfolio named: 'Portfolio de prueba'.
	portfolio2 _ Portfolio named: 'Portfolio de Migue'.
	portfolio3 _ Portfolio named: 'Portfolio del Fideo'.
	cuenta1 _ ReceptiveAccount named: 'Cuenta de Ryan'.
	cuenta2 _ ReceptiveAccount named: 'Cuenta de Guido'.
	cuenta3 _ ReceptiveAccount named: 'Cuenta de Messi'.
	cuenta4 _ ReceptiveAccount named: 'Cuenta de Richarlison'.
	portfolio1 add: cuenta1.
	portfolio1 add: cuenta2.
	portfolio2 add: cuenta3.
	portfolio3 add: cuenta4.
	portfolio1 add: portfolio2.
	portfolio1 add: portfolio3.
	
	report _ TreeStructure for: portfolio1.
	
	self assert: 'Portfolio de prueba\  Cuenta de Ryan\  Cuenta de Guido\  Portfolio de Migue\    Cuenta de Messi\  Portfolio del Fideo\    Cuenta de Richarlison' withNewLines equals: report createReport.
	
	! !


!ReportTest methodsFor: 'account summary special tests' stamp: 'MR 10/25/2021 16:49:29'!
test18SpecialSummaryForEmptyPortfolio

	| portfolio report |
	portfolio _ Portfolio named: 'Portfolio de la familia'.
	report _ AccountSummarySpecial for: portfolio.
	
	self assert: 'Portfolio de la familia\  Balance = 0' withNewLines equals: report createReport.! !

!ReportTest methodsFor: 'account summary special tests' stamp: 'MR 10/25/2021 16:49:41'!
test19SpecialSummaryForPortfolioWithAccount

	| portfolio report cuenta |
	portfolio _ Portfolio named: 'Portfolio de la familia'.
	cuenta _ ReceptiveAccount named: 'Cuenta Mia'.
	portfolio add: cuenta.
	report _ AccountSummarySpecial for: portfolio.
	
	self assert: 'Portfolio de la familia\  Cuenta Mia\    Balance = 0\  Balance = 0' withNewLines equals: report createReport.! !

!ReportTest methodsFor: 'account summary special tests' stamp: 'MR 10/25/2021 16:49:57'!
test20SpecialSummaryForPortfolioAndAccountWithTransactions

	| portfolio report cuenta |
	portfolio _ Portfolio named: 'Portfolio de la familia'.
	cuenta _ ReceptiveAccount named: 'Cuenta Mia'.
	
	Deposit register: 50 on: cuenta.
	portfolio add: cuenta.
	report _ AccountSummarySpecial for: portfolio.
	
	self assert: 'Portfolio de la familia\  Cuenta Mia\    Depósito por 50\    Balance = 50\  Balance = 50' withNewLines equals: report createReport.! !

!ReportTest methodsFor: 'account summary special tests' stamp: 'MR 10/25/2021 16:50:55'!
test21SpecialSummaryForGeneralCase

	| report angiesAccount childrenPortfolio familyPortfolio johnsAccount myAccount nonExistingAccount |
	johnsAccount _ ReceptiveAccount named: 'Cuenta de Juan'.
	angiesAccount _ ReceptiveAccount named: 'Cuenta de Angeles'.
	childrenPortfolio _ Portfolio named: 'Portfolio de hijos'.
	myAccount _ ReceptiveAccount named: 'Cuenta Mia'.
	familyPortfolio _ Portfolio named: 'Portfolio de la familia'.
	
	nonExistingAccount _ ReceptiveAccount named: 'Cuenta inexistente'.
	
	Deposit register: 50 on: myAccount.
	Withdraw register: 25 on: myAccount.

	Deposit register: 100 on: johnsAccount.
	Withdraw register: 50 on: johnsAccount.
	
	Transfer from: angiesAccount to: nonExistingAccount withAmount: 50.
	
	familyPortfolio add: myAccount.
	childrenPortfolio add: johnsAccount.
	childrenPortfolio add: angiesAccount.
	familyPortfolio add: childrenPortfolio.
	
	report _ AccountSummarySpecial  for: familyPortfolio.
	
	self assert: 'Portfolio de la familia\  Cuenta Mia\    Depósito por 50\    Extracción por 25\    Balance = 25\  Portfolio de hijos\    Cuenta de Juan\      Depósito por 100\      Extracción por 50\      Balance = 50\    Cuenta de Angeles\      Salida por transferencia de 50\      Balance = -50\    Balance = 0\  Balance = 25' withNewLines equals: report createReport.! !


!classDefinition: #TransferTest category: 'Portfolio-Solucion'!
TestCase subclass: #TransferTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TransferTest methodsFor: 'tests' stamp: 'MR 10/25/2021 14:38:21'!
test01TransferAffectsAccountsBalance

	| cuenta1 cuenta2 | 
	
	cuenta1 _ ReceptiveAccount new.
	cuenta2 _ ReceptiveAccount new.
	
	Transfer from: cuenta1 to: cuenta2 withAmount: 100.
	
	self assert: -100 equals: cuenta1 balance.
	self assert: 100 equals: cuenta2 balance.! !

!TransferTest methodsFor: 'tests' stamp: 'MR 10/25/2021 14:38:19'!
test02CannotTransferZeroOrLess

	| cuenta1 cuenta2 | 
	
	cuenta1 _ ReceptiveAccount new.
	cuenta2 _ ReceptiveAccount new.
	
	self 
		should: [ Transfer from: cuenta1 to: cuenta2 withAmount: -100. ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError | 
			self assert: Transfer invalidTransfer equals: anError messageText. ]! !

!TransferTest methodsFor: 'tests' stamp: 'MR 10/25/2021 14:38:16'!
test03CannotTransferToSelf

	| cuenta1 | 
	
	cuenta1 _ ReceptiveAccount new.
	
	self 
		should: [ Transfer from: cuenta1 to: cuenta1 withAmount: 100. ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError | 
			self assert: Transfer invalidTransfer equals: anError messageText. ]! !

!TransferTest methodsFor: 'tests' stamp: 'MR 10/25/2021 14:38:29'!
test04TransferDestinationLegCanNavigateToOriginLeg

	| cuenta1 cuenta2 transfer | 
	
	cuenta1 _ ReceptiveAccount new.
	cuenta2 _ ReceptiveAccount new.
	
	transfer _ Transfer from: cuenta1 to: cuenta2 withAmount: 100.
	
	self assert: transfer destinationLeg transfer originLeg equals: transfer originLeg.
	
	! !

!TransferTest methodsFor: 'tests' stamp: 'MR 10/25/2021 14:38:26'!
test05TransferOriginLegCanNavigateToDestinationLeg

	| cuenta1 cuenta2 transfer | 
	
	cuenta1 _ ReceptiveAccount new.
	cuenta2 _ ReceptiveAccount new.
	
	transfer _ Transfer from: cuenta1 to: cuenta2 withAmount: 100.
	
	self assert: transfer originLeg transfer destinationLeg equals: transfer destinationLeg.
	
	! !


!classDefinition: #Account category: 'Portfolio-Solucion'!
Object subclass: #Account
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Account methodsFor: 'testing' stamp: 'HAW 5/25/2019 12:23:47'!
hasRegistered: aTransaction

	self subclassResponsibility ! !

!Account methodsFor: 'testing' stamp: 'HAW 5/25/2019 12:24:25'!
isComposedBy: anAccount

	self subclassResponsibility ! !


!Account methodsFor: 'balance' stamp: 'HAW 5/25/2019 12:23:40'!
balance

	self subclassResponsibility ! !


!Account methodsFor: 'transactions' stamp: 'HAW 5/25/2019 12:23:27'!
addTransactionsTo: aCollectionOfTransactions

	self subclassResponsibility ! !

!Account methodsFor: 'transactions' stamp: 'HAW 5/25/2019 12:23:15'!
transactions

	self subclassResponsibility ! !


!Account methodsFor: 'composition' stamp: 'HAW 5/25/2019 12:24:04'!
addedTo: aPortfolio

	self subclassResponsibility ! !


!classDefinition: #Portfolio category: 'Portfolio-Solucion'!
Account subclass: #Portfolio
	instanceVariableNames: 'accounts parents name'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Portfolio methodsFor: 'accounts management' stamp: 'MR 10/25/2021 14:59:08'!
accountName
	^name.! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 11:49:20'!
accountsIncludes: anAccount

	^accounts includes: anAccount ! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 12:05:04'!
accountsIsEmpty
	
	^accounts isEmpty ! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 11:49:06'!
accountsSize
	
	^accounts size! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 12:19:20'!
add: accountToAdd

	self assertCanAdd: accountToAdd.
		
	accounts add: accountToAdd.
	accountToAdd addedTo: self 
	! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 12:17:31'!
rootParents
	
	| rootParents |
	
	rootParents := Set new.
	self addRootParentsTo: rootParents.
	
	^ rootParents! !


!Portfolio methodsFor: 'initialization' stamp: 'HAW 5/25/2019 12:03:18'!
initialize

	accounts := OrderedCollection new.
	parents := OrderedCollection new.! !

!Portfolio methodsFor: 'initialization' stamp: 'MR 10/25/2021 14:46:02'!
initializeNamed: aName 
	name := aName.
	self initialize.! !


!Portfolio methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:19:36'!
balance
	
	^accounts sum: [ :anAccount | anAccount balance ] ifEmpty: [ 0 ]! !


!Portfolio methodsFor: 'transactions' stamp: 'HAW 5/25/2019 11:42:55'!
addTransactionsTo: aCollectionOfTransactions

	accounts do: [ :anAccount | anAccount addTransactionsTo: aCollectionOfTransactions ]! !

!Portfolio methodsFor: 'transactions' stamp: 'HAW 5/25/2019 11:38:32'!
transactions
	
	| transactions |
	
	transactions := OrderedCollection new.
	accounts do: [ :anAccount | anAccount addTransactionsTo: transactions ].
	
	^transactions ! !


!Portfolio methodsFor: 'composition' stamp: 'HAW 5/25/2019 12:02:59'!
addedTo: aPortfolio 
	
	parents add: aPortfolio ! !


!Portfolio methodsFor: 'testing' stamp: 'HAW 5/25/2019 12:20:56'!
anyRootParentIsComposedBy: accountToAdd

	^self rootParents anySatisfy: [ :aParent | aParent isComposedBy: accountToAdd]! !

!Portfolio methodsFor: 'testing' stamp: 'HAW 5/25/2019 11:28:29'!
hasRegistered: aTransaction

	^accounts anySatisfy: [ :anAccount | anAccount hasRegistered: aTransaction ]! !

!Portfolio methodsFor: 'testing' stamp: 'HAW 5/29/2019 16:24:54'!
isComposedBy: anAccount

	^ self = anAccount or: [ accounts anySatisfy: [ :composedAccount | (composedAccount isComposedBy: anAccount) or: [ anAccount isComposedBy: composedAccount ]]]! !


!Portfolio methodsFor: 'account management - private' stamp: 'HAW 5/25/2019 12:17:31'!
addRootParentsTo: rootParents

	parents 
		ifEmpty: [ rootParents add: self ] 
		ifNotEmpty: [ parents do: [ :aParent | aParent addRootParentsTo: rootParents ]]! !

!Portfolio methodsFor: 'account management - private' stamp: 'HAW 5/25/2019 12:20:36'!
assertCanAdd: accountToAdd

	(self anyRootParentIsComposedBy: accountToAdd) ifTrue: [ self signalCanNotAddAccount ].
! !

!Portfolio methodsFor: 'account management - private' stamp: 'HAW 5/25/2019 11:48:34'!
signalCanNotAddAccount
	
	self error: self class canNotAddAccountErrorMessage! !


!Portfolio methodsFor: 'reports' stamp: 'MR 10/25/2021 15:59:58'!
affectReport: aReport
	aReport forPortfolio: self.

! !

!Portfolio methodsFor: 'reports' stamp: 'MR 10/25/2021 16:03:47'!
affectReportWithAccounts: aReport
	accounts do: [:anAccount | anAccount affectReport: aReport].

! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Portfolio class' category: 'Portfolio-Solucion'!
Portfolio class
	instanceVariableNames: ''!

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'HAW 5/25/2019 11:48:55'!
canNotAddAccountErrorMessage
	
	^'Can not add repeated account to a portfolio'! !

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'HAW 5/25/2019 11:18:21'!
with: anAccount

	^self new 
		add: anAccount;
		yourself! !

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'MR 10/25/2021 16:32:45'!
with: anAccount with: anotherAccount

	^self new 
		add: anAccount;
		add: anotherAccount;
		yourself! !


!Portfolio class methodsFor: 'instance creation' stamp: 'MR 10/25/2021 14:44:41'!
named: aString 
	^self new initializeNamed: aString ! !


!classDefinition: #ReceptiveAccount category: 'Portfolio-Solucion'!
Account subclass: #ReceptiveAccount
	instanceVariableNames: 'transactions name'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!ReceptiveAccount methodsFor: 'initialization' stamp: 'GRC 10/18/2021 21:47:57'!
initialize

	super initialize.
	transactions := OrderedCollection new.! !

!ReceptiveAccount methodsFor: 'initialization' stamp: 'MR 10/25/2021 14:49:03'!
initializeNamed: aName 

	name := aName.
	
	self initialize.! !


!ReceptiveAccount methodsFor: 'transactions' stamp: 'HAW 5/25/2019 11:38:52'!
addTransactionsTo: aCollectionOfTransactions

	aCollectionOfTransactions addAll: transactions ! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
register: aTransaction

	transactions add: aTransaction 
! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
transactions 

	^ transactions copy! !


!ReceptiveAccount methodsFor: 'balance' stamp: 'MR 10/20/2021 13:46:27'!
balance

	^ transactions 
		inject: 0
		into: [ :currentBalance :transaction | transaction affectBalance: currentBalance ]! !


!ReceptiveAccount methodsFor: 'testing' stamp: 'NR 10/21/2019 18:55:56'!
hasRegistered: aTransaction

	^ transactions includes: aTransaction 
! !

!ReceptiveAccount methodsFor: 'testing' stamp: 'HAW 5/25/2019 11:54:51'!
isComposedBy: anAccount

	^self = anAccount ! !


!ReceptiveAccount methodsFor: 'composition' stamp: 'HAW 5/25/2019 12:03:32'!
addedTo: aPortfolio 
	
	! !


!ReceptiveAccount methodsFor: 'reports' stamp: 'MR 10/25/2021 15:59:58'!
affectReport: aReport
	aReport forReceptiveAccount: self.! !

!ReceptiveAccount methodsFor: 'reports' stamp: 'MR 10/25/2021 16:03:36'!
affectReportWithTransactions: aReport
	transactions do: [:aTransaction | aTransaction affectReport: aReport].! !


!ReceptiveAccount methodsFor: 'accessing' stamp: 'MR 10/25/2021 14:53:16'!
accountName

	^name.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ReceptiveAccount class' category: 'Portfolio-Solucion'!
ReceptiveAccount class
	instanceVariableNames: ''!

!ReceptiveAccount class methodsFor: 'instance creation' stamp: 'MR 10/25/2021 14:48:35'!
named: aName 
	^self new initializeNamed: aName ! !


!classDefinition: #AccountReport category: 'Portfolio-Solucion'!
Object subclass: #AccountReport
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!AccountReport methodsFor: 'initialization' stamp: 'MR 10/25/2021 14:36:50'!
initializeFor: anAccount
	self subclassResponsibility.! !


!AccountReport methodsFor: 'reporting - private' stamp: 'MR 10/25/2021 16:05:24'!
forPortfolio: aPortfolio
	self subclassResponsibility .! !

!AccountReport methodsFor: 'reporting - private' stamp: 'MR 10/25/2021 16:05:15'!
forReceptiveAccount: aReceptiveAccount
	self subclassResponsibility .! !

!AccountReport methodsFor: 'reporting - private' stamp: 'GRC 10/25/2021 11:46:20'!
reportForDeposit: aDeposit

	self subclassResponsibility.! !

!AccountReport methodsFor: 'reporting - private' stamp: 'GRC 10/25/2021 11:46:35'!
reportForTransferLegDestination: aDestination

	self subclassResponsibility.! !

!AccountReport methodsFor: 'reporting - private' stamp: 'GRC 10/25/2021 11:46:57'!
reportForTransferLegOrigin: aDeposit

	self subclassResponsibility.! !

!AccountReport methodsFor: 'reporting - private' stamp: 'GRC 10/25/2021 11:47:11'!
reportForWithdraw: aWithdraw

	self subclassResponsibility.! !


!AccountReport methodsFor: 'reporting' stamp: 'MR 10/25/2021 14:36:57'!
createReport
	self subclassResponsibility.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountReport class' category: 'Portfolio-Solucion'!
AccountReport class
	instanceVariableNames: ''!

!AccountReport class methodsFor: 'instance creation' stamp: 'MR 10/25/2021 12:52:57'!
for: anAccount
	
	^self new initializeFor: anAccount ! !


!classDefinition: #AccountSummary category: 'Portfolio-Solucion'!
AccountReport subclass: #AccountSummary
	instanceVariableNames: 'account reportResult'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!AccountSummary methodsFor: 'initialization' stamp: 'MR 10/25/2021 12:53:31'!
initializeFor: anAccount 
	account := anAccount.
	reportResult := ''.! !


!AccountSummary methodsFor: 'reporting' stamp: 'MR 10/25/2021 15:59:58'!
createReport
	
	account affectReport: self.
	
	reportResult _ reportResult , 'Balance = ' , (account balance asString).
	
	^reportResult withNewLines! !


!AccountSummary methodsFor: 'reporting - private' stamp: 'MR 10/25/2021 16:04:21'!
forPortfolio: aPortfolio
	
	aPortfolio affectReportWithAccounts: self.! !

!AccountSummary methodsFor: 'reporting - private' stamp: 'MR 10/25/2021 16:03:36'!
forReceptiveAccount: aReceptiveAccount

	aReceptiveAccount affectReportWithTransactions: self.
	! !

!AccountSummary methodsFor: 'reporting - private' stamp: 'MR 10/25/2021 13:13:29'!
reportForDeposit: aDeposit
	
	reportResult _ reportResult , 'Depósito por ' , aDeposit value asString , '.\'.! !

!AccountSummary methodsFor: 'reporting - private' stamp: 'MR 10/25/2021 13:13:36'!
reportForTransferLegDestination: aDestination
	
	reportResult _ reportResult , 'Entrada por transferencia de ' , aDestination value asString , '.\'.! !

!AccountSummary methodsFor: 'reporting - private' stamp: 'MR 10/25/2021 13:13:39'!
reportForTransferLegOrigin: aDeposit
	
	reportResult _ reportResult , 'Salida por transferencia de ' , aDeposit value asString , '.\'.! !

!AccountSummary methodsFor: 'reporting - private' stamp: 'MR 10/25/2021 13:13:42'!
reportForWithdraw: aWithdraw
	
	reportResult _ reportResult , 'Extracción por ' , aWithdraw value asString , '.\'.! !


!classDefinition: #AccountSummarySpecial category: 'Portfolio-Solucion'!
AccountReport subclass: #AccountSummarySpecial
	instanceVariableNames: 'account reportResult depth'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!AccountSummarySpecial methodsFor: 'initialization' stamp: 'MR 10/25/2021 16:11:44'!
initializeFor: anAccount 
	account := anAccount.
	reportResult := ''.
	depth := 0.! !


!AccountSummarySpecial methodsFor: 'reporting' stamp: 'MR 10/25/2021 16:18:03'!
createReport
	account affectReport: self.
	
	^reportResult withNewLines.! !


!AccountSummarySpecial methodsFor: 'reporting - private' stamp: 'MR 10/25/2021 16:46:58'!
calculateTabs
	|tabs|
	tabs _ ''.
	depth timesRepeat: [ tabs _ tabs , '  '.	].
	^tabs.! !

!AccountSummarySpecial methodsFor: 'reporting - private' stamp: 'MR 10/25/2021 16:29:35'!
forPortfolio: aPortfolio
	
	| tabs |
	tabs _ ''.
	depth timesRepeat: [ tabs _ tabs , '  '.	].
	
	(depth = 0)
		ifTrue: [reportResult _ reportResult , (aPortfolio accountName)]
		ifFalse: [ 
			reportResult _ reportResult , '\', tabs, (aPortfolio accountName)
		].
	
	depth _ depth + 1.
	
	aPortfolio affectReportWithAccounts: self.
	
	tabs _ ''.
	depth timesRepeat: [ tabs _ tabs , '  '.	].
	reportResult _ reportResult , '\', tabs, 'Balance = ', (aPortfolio balance asString).
	
	depth _ depth - 1.
	
	^reportResult withNewLines! !

!AccountSummarySpecial methodsFor: 'reporting - private' stamp: 'MR 10/25/2021 16:47:18'!
forReceptiveAccount: aReceptiveAccount
	
	| tabs |
	tabs _ self calculateTabs.
	
	reportResult _ reportResult , '\' , tabs , (aReceptiveAccount accountName).
	
	depth _ depth + 1.
	
	aReceptiveAccount affectReportWithTransactions: self.
	
	tabs _ self calculateTabs.
	reportResult _ reportResult , '\' , tabs , 'Balance = ' , (aReceptiveAccount balance asString).
	
	depth _ depth - 1.
	
	! !

!AccountSummarySpecial methodsFor: 'reporting - private' stamp: 'MR 10/25/2021 16:47:29'!
reportForDeposit: aDeposit
	
	| tabs |
	tabs _ self calculateTabs.
	
	reportResult _ reportResult , '\' , tabs , 'Depósito por ' , aDeposit value asString.! !

!AccountSummarySpecial methodsFor: 'reporting - private' stamp: 'MR 10/25/2021 16:47:32'!
reportForTransferLegDestination: aDestination
	
	| tabs |
	tabs _ self calculateTabs.
	
	reportResult _ reportResult , '\' , tabs , 'Entrada por transferencia de ' , aDestination value asString.! !

!AccountSummarySpecial methodsFor: 'reporting - private' stamp: 'MR 10/25/2021 16:47:34'!
reportForTransferLegOrigin: aDeposit
	
	| tabs |
	tabs _ self calculateTabs.
	
	reportResult _ reportResult , '\' , tabs , 'Salida por transferencia de ' , aDeposit value asString.! !

!AccountSummarySpecial methodsFor: 'reporting - private' stamp: 'MR 10/25/2021 16:47:37'!
reportForWithdraw: aWithdraw
	
	| tabs |
	tabs _ self calculateTabs.
	
	reportResult _ reportResult , '\' , tabs , 'Extracción por ' , aWithdraw value asString.! !


!classDefinition: #TransferNet category: 'Portfolio-Solucion'!
AccountReport subclass: #TransferNet
	instanceVariableNames: 'account reportResult'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TransferNet methodsFor: 'initialization' stamp: 'MR 10/25/2021 12:58:01'!
initializeFor: anAccount 
	account := anAccount.
	reportResult := 0.! !


!TransferNet methodsFor: 'reporting' stamp: 'MR 10/25/2021 15:59:58'!
createReport
	
	account affectReport: self.
	
	^reportResult.! !


!TransferNet methodsFor: 'reporting - private' stamp: 'MR 10/25/2021 16:04:29'!
forPortfolio: aPortfolio

	aPortfolio affectReportWithAccounts: self.

	! !

!TransferNet methodsFor: 'reporting - private' stamp: 'MR 10/25/2021 16:03:36'!
forReceptiveAccount: aReceptiveAccount

	aReceptiveAccount affectReportWithTransactions: self.

	! !

!TransferNet methodsFor: 'reporting - private' stamp: 'MR 10/25/2021 13:20:27'!
reportForDeposit: aDeposit
! !

!TransferNet methodsFor: 'reporting - private' stamp: 'MR 10/25/2021 13:20:10'!
reportForTransferLegDestination: aDestination
	
	reportResult _ reportResult + aDestination value.! !

!TransferNet methodsFor: 'reporting - private' stamp: 'MR 10/25/2021 13:20:15'!
reportForTransferLegOrigin: aDestination
	
	reportResult _ reportResult - aDestination value.! !

!TransferNet methodsFor: 'reporting - private' stamp: 'MR 10/25/2021 13:20:21'!
reportForWithdraw: aWithdraw
	
	! !


!classDefinition: #TreeStructure category: 'Portfolio-Solucion'!
AccountReport subclass: #TreeStructure
	instanceVariableNames: 'account reportResult depth'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TreeStructure methodsFor: 'initialization' stamp: 'MR 10/25/2021 15:44:13'!
initializeFor: anAccount 
	account := anAccount.
	reportResult := ''.
	depth := 0.! !


!TreeStructure methodsFor: 'reporting' stamp: 'MR 10/25/2021 15:59:58'!
createReport

	account affectReport: self.
	
	^reportResult withNewLines.! !


!TreeStructure methodsFor: 'reporting - private' stamp: 'MR 10/25/2021 16:48:42'!
calculateTabs
	|tabs|
	tabs _ ''.
	depth timesRepeat: [ tabs _ tabs , '  '.	].
	^tabs.! !

!TreeStructure methodsFor: 'reporting - private' stamp: 'MR 10/25/2021 16:48:58'!
forPortfolio: aPortfolio
	(depth = 0)
		ifTrue: [reportResult _ reportResult , (aPortfolio accountName)]
		ifFalse: [ 
			| tabs |
			tabs _ self calculateTabs.
			reportResult _ reportResult , '\', tabs, (aPortfolio accountName)
		].
	
	depth _ depth + 1.
	
	aPortfolio affectReportWithAccounts: self.
	
	depth _ depth - 1.! !

!TreeStructure methodsFor: 'reporting - private' stamp: 'MR 10/25/2021 16:48:50'!
forReceptiveAccount: anAccount
	| tabs |
	tabs _ self calculateTabs.
	
	reportResult _ reportResult , '\' , tabs , (anAccount accountName).
	! !


!classDefinition: #AccountTransaction category: 'Portfolio-Solucion'!
Object subclass: #AccountTransaction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!AccountTransaction methodsFor: 'value' stamp: 'HernanWilkinson 9/12/2011 12:25'!
value 

	self subclassResponsibility ! !


!AccountTransaction methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:39'!
affectBalance: aBalance

	self subclassResponsibility ! !


!AccountTransaction methodsFor: 'reports' stamp: 'MR 10/25/2021 15:59:58'!
affectReport: aReport
	self subclassResponsibility.! !


!AccountTransaction methodsFor: 'initialization' stamp: 'MR 10/25/2021 14:24:56'!
initializeFor: aValue
	self subclassResponsibility.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountTransaction class' category: 'Portfolio-Solucion'!
AccountTransaction class
	instanceVariableNames: ''!

!AccountTransaction class methodsFor: 'instance creation' stamp: 'NR 10/21/2019 18:54:27'!
register: aValue on: account

	| transaction |
	
	transaction := self for: aValue.
	account register: transaction.
		
	^ transaction! !


!classDefinition: #Deposit category: 'Portfolio-Solucion'!
AccountTransaction subclass: #Deposit
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Deposit methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:45'!
initializeFor: aValue

	value := aValue ! !


!Deposit methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:38'!
value

	^ value! !


!Deposit methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:02'!
affectBalance: aBalance

	^aBalance + value ! !


!Deposit methodsFor: 'reports' stamp: 'MR 10/25/2021 15:59:58'!
affectReport: aReport

	aReport reportForDeposit: self.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Deposit class' category: 'Portfolio-Solucion'!
Deposit class
	instanceVariableNames: ''!

!Deposit class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:38'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #TransferLeg category: 'Portfolio-Solucion'!
AccountTransaction subclass: #TransferLeg
	instanceVariableNames: 'transfer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TransferLeg methodsFor: 'balance' stamp: 'MR 10/20/2021 14:48:31'!
affectBalance: aBalance
	
	self subclassResponsibility .! !

!TransferLeg methodsFor: 'balance' stamp: 'MR 10/25/2021 14:21:07'!
affectTransferNetValue: aNetValue

	self subclassResponsibility.! !


!TransferLeg methodsFor: 'reports' stamp: 'MR 10/25/2021 15:59:58'!
affectReport: anAccountSummary

	self subclassResponsibility.! !


!TransferLeg methodsFor: 'initialization' stamp: 'MR 10/20/2021 15:12:52'!
initializeFor: aTransfer

	transfer _ aTransfer.
	! !


!TransferLeg methodsFor: 'accessing' stamp: 'MR 10/20/2021 14:55:11'!
transfer
	^transfer! !


!TransferLeg methodsFor: 'value' stamp: 'MR 10/20/2021 15:06:38'!
value

	^transfer value.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TransferLeg class' category: 'Portfolio-Solucion'!
TransferLeg class
	instanceVariableNames: ''!

!TransferLeg class methodsFor: 'instance creation' stamp: 'MR 10/20/2021 15:13:28'!
for: aTransfer

	^self new initializeFor: aTransfer.! !


!classDefinition: #TransferLegDestination category: 'Portfolio-Solucion'!
TransferLeg subclass: #TransferLegDestination
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TransferLegDestination methodsFor: 'balance' stamp: 'MR 10/20/2021 14:53:15'!
affectBalance: aBalance
	
	^aBalance + (transfer value).! !

!TransferLegDestination methodsFor: 'balance' stamp: 'GRC 10/21/2021 20:41:03'!
affectTransferNetValue: aNetValue

	^aNetValue + self value.! !


!TransferLegDestination methodsFor: 'reports' stamp: 'MR 10/25/2021 15:59:58'!
affectReport: aReport

	^aReport reportForTransferLegDestination: self.! !


!classDefinition: #TransferLegOrigin category: 'Portfolio-Solucion'!
TransferLeg subclass: #TransferLegOrigin
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TransferLegOrigin methodsFor: 'balance' stamp: 'MR 10/20/2021 14:53:12'!
affectBalance: aBalance
	
	^aBalance - (transfer value).! !

!TransferLegOrigin methodsFor: 'balance' stamp: 'MR 10/21/2021 16:00:26'!
affectTransferNetValue: aNetValue
	^aNetValue - self value.! !


!TransferLegOrigin methodsFor: 'reports' stamp: 'MR 10/25/2021 15:59:58'!
affectReport: aReport

	^aReport reportForTransferLegOrigin: self.! !


!classDefinition: #Withdraw category: 'Portfolio-Solucion'!
AccountTransaction subclass: #Withdraw
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Withdraw methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:46'!
initializeFor: aValue

	value := aValue ! !


!Withdraw methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:33'!
value

	^ value! !


!Withdraw methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:15'!
affectBalance: aBalance

	^aBalance - value! !


!Withdraw methodsFor: 'reports' stamp: 'MR 10/25/2021 15:59:58'!
affectReport: aReport

	^aReport reportForWithdraw: self.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Withdraw class' category: 'Portfolio-Solucion'!
Withdraw class
	instanceVariableNames: ''!

!Withdraw class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:33'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #Transfer category: 'Portfolio-Solucion'!
Object subclass: #Transfer
	instanceVariableNames: 'value pataDeExtraccion pataDeDeposito'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Transfer methodsFor: 'initialization' stamp: 'MR 10/20/2021 15:16:44'!
initializeFrom: anEmittingAccount to: aReceivingAccount withAmount: aTransferAmount.

	value _ aTransferAmount.
	pataDeExtraccion _ TransferLegOrigin register: self on: anEmittingAccount.
	pataDeDeposito _ TransferLegDestination register: self on: aReceivingAccount.! !


!Transfer methodsFor: 'accessing' stamp: 'MR 10/20/2021 15:20:51'!
destinationLeg
	^pataDeDeposito.! !

!Transfer methodsFor: 'accessing' stamp: 'MR 10/20/2021 15:21:10'!
originLeg
	^pataDeExtraccion.! !

!Transfer methodsFor: 'accessing' stamp: 'MR 10/20/2021 14:40:59'!
value

	^value.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Transfer class' category: 'Portfolio-Solucion'!
Transfer class
	instanceVariableNames: ''!

!Transfer class methodsFor: 'instance creation' stamp: 'MR 10/20/2021 15:07:21'!
from: anEmittingAccount to: aReceivingAccount withAmount: aTransferAmount

	aTransferAmount <= 0 ifTrue: [self error: Transfer invalidTransfer].
	
	anEmittingAccount = aReceivingAccount ifTrue: [self error: Transfer invalidTransfer].

	^self new initializeFrom: anEmittingAccount to: aReceivingAccount withAmount: aTransferAmount.

	! !


!Transfer class methodsFor: 'as yet unclassified' stamp: 'GRC 10/18/2021 21:44:22'!
invalidTransfer
	
	^'Invalid transfer.'! !
