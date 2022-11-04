!classDefinition: #LoggerTests category: 'MarsRover-WithHeading'!
TestCase subclass: #LoggerTests
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!LoggerTests methodsFor: 'pathLogger' stamp: 'GRC 10/28/2021 14:22:02'!
test01PathLoggerStartsEmpty

	| marsRover logger |
	
	marsRover _ MarsRover at: 1@1 heading: MarsRoverHeadingNorth.
	
	logger _ MarsRoverLogger new.
	
	marsRover trackChangesTo: logger.
	
	self assert: 0 equals: logger log size.! !

!LoggerTests methodsFor: 'pathLogger' stamp: 'GRC 10/28/2021 14:22:02'!
test02HeadingLoggerLogsAllRotationsCorrectly

	| marsRover logger log |
	
	marsRover _ MarsRover at: 1@1 heading: MarsRoverHeadingNorth.
	
	logger _ HeadingLogger decorating: (MarsRoverLogger new).
	
	marsRover trackChangesTo: logger.
	
	marsRover process: 'rrrrllll'.
	
	log _ logger log.
	
	self assert: 'East' equals: (log at: 1).
	self assert: 'South' equals: (log at: 2).
	self assert: 'West' equals: (log at: 3).
	self assert: 'North' equals: (log at: 4).
	self assert: 'West' equals: (log at: 5).
	self assert: 'South' equals: (log at: 6).
	self assert: 'East' equals: (log at: 7).
	self assert: 'North' equals: (log at: 8).
	self assert: 8 equals: log size.! !

!LoggerTests methodsFor: 'pathLogger' stamp: 'GRC 10/28/2021 14:22:02'!
test03PositionLoggerLogsAllAxisMovementsCorrectly

	| marsRover logger log |
	
	marsRover _ MarsRover at: 1@1 heading: MarsRoverHeadingNorth.
	
	logger _ PositionLogger decorating: (MarsRoverLogger new).
	
	marsRover trackChangesTo: logger.
	
	marsRover process: 'frbrfrb'.
	
	log _ logger log.
	
	self assert: 1@2 equals: (log at: 1).
	self assert: 0@2 equals: (log at: 2).
	self assert: 0@1 equals: (log at: 3).
	self assert: 1@1 equals: (log at: 4).
	self assert: 4 equals: log size.! !

!LoggerTests methodsFor: 'pathLogger' stamp: 'GRC 10/28/2021 14:22:02'!
test04CanHaveMoreThanOneLogger

	| marsRover log1 log2 logger1 logger2 |

	marsRover _ MarsRover at: 1@1 heading: MarsRoverHeadingNorth.
	
	logger1 _ PositionLogger decorating: (MarsRoverLogger new).
	logger2 _ PositionLogger decorating: (MarsRoverLogger new).
	
	marsRover trackChangesTo: logger1.
	marsRover trackChangesTo: logger2.

	marsRover process: 'ffr'.
	
	log1 _ logger1 log.
	log2 _ logger2 log.
	
	self assert: 1@2 equals: (log1 at: 1).
	self assert: 1@3 equals: (log1 at: 2).
	self assert: 2 equals: log1 size.
	
	self assert: 1@2 equals: (log2 at: 1).
	self assert: 1@3 equals: (log2 at: 2).
	self assert: 2 equals: log2 size.! !

!LoggerTests methodsFor: 'pathLogger' stamp: 'GRC 10/28/2021 14:22:02'!
test05CanTrackPositionAndMovement

	| marsRover logger log |
	
	marsRover _ MarsRover at: 1@1 heading: MarsRoverHeadingNorth.
	
	logger _ HeadingLogger decorating: (PositionLogger decorating: MarsRoverLogger new).
	
	marsRover trackChangesTo: logger.
	
	marsRover process: 'frfrfrfr'.
	
	log _ logger log.
	
	self assert: 1@2 equals: (log at: 1).
	self assert: 'East' equals: (log at: 2).
	self assert: 2@2 equals: (log at: 3).
	self assert: 'South' equals: (log at: 4).
	self assert: 2@1 equals: (log at: 5).
	self assert: 'West' equals: (log at: 6).
	self assert: 1@1 equals: (log at: 7).
	self assert: 'North' equals: (log at: 8).
	self assert: 8 equals: log size.! !

!LoggerTests methodsFor: 'pathLogger' stamp: 'GRC 10/28/2021 14:22:02'!
test06PositionLoggerStartsTrackingWhenAddedToMarsRover

	| marsRover logger log |
	
	marsRover _ MarsRover at: 1@1 heading: MarsRoverHeadingNorth.
	
	logger _ PositionLogger decorating: (MarsRoverLogger new).
	
	marsRover process: 'f'.
	
	marsRover trackChangesTo: logger.
	
	marsRover process: 'f'.
	
	log _ logger log.
	
	self assert: 1@3 equals: (log at: 1).
	self assert: 1 equals: log size.! !

!LoggerTests methodsFor: 'pathLogger' stamp: 'GRC 10/28/2021 14:22:02'!
test07HeadingLoggerStartsTrackingWhenAddedToMarsRover

	| marsRover logger log |
	
	marsRover _ MarsRover at: 1@1 heading: MarsRoverHeadingNorth.
	
	logger _ HeadingLogger decorating: (MarsRoverLogger new).
	
	marsRover process: 'r'.
	
	marsRover trackChangesTo: logger.
	
	marsRover process: 'r'.
	
	log _ logger log.
	
	self assert: 'South' equals: (log at: 1).
	self assert: 1 equals: log size.! !

!LoggerTests methodsFor: 'pathLogger' stamp: 'GRC 10/28/2021 14:22:02'!
test08PositionAndHeadingLoggerStratsTrackingWhenAddedToMarsRover

	| marsRover logger log |
	
	marsRover _ MarsRover at: 1@1 heading: MarsRoverHeadingNorth.
	
	logger _ HeadingLogger decorating: (PositionLogger decorating: MarsRoverLogger new).
	
	marsRover process: 'fr'.

	marsRover trackChangesTo: logger.
	
	marsRover process: 'fr'.
	
	log _ logger log.
	
	self assert: 2@2 equals: (log at: 1).
	self assert: 'South' equals: (log at: 2).
	self assert: 2 equals: log size.! !


!LoggerTests methodsFor: 'windowLogger' stamp: 'GRC 10/28/2021 14:21:43'!
test09WindowHeadingLoggerStartsTrackingOnFirstHeadingChange

	| marsRover logger |
	
	marsRover _ MarsRover at: 1@1 heading: MarsRoverHeadingNorth.
	
	logger _ HeadingStatus decorating: (MarsRoverStatusWindow new).
	
	marsRover trackChangesTo: logger.
	
	self assert: nil equals: logger window second.
	
	marsRover process: 'fr'.
	
	self assert: 'East' equals: logger window second.! !

!LoggerTests methodsFor: 'windowLogger' stamp: 'GRC 10/28/2021 14:21:55'!
test10WindowPositionLoggerStartsTrackingOnFirstPositionChange

	| marsRover logger |
	
	marsRover _ MarsRover at: 1@1 heading: MarsRoverHeadingNorth.
	
	logger _ PositionStatus decorating: (MarsRoverStatusWindow new).
	
	marsRover trackChangesTo: logger.
	
	self assert: nil equals: logger window first.
	
	marsRover process: 'rf'.
	
	self assert: 2@1 equals: logger window first.! !

!LoggerTests methodsFor: 'windowLogger' stamp: 'GRC 10/28/2021 14:21:43'!
test11WindowHeadingLoggerOnlyShowsLastHeading

	| marsRover logger |
	
	marsRover _ MarsRover at: 1@1 heading: MarsRoverHeadingNorth.
	
	logger _ HeadingStatus decorating: (MarsRoverStatusWindow new).
	
	marsRover trackChangesTo: logger.
	
	marsRover process: 'frr'.
	
	self assert: 'South' equals: logger window second.
	self assert: nil equals: logger window first.! !

!LoggerTests methodsFor: 'windowLogger' stamp: 'GRC 10/28/2021 14:21:55'!
test12WindowPositionLoggerOnlyShowsLastPosition

	| marsRover logger |
	
	marsRover _ MarsRover at: 1@1 heading: MarsRoverHeadingNorth.
	
	logger _ PositionStatus decorating: (MarsRoverStatusWindow new).
	
	marsRover trackChangesTo: logger.
	
	marsRover process: 'ffrf'.
	
	self assert: 2@3 equals: logger window first.
	self assert: nil equals: logger window second.! !

!LoggerTests methodsFor: 'windowLogger' stamp: 'GRC 10/28/2021 14:21:55'!
test13WindowLoggerCanShowPositionAndHeading

	| marsRover logger |
	
	marsRover _ MarsRover at: 1@1 heading: MarsRoverHeadingNorth.
	
	logger _ PositionStatus decorating: (HeadingStatus decorating: (MarsRoverStatusWindow new)).
	
	marsRover trackChangesTo: logger.
	
	marsRover process: 'frfr'.
	
	self assert: 'South' equals: logger window second.
	self assert: 2@2 equals: logger window first.! !


!classDefinition: #MarsRoverTest category: 'MarsRover-WithHeading'!
TestCase subclass: #MarsRoverTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:21:23'!
test01DoesNotMoveWhenNoCommand

	self 
		assertIsAt: 1@2 
		heading: self north 
		afterProcessing: '' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:28:12'!
test02IsAtFailsForDifferentPosition

	| marsRover |
	
	marsRover := MarsRover at: 1@1 heading: self north . 
	
	self deny: (marsRover isAt: 1@2 heading: self north)! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:28:31'!
test03IsAtFailsForDifferentHeading

	| marsRover |
	
	marsRover := MarsRover at: 1@1 heading: self north . 
	
	self deny: (marsRover isAt: 1@1 heading: self south)! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:30:17'!
test04IncrementsYAfterMovingForwardWhenHeadingNorth

	self 
		assertIsAt: 1@3 
		heading: self north 
		afterProcessing: 'f' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:30:11'!
test06DecrementsYAfterMovingBackwardsWhenHeadingNorth

	self 
		assertIsAt: 1@1 
		heading: self north 
		afterProcessing: 'b' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:59'!
test07PointToEashAfterRotatingRightWhenHeadingNorth

	self 
		assertIsAt: 1@2 
		heading: self east 
		afterProcessing: 'r' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:51'!
test08PointsToWestAfterRotatingLeftWhenPointingNorth

	self 
		assertIsAt: 1@2 
		heading: self west 
		afterProcessing: 'l' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:45'!
test09DoesNotProcessInvalidCommand

	| marsRover |
	
	marsRover := MarsRover at: 1@2 heading: self north.
	
	self 
		should: [ marsRover process: 'x' ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: marsRover invalidCommandErrorDescription.
			self assert: (marsRover isAt: 1@2 heading: self north) ]! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:39'!
test10CanProcessMoreThanOneCommand

	self 
		assertIsAt: 1@4 
		heading: self north 
		afterProcessing: 'ff' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:31'!
test11IncrementsXAfterMovingForwareWhenHeadingEast

	self 
		assertIsAt: 2@2 
		heading: self east 
		afterProcessing: 'f' 
		whenStartingAt: 1@2 
		heading: self east 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:19'!
test12DecrementsXAfterMovingBackwardWhenHeadingEast

	self 
		assertIsAt: 0@2 
		heading: self east 
		afterProcessing: 'b' 
		whenStartingAt: 1@2 
		heading: self east 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:14'!
test13PointsToSouthAfterRotatingRightWhenHeadingEast

		self 
		assertIsAt: 1@2 
		heading: self south 
		afterProcessing: 'r' 
		whenStartingAt: 1@2 
		heading: self east 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:05'!
test14PointsToNorthAfterRotatingLeftWhenPointingEast

		self 
		assertIsAt: 1@2 
		heading: self north 
		afterProcessing: 'l' 
		whenStartingAt: 1@2 
		heading: self east 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:00'!
test15ForwardBackwardsAndRotateRightWorkAsExpectedWhenPointingSouth

	self 
		assertIsAt: 1@1 
		heading: self west 
		afterProcessing: 'ffblrr' 
		whenStartingAt: 1@2 
		heading: self south 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:28:52'!
test16ForwardBackwardsAndRotateRightWorkAsExpectedWhenPointingWest

	self 
		assertIsAt: 0@2 
		heading: self north 
		afterProcessing: 'ffblrr' 
		whenStartingAt: 1@2 
		heading: self west 
! !


!MarsRoverTest methodsFor: 'headings' stamp: 'HAW 10/7/2021 20:09:31'!
east

	^ MarsRoverHeadingEast ! !

!MarsRoverTest methodsFor: 'headings' stamp: 'HAW 10/7/2021 20:09:38'!
north

	^ MarsRoverHeadingNorth ! !

!MarsRoverTest methodsFor: 'headings' stamp: 'HAW 10/7/2021 20:09:45'!
south

	^ MarsRoverHeadingSouth ! !

!MarsRoverTest methodsFor: 'headings' stamp: 'HAW 10/7/2021 20:09:54'!
west

	^ MarsRoverHeadingWest ! !


!MarsRoverTest methodsFor: 'assertions' stamp: 'HAW 10/7/2021 20:20:47'!
assertIsAt: newPosition heading: newHeadingType afterProcessing: commands whenStartingAt: startPosition heading: startHeadingType

	| marsRover |
	
	marsRover := MarsRover at: startPosition heading: startHeadingType. 
	
	marsRover process: commands.
	
	self assert: (marsRover isAt: newPosition heading: newHeadingType)! !


!classDefinition: #MarsRover category: 'MarsRover-WithHeading'!
Object subclass: #MarsRover
	instanceVariableNames: 'position head loggers lastChanged'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRover methodsFor: 'exceptions' stamp: 'HAW 6/30/2018 19:48:45'!
invalidCommandErrorDescription
	
	^'Invalid command'! !

!MarsRover methodsFor: 'exceptions' stamp: 'HAW 6/30/2018 19:50:26'!
signalInvalidCommand
	
	self error: self invalidCommandErrorDescription ! !


!MarsRover methodsFor: 'initialization' stamp: 'GRC 10/26/2021 15:34:18'!
initializeAt: aPosition heading: aHeadingType

	position := aPosition.
	head := aHeadingType for: self.
	loggers _ OrderedCollection new.! !


!MarsRover methodsFor: 'heading' stamp: 'GRC 10/28/2021 11:08:19'!
headEast
	
	self headTo: MarsRoverHeadingEast .! !

!MarsRover methodsFor: 'heading' stamp: 'GRC 10/28/2021 11:08:19'!
headNorth
	
	self headTo: MarsRoverHeadingNorth .! !

!MarsRover methodsFor: 'heading' stamp: 'GRC 10/28/2021 11:08:19'!
headSouth
	
	self headTo: MarsRoverHeadingSouth .! !

!MarsRover methodsFor: 'heading' stamp: 'GRC 10/28/2021 13:53:38'!
headTo: aHeading 
	
	head := aHeading for: self.
	lastChanged _ 'heading'.

	self notifyLoggers.! !

!MarsRover methodsFor: 'heading' stamp: 'GRC 10/28/2021 11:08:19'!
headWest
	
	self headTo: MarsRoverHeadingWest .! !

!MarsRover methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft
	
	head rotateLeft! !

!MarsRover methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight
	
	head rotateRight! !


!MarsRover methodsFor: 'testing' stamp: 'HAW 10/7/2021 20:16:32'!
isAt: aPosition heading: aHeadingType

	^position = aPosition and: [ head isHeading: aHeadingType ]! !

!MarsRover methodsFor: 'testing' stamp: 'HAW 7/6/2018 18:16:51'!
isBackwardCommand: aCommand

	^aCommand = $b! !

!MarsRover methodsFor: 'testing' stamp: 'HAW 7/6/2018 18:16:19'!
isForwardCommand: aCommand

	^aCommand = $f ! !

!MarsRover methodsFor: 'testing' stamp: 'HAW 7/6/2018 18:17:51'!
isRotateLeftCommand: aCommand

	^aCommand = $l! !

!MarsRover methodsFor: 'testing' stamp: 'HAW 7/6/2018 18:17:21'!
isRotateRightCommand: aCommand

	^aCommand = $r! !


!MarsRover methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward
	
	head moveBackward! !

!MarsRover methodsFor: 'moving' stamp: 'GRC 10/28/2021 13:53:38'!
moveByOffset: anOffset
	
	position := position + anOffset.
	lastChanged _ 'position'.

	self notifyLoggers.! !

!MarsRover methodsFor: 'moving' stamp: 'GRC 10/28/2021 11:09:53'!
moveEast
	
	self moveByOffset: (1@0).! !

!MarsRover methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward
	
	head moveForward! !

!MarsRover methodsFor: 'moving' stamp: 'GRC 10/28/2021 11:09:53'!
moveNorth
	
	self moveByOffset: (0@1).! !

!MarsRover methodsFor: 'moving' stamp: 'GRC 10/28/2021 11:09:53'!
moveSouth
	
	self moveByOffset: (0@-1).! !

!MarsRover methodsFor: 'moving' stamp: 'GRC 10/28/2021 11:09:53'!
moveWest
	
	self moveByOffset: (-1@0).! !


!MarsRover methodsFor: 'command processing' stamp: 'HAW 6/30/2018 19:48:26'!
process: aSequenceOfCommands

	aSequenceOfCommands do: [:aCommand | self processCommand: aCommand ]
! !

!MarsRover methodsFor: 'command processing' stamp: 'HAW 8/22/2019 12:08:50'!
processCommand: aCommand

	(self isForwardCommand: aCommand) ifTrue: [ ^ self moveForward ].
	(self isBackwardCommand: aCommand) ifTrue: [ ^ self moveBackward ].
	(self isRotateRightCommand: aCommand) ifTrue: [ ^ self rotateRight ].
	(self isRotateLeftCommand: aCommand) ifTrue: [ ^ self rotateLeft ].

	self signalInvalidCommand.! !


!MarsRover methodsFor: 'logging' stamp: 'GRC 10/28/2021 13:54:17'!
notifyLoggers

	loggers do: [:aLogger | aLogger update: self]! !

!MarsRover methodsFor: 'logging' stamp: 'GRC 10/28/2021 11:14:49'!
trackChangesTo: aLogger 
	
	loggers add: aLogger.! !


!MarsRover methodsFor: 'queries' stamp: 'GRC 10/28/2021 13:51:52'!
queryDirection: aLogger

	lastChanged = 'heading' ifTrue: [
		aLogger updateDirection: head.	
	]! !

!MarsRover methodsFor: 'queries' stamp: 'GRC 10/27/2021 16:16:22'!
queryPosition: aLogger

	lastChanged = 'position' ifTrue: [
		aLogger updatePosition: position.	
	]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRover class' category: 'MarsRover-WithHeading'!
MarsRover class
	instanceVariableNames: 'headings'!

!MarsRover class methodsFor: 'instance creation' stamp: 'HAW 10/7/2021 20:10:30'!
at: aPosition heading: aHeadingType
	
	^self new initializeAt: aPosition heading: aHeadingType! !


!classDefinition: #MarsRoverHeading category: 'MarsRover-WithHeading'!
Object subclass: #MarsRoverHeading
	instanceVariableNames: 'marsRover'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeading methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft

	self subclassResponsibility ! !

!MarsRoverHeading methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight

	self subclassResponsibility ! !


!MarsRoverHeading methodsFor: 'testing' stamp: 'HAW 10/7/2021 20:15:38'!
isHeading: aHeadingType

	^self isKindOf: aHeadingType ! !


!MarsRoverHeading methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward

	self subclassResponsibility ! !

!MarsRoverHeading methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward

	self subclassResponsibility ! !


!MarsRoverHeading methodsFor: 'initialization' stamp: 'HAW 10/7/2021 20:11:59'!
initializeFor: aMarsRover 
	
	marsRover := aMarsRover.! !


!MarsRoverHeading methodsFor: 'as yet unclassified' stamp: 'MR 10/27/2021 14:40:48'!
asText
	self subclassResponsibility.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRoverHeading class' category: 'MarsRover-WithHeading'!
MarsRoverHeading class
	instanceVariableNames: ''!

!MarsRoverHeading class methodsFor: 'instance creation' stamp: 'HAW 10/7/2021 20:11:35'!
for: aMarsRover 
	
	^self new initializeFor: aMarsRover ! !


!classDefinition: #MarsRoverHeadingEast category: 'MarsRover-WithHeading'!
MarsRoverHeading subclass: #MarsRoverHeadingEast
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingEast methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward
	
	^marsRover moveWest! !

!MarsRoverHeadingEast methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward
	
	^marsRover moveEast! !


!MarsRoverHeadingEast methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft
	
	^marsRover headNorth! !

!MarsRoverHeadingEast methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight
	
	^marsRover headSouth! !


!MarsRoverHeadingEast methodsFor: 'as yet unclassified' stamp: 'MR 10/27/2021 14:40:36'!
asText
	^'East'! !


!classDefinition: #MarsRoverHeadingNorth category: 'MarsRover-WithHeading'!
MarsRoverHeading subclass: #MarsRoverHeadingNorth
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingNorth methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward
	
	^marsRover moveSouth! !

!MarsRoverHeadingNorth methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward
	
	^marsRover moveNorth! !


!MarsRoverHeadingNorth methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft
	
	^marsRover headWest! !

!MarsRoverHeadingNorth methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight
	
	^marsRover headEast! !


!MarsRoverHeadingNorth methodsFor: 'as yet unclassified' stamp: 'MR 10/27/2021 14:40:58'!
asText
	^'North'! !


!classDefinition: #MarsRoverHeadingSouth category: 'MarsRover-WithHeading'!
MarsRoverHeading subclass: #MarsRoverHeadingSouth
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingSouth methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward
	
	^marsRover moveNorth! !

!MarsRoverHeadingSouth methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward
	
	^marsRover moveSouth! !


!MarsRoverHeadingSouth methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft
	
	^marsRover headEast! !

!MarsRoverHeadingSouth methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight
	
	^marsRover headWest! !


!MarsRoverHeadingSouth methodsFor: 'as yet unclassified' stamp: 'MR 10/27/2021 14:41:04'!
asText
	^'South'! !


!classDefinition: #MarsRoverHeadingWest category: 'MarsRover-WithHeading'!
MarsRoverHeading subclass: #MarsRoverHeadingWest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingWest methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward

	^marsRover moveEast! !

!MarsRoverHeadingWest methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward
	
	^marsRover moveWest! !


!MarsRoverHeadingWest methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft
	
	^marsRover headSouth! !

!MarsRoverHeadingWest methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight
	
	^marsRover headNorth! !


!MarsRoverHeadingWest methodsFor: 'as yet unclassified' stamp: 'MR 10/27/2021 14:41:10'!
asText
	^'West'! !


!classDefinition: #MarsRoverLogger category: 'MarsRover-WithHeading'!
Object subclass: #MarsRoverLogger
	instanceVariableNames: 'log'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverLogger methodsFor: 'updating' stamp: 'GRC 10/27/2021 17:05:33'!
addToLog: aLogEntry

	log add: aLogEntry.! !

!MarsRoverLogger methodsFor: 'updating' stamp: 'GRC 10/27/2021 16:59:45'!
update: aMarsRover

! !


!MarsRoverLogger methodsFor: 'accessing' stamp: 'GRC 10/27/2021 17:06:51'!
log

	^log.! !


!MarsRoverLogger methodsFor: 'initialization' stamp: 'GRC 10/27/2021 17:06:02'!
initialize

	log _ OrderedCollection new.! !


!classDefinition: #HeadingLogger category: 'MarsRover-WithHeading'!
MarsRoverLogger subclass: #HeadingLogger
	instanceVariableNames: 'decoratee'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!HeadingLogger methodsFor: 'accessing' stamp: 'GRC 10/27/2021 17:04:44'!
log
	^decoratee log.! !


!HeadingLogger methodsFor: 'initialization' stamp: 'GRC 10/27/2021 17:06:11'!
initializeDecorating: aMarsRoverLogger

	decoratee _ aMarsRoverLogger.! !


!HeadingLogger methodsFor: 'updating' stamp: 'GRC 10/27/2021 17:12:12'!
addToLog: aLogEntry.

	decoratee addToLog: aLogEntry.! !

!HeadingLogger methodsFor: 'updating' stamp: 'GRC 10/28/2021 13:50:34'!
update: aMarsRover

	aMarsRover queryDirection: self.
	decoratee update: aMarsRover.! !

!HeadingLogger methodsFor: 'updating' stamp: 'GRC 10/28/2021 13:52:06'!
updateDirection: aDirection

	decoratee addToLog: aDirection asText.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'HeadingLogger class' category: 'MarsRover-WithHeading'!
HeadingLogger class
	instanceVariableNames: ''!

!HeadingLogger class methodsFor: 'as yet unclassified' stamp: 'GRC 10/27/2021 17:02:02'!
decorating: aMarsRoverLogger

	^self new initializeDecorating: aMarsRoverLogger.! !


!classDefinition: #PositionLogger category: 'MarsRover-WithHeading'!
MarsRoverLogger subclass: #PositionLogger
	instanceVariableNames: 'decoratee'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!PositionLogger methodsFor: 'initialization' stamp: 'GRC 10/27/2021 17:06:21'!
initializeDecorating: aMarsRoverLogger

	decoratee _ aMarsRoverLogger.! !


!PositionLogger methodsFor: 'accessing' stamp: 'GRC 10/27/2021 17:04:54'!
log
	^decoratee log.! !


!PositionLogger methodsFor: 'updating' stamp: 'GRC 10/27/2021 17:12:01'!
addToLog: aLogEntry.

	decoratee addToLog: aLogEntry.! !

!PositionLogger methodsFor: 'updating' stamp: 'GRC 10/27/2021 17:59:30'!
update: aMarsRover

	aMarsRover queryPosition: self.
	decoratee update: aMarsRover.! !

!PositionLogger methodsFor: 'updating' stamp: 'GRC 10/27/2021 17:05:13'!
updatePosition: aPosition

	decoratee addToLog: aPosition.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PositionLogger class' category: 'MarsRover-WithHeading'!
PositionLogger class
	instanceVariableNames: ''!

!PositionLogger class methodsFor: 'as yet unclassified' stamp: 'GRC 10/27/2021 17:02:07'!
decorating: aMarsRoverLogger

	^self new initializeDecorating: aMarsRoverLogger.! !


!classDefinition: #MarsRoverStatusWindow category: 'MarsRover-WithHeading'!
Object subclass: #MarsRoverStatusWindow
	instanceVariableNames: 'window'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverStatusWindow methodsFor: 'accessing' stamp: 'GRC 10/28/2021 10:50:55'!
window

	^window.! !


!MarsRoverStatusWindow methodsFor: 'initalization' stamp: 'GRC 10/28/2021 10:52:23'!
initialize

	window _ OrderedCollection with: nil with: nil.! !


!MarsRoverStatusWindow methodsFor: 'updating' stamp: 'GRC 10/28/2021 10:54:20'!
logNewHeading: aHeading

	window at: 2 put: aHeading.
	! !

!MarsRoverStatusWindow methodsFor: 'updating' stamp: 'GRC 10/28/2021 10:54:33'!
logNewPosition: aPosition

	window at: 1 put: aPosition.! !

!MarsRoverStatusWindow methodsFor: 'updating' stamp: 'GRC 10/27/2021 17:43:16'!
update: aMarsRover! !


!classDefinition: #HeadingStatus category: 'MarsRover-WithHeading'!
MarsRoverStatusWindow subclass: #HeadingStatus
	instanceVariableNames: 'decoratee'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!HeadingStatus methodsFor: 'accessing' stamp: 'GRC 10/28/2021 11:04:16'!
window

	^decoratee window.! !


!HeadingStatus methodsFor: 'updating' stamp: 'GRC 10/27/2021 17:53:03'!
logNewHeading: aHeading

	decoratee logNewHeading: aHeading.! !

!HeadingStatus methodsFor: 'updating' stamp: 'GRC 10/27/2021 17:53:11'!
logNewPosition: aPosition

	decoratee logNewPosition: aPosition.! !

!HeadingStatus methodsFor: 'updating' stamp: 'GRC 10/27/2021 17:31:46'!
update: aMarsRover

	aMarsRover queryDirection: self.
	decoratee update: aMarsRover.! !

!HeadingStatus methodsFor: 'updating' stamp: 'GRC 10/28/2021 13:52:15'!
updateDirection: aDirection

	decoratee logNewHeading: aDirection asText.! !


!HeadingStatus methodsFor: 'initialization' stamp: 'GRC 10/27/2021 17:35:20'!
initializeDecorating: aMarsRoverWindowLogger 
	
	decoratee _ aMarsRoverWindowLogger.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'HeadingStatus class' category: 'MarsRover-WithHeading'!
HeadingStatus class
	instanceVariableNames: ''!

!HeadingStatus class methodsFor: 'as yet unclassified' stamp: 'GRC 10/27/2021 17:30:55'!
decorating: aMarsRoverWindowLogger

	^self new initializeDecorating: aMarsRoverWindowLogger.! !


!classDefinition: #PositionStatus category: 'MarsRover-WithHeading'!
MarsRoverStatusWindow subclass: #PositionStatus
	instanceVariableNames: 'decoratee'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!PositionStatus methodsFor: 'accessing' stamp: 'GRC 10/28/2021 11:04:50'!
window

	^decoratee window.! !


!PositionStatus methodsFor: 'updating' stamp: 'GRC 10/27/2021 17:51:53'!
logNewHeading: aHeading

	decoratee logNewHeading: aHeading.! !

!PositionStatus methodsFor: 'updating' stamp: 'GRC 10/27/2021 17:52:19'!
logNewPosition: aPosition

	decoratee logNewPosition: aPosition.! !

!PositionStatus methodsFor: 'updating' stamp: 'GRC 10/27/2021 17:31:59'!
update: aMarsRover

	aMarsRover queryPosition: self.
	decoratee update: aMarsRover.! !

!PositionStatus methodsFor: 'updating' stamp: 'GRC 10/27/2021 17:38:42'!
updatePosition: aPosition

	decoratee logNewPosition: aPosition.! !


!PositionStatus methodsFor: 'initialization' stamp: 'GRC 10/27/2021 17:36:38'!
initializeDecorating: aMarsRoverWindowLogger 

	decoratee _ aMarsRoverWindowLogger.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PositionStatus class' category: 'MarsRover-WithHeading'!
PositionStatus class
	instanceVariableNames: ''!

!PositionStatus class methodsFor: 'as yet unclassified' stamp: 'GRC 10/27/2021 17:30:59'!
decorating: aMarsRoverWindowLogger

	^self new initializeDecorating: aMarsRoverWindowLogger.! !
